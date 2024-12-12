import 'package:flutter/material.dart';
import '../Model/dosen_pekerjaan_model.dart';
import '../controller/dosen_pekerjaan_service.dart';
import '../Model/kompetensi_admin_model.dart';
import 'package:google_fonts/google_fonts.dart';

class EditPekerjaanPage extends StatefulWidget {
  final int pekerjaanId;
  final String pekerjaanNama;

  const EditPekerjaanPage({
    Key? key,
    required this.pekerjaanId,
    required this.pekerjaanNama,
  }) : super(key: key);

  @override
  _EditPekerjaanPageState createState() => _EditPekerjaanPageState();
}

class _EditPekerjaanPageState extends State<EditPekerjaanPage> {
  final TextEditingController jenisPekerjaanController =
      TextEditingController();
  final TextEditingController namaPekerjaanController = TextEditingController();
  final TextEditingController jumlahAnggotaController = TextEditingController();
  final TextEditingController deskripsiTugasController =
      TextEditingController();

  List<UpdatePersyaratanItem> persyaratan = [];
  List<UpdateProgressItem> progress = [];
  List<UpdateKompetensiItem> kompetensi = [];
  List<KompetensiAdmin> kompetensiAdminList = []; // Untuk dropdown

  final DosenBuatPekerjaanService service = DosenBuatPekerjaanService();

  @override
  void initState() {
    super.initState();
    fetchPekerjaanData();
  }

  Future<void> fetchPekerjaanData() async {
    try {
      // Ambil detail pekerjaan
      final PekerjaanDetail detail =
          await service.fetchPekerjaanDetail(widget.pekerjaanId);

      // Ambil daftar kompetensi dari server
      final List<KompetensiAdmin> kompetensiAdmin =
          await service.fetchKompetensiAdmin();

      setState(() {
        jenisPekerjaanController.text = detail.pekerjaan.jenisPekerjaan;
        namaPekerjaanController.text = detail.pekerjaan.pekerjaanNama;
        jumlahAnggotaController.text = detail.jumlahAnggota.toString();
        deskripsiTugasController.text = detail.deskripsiTugas;

        persyaratan = List<UpdatePersyaratanItem>.from(
          detail.persyaratan.map((item) => UpdatePersyaratanItem(
                id: item.id,
                nama: item.nama,
              )),
        );

        progress = List<UpdateProgressItem>.from(
          detail.progress.map((item) => UpdateProgressItem(
                id: item.id,
                judulProgres: item.judulProgres,
                jumlahJam: item.jumlahJam,
                jumlahHari: item.jumlahHari,
              )),
        );

        kompetensi = List<UpdateKompetensiItem>.from(
          detail.kompetensi.map((item) => UpdateKompetensiItem(
                id: item.id,
                kompetensiAdminId: item.kompetensiAdminId,
              )),
        );

        // Simpan daftar kompetensi admin
        kompetensiAdminList = kompetensiAdmin;
      });
    } catch (e) {
      print("Error fetching data: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Gagal memuat data pekerjaan")));
    }
  }

  Widget _buildKompetensiDropdown(UpdateKompetensiItem item, int index) {
    return DropdownButtonFormField<int>(
      value: item.kompetensiAdminId,
      items: kompetensiAdminList.map((kompetensiAdmin) {
        return DropdownMenuItem<int>(
          value: kompetensiAdmin.id,
          child: Text(kompetensiAdmin.nama),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          kompetensi[index] = UpdateKompetensiItem(
            id: item.id,
            kompetensiAdminId: value ?? 0,
          );
        });
      },
      decoration: InputDecoration(labelText: "Kompetensi ${index + 1}"),
    );
  }

  Future<void> confirmAndDeletePersyaratan(int index) async {
    final bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Konfirmasi"),
        content: Text(
            "Apakah Anda yakin ingin menghapus persyaratan ke-${index + 1}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("Tidak"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text("Ya"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final deletedItem = persyaratan[index];

        // Jika item memiliki ID, hapus di server terlebih dahulu
        if (deletedItem.id != null) {
          final success = await service.deletePersyaratan(
              widget.pekerjaanId, deletedItem.id!);
          if (!success) {
            throw Exception("Gagal menghapus persyaratan di server");
          }
        }

        // Setelah berhasil dihapus (atau jika item belum ada di server), hapus dari daftar lokal
        setState(() {
          persyaratan.removeAt(index);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Persyaratan berhasil dihapus")),
        );
      } catch (e) {
        print("Error deleting persyaratan: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal menghapus persyaratan: $e")),
        );
      }
    }
  }

  Future<void> confirmAndDeleteProgress(int index) async {
    if (progress.length == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "Progres tidak bisa dihapus, pekerjaan minimal harus memiliki 1 progres"),
        ),
      );
      return;
    }

    final bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Konfirmasi"),
        content:
            Text("Apakah Anda yakin ingin menghapus progres ke-${index + 1}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("Tidak"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text("Ya"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final deletedItem = progress[index];
        if (deletedItem.id != null) {
          await service.deleteProgres(widget.pekerjaanId, deletedItem.id!);
        }
        setState(() {
          progress.removeAt(index);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Progres berhasil dihapus")),
        );
      } catch (e) {
        print("Error deleting progres: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal menghapus progres")),
        );
      }
    }
  }

  Future<void> confirmAndDeleteKompetensi(int index) async {
    final bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Konfirmasi"),
        content: Text(
            "Apakah Anda yakin ingin menghapus Kompetensi ke-${index + 1}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("Tidak"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text("Ya"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final deletedItem = kompetensi[index];
        // Pastikan id tidak null sebelum menghapus di server
        if (deletedItem.id != null) {
          await service.deleteKompetensi(widget.pekerjaanId, deletedItem.id!);
        }
        // Hapus dari daftar lokal
        setState(() {
          kompetensi.removeAt(index);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Kompetensi berhasil dihapus")),
        );
      } catch (e) {
        print("Error deleting kompetensi: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal menghapus kompetensi")),
        );
      }
    }
  }

  Future<void> savePekerjaan() async {
    try {
      // Buat request dari data yang ada
      final request = DosenPekerjaanUpdateRequest(
        jenisPekerjaan: jenisPekerjaanController.text,
        pekerjaanNama: namaPekerjaanController.text,
        jumlahAnggota: int.parse(jumlahAnggotaController.text),
        deskripsiTugas: deskripsiTugasController.text,
        persyaratan: persyaratan,
        progress: progress,
        kompetensi: kompetensi,
      );

      // Log payload yang dikirim
      print("Payload yang dikirim: ${request.toJson()}");

      // Panggil service untuk memperbarui data
      final success =
          await service.updatePekerjaan(widget.pekerjaanId, request);

      if (success) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Data berhasil disimpan!")));
        Navigator.pop(context); // Kembali ke halaman sebelumnya
      } else {
        throw Exception("Update API response tidak berhasil");
      }
    } catch (e) {
      // Log error dan tampilkan pesan kesalahan
      print("Error saving data: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Gagal menyimpan data: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text(
        "Edit Pekerjaan: ${namaPekerjaanController.text.isNotEmpty ? namaPekerjaanController.text : 'Pekerjaan'}",
        style: GoogleFonts.poppins(),
      ),
    ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Jenis Tugas:",
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            DropdownButtonFormField<String>(
              value: jenisPekerjaanController.text.isNotEmpty
                  ? jenisPekerjaanController.text[0].toUpperCase() +
                      jenisPekerjaanController.text.substring(1).toLowerCase()
                  : null,
              onChanged: (value) {
                setState(() {
                  jenisPekerjaanController.text = value?.toLowerCase() ?? "";
                });
              },
              items: [
                DropdownMenuItem(
                  value: "Teknis",
                  child: Text("Teknis", style: GoogleFonts.poppins()),
                ),
                DropdownMenuItem(
                  value: "Pengabdian",
                  child: Text("Pengabdian", style: GoogleFonts.poppins()),
                ),
                DropdownMenuItem(
                  value: "Penelitian",
                  child: Text("Penelitian", style: GoogleFonts.poppins()),
                ),
              ],
              decoration: InputDecoration(
                labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Nama Pekerjaan:",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                TextField(
                  controller: namaPekerjaanController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  style: GoogleFonts.poppins(),
                ),
              ],
            ),
            SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Jumlah Anggota:",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                TextField(
                  controller: jumlahAnggotaController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  keyboardType: TextInputType.number,
                  style: GoogleFonts.poppins(),
                ),
              ],
            ),
            SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Deskripsi Tugas:",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                TextField(
                  controller: deskripsiTugasController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  maxLines: 3,
                  style: GoogleFonts.poppins(),
                ),
              ],
            ),
            SizedBox(height: 15),
            Divider(color: Colors.black, thickness: 2.0),
            SizedBox(height: 15),
            _buildDynamicBoxPersyaratan(
              title: "Persyaratan",
              items: persyaratan,
              onAdd: () {
                setState(() {
                  persyaratan.add(UpdatePersyaratanItem(id: null, nama: ''));
                });
              },
              onDelete: (index) => confirmAndDeletePersyaratan(index),
              itemBuilder: (item, index) {
                return TextFormField(
                  maxLines: null,
                  initialValue: item.nama,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (value) => setState(() {
                    item.nama = value;
                  }),
                  style: GoogleFonts.poppins(),
                );
              },
            ),
            if (persyaratan.isEmpty)
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue[100], // Warna latar belakang biru muda
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "Pekerjaan ini tidak memiliki persyaratan yang dibutuhkan",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.bold, // Tulisan bold
                    color: Colors.blue[900], // Warna teks biru gelap
                  ),
                ),
              ),
            SizedBox(height: 15),
            Divider(color: Colors.black, thickness: 2.0),
            SizedBox(height: 15),
            // Kompetensi dalam bentuk dropdown
            _buildDynamicBoxKompetensi(
              title: "Kompetensi",
              items: kompetensi,
              onAdd: () {
                setState(() {
                  final defaultKompetensiAdminId =
                      kompetensiAdminList.isNotEmpty
                          ? kompetensiAdminList.first.id
                          : null;

                  kompetensi.add(UpdateKompetensiItem(
                    id: null,
                    kompetensiAdminId: defaultKompetensiAdminId ?? 0,
                  ));
                });
              },
              onDelete: (index) => confirmAndDeleteKompetensi(index),
              itemBuilder: _buildKompetensiDropdown,
            ),
            if (kompetensi.isEmpty)
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue[100], // Warna latar belakang biru muda
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "Pekerjaan ini tidak memiliki kompetensi yang dibutuhkan",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.bold, // Tulisan bold
                    color: Colors.blue[900], // Warna teks biru gelap
                  ),
                ),
              ),
            SizedBox(height: 15),
            Divider(color: Colors.black, thickness: 2.0),
            SizedBox(height: 15),
            _buildDynamicBoxProgres(
              title: "Progres",
              items: progress,
              onAdd: () {
                setState(() {
                  progress.add(UpdateProgressItem(
                    id: null,
                    judulProgres: '',
                    jumlahJam: 0,
                    jumlahHari: 0,
                  ));
                });
              },
              onDelete: (index) => confirmAndDeleteProgress(index),
              itemBuilder: (item, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller:
                          TextEditingController(text: item.judulProgres),
                      onChanged: (value) => item.judulProgres = value,
                      decoration: InputDecoration(labelText: "Judul Progres:"),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: TextEditingController(
                          text: item.jumlahJam.toString()),
                      onChanged: (value) =>
                          item.jumlahJam = int.tryParse(value) ?? 0,
                      decoration: InputDecoration(labelText: "Jam Kompen:"),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: TextEditingController(
                          text: item.jumlahHari.toString()),
                      onChanged: (value) =>
                          item.jumlahHari = int.tryParse(value) ?? 0,
                      decoration: InputDecoration(labelText: "Hari yang diperlukan:"),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                );
              },
            ),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.end, // Menempatkan tombol di kanan
              children: [
                ElevatedButton(
                  onPressed: savePekerjaan,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Warna tombol
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Radius sudut
                    ),
                    minimumSize: Size(100, 40), // Ukuran minimum tombol
                  ),
                  child: Text(
                    'Simpan',
                    style:
                        GoogleFonts.poppins(color: Colors.white), // Gaya teks
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDynamicBoxPersyaratan<T>({
    required String title,
    required List<T> items,
    required VoidCallback onAdd,
    required void Function(int) onDelete,
    required Widget Function(T, int) itemBuilder,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.43,
              height: 50.0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                decoration: BoxDecoration(
                  color: Color(0xFF84F2F9), // Warna background biru muda
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    "$title: ${items.length}",
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.0),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.43,
              height: 50.0,
              child: ElevatedButton.icon(
                onPressed: onAdd,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: Icon(Icons.add, color: Colors.white),
                label: Text(
                  'Tambah\nPersyaratan',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        for (int i = 0; i < items.length; i++) ...[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Persyaratan ${i + 1}',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 8.0),
              Row(
                children: [
                  Expanded(
                    child: itemBuilder(items[i], i),
                  ),
                  SizedBox(width: 10.0),
                  SizedBox(
                    height: 50.0,
                    child: ElevatedButton(
                      onPressed: () => onDelete(i),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Icon(Icons.close, color: Colors.white),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildDynamicBoxKompetensi({
    required String title,
    required List<UpdateKompetensiItem> items,
    required VoidCallback onAdd,
    required void Function(int) onDelete,
    required Widget Function(UpdateKompetensiItem item, int index) itemBuilder,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.43,
              height: 50.0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF84F2F9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    "$title: ${items.length}",
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.0),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.43,
              height: 50.0,
              child: ElevatedButton.icon(
                onPressed: onAdd,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.add, color: Colors.white),
                label: Text(
                  "Tambah\nKompetensi",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Column(
          children: items.asMap().entries.map((entry) {
            final int index = entry.key;
            final UpdateKompetensiItem item = entry.value;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kompetensi ${index + 1}',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 8.0),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        value: item.kompetensiAdminId,
                        items: kompetensiAdminList.map((kompetensiAdmin) {
                          return DropdownMenuItem<int>(
                            value: kompetensiAdmin.id,
                            child: Text(kompetensiAdmin.nama),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            items[index] = UpdateKompetensiItem(
                              id: item.id,
                              kompetensiAdminId: value ?? 0,
                            );
                          });
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.0),
                    SizedBox(
                      height: 50.0,
                      child: ElevatedButton(
                        onPressed: () => onDelete(index),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Icon(Icons.close, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDynamicBoxProgres<T>({
    required String title,
    required List<T> items,
    required VoidCallback onAdd,
    required void Function(int) onDelete,
    required Widget Function(T, int) itemBuilder,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.43,
              height: 50.0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                decoration: BoxDecoration(
                  color: Color(0xFF84F2F9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    "$title: ${items.length}",
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.0),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.43,
              height: 50.0,
              child: ElevatedButton.icon(
                onPressed: onAdd,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: Icon(Icons.add, color: Colors.white),
                label: Text(
                  'Tambah\nProgres',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        for (int i = 0; i < items.length; i++)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Colors.red[200],
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Text(
                              'Progres ${i + 1}',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              width: 25,
                              height: 25,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: Icon(Icons.close,
                                    color: Colors.white, size: 16),
                                onPressed: () => onDelete(i),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red.shade200, width: 2.0),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Judul Progres Input
                    Text(
                      "Judul Progres:",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.0),
                    TextField(
                      controller: TextEditingController(
                          text: (items[i] as UpdateProgressItem).judulProgres),
                      onChanged: (value) {
                        (items[i] as UpdateProgressItem).judulProgres = value;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      style: GoogleFonts.poppins(),
                    ),
                    SizedBox(height: 15),
                    // Jam Kompen Input
                    Text(
                      "Jam Kompen:",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.0),
                    TextField(
                      controller: TextEditingController(
                          text: (items[i] as UpdateProgressItem)
                              .jumlahJam
                              .toString()),
                      onChanged: (value) {
                        (items[i] as UpdateProgressItem).jumlahJam =
                            int.tryParse(value) ?? 0;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.poppins(),
                    ),
                    SizedBox(height: 15),
                    Text(
                      "Hari yang diperlukan:",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.0),
                    TextField(
                      controller: TextEditingController(
                          text: (items[i] as UpdateProgressItem)
                              .jumlahHari
                              .toString()),
                      onChanged: (value) {
                        (items[i] as UpdateProgressItem).jumlahHari =
                            int.tryParse(value) ?? 0;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.poppins(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
      ],
    );
  }
}
