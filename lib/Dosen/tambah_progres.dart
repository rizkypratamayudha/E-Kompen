import 'package:firstapp/Dosen/pekerjaan.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/dosen_pekerjaan_service.dart';
import '../Model/dosen_pekerjaan_model.dart';
import 'package:intl/intl.dart';

class TambahProgresPage extends StatefulWidget {
  final Map<String, dynamic> pekerjaanData;

  const TambahProgresPage({super.key, required this.pekerjaanData});

  @override
  _TambahProgresPageState createState() => _TambahProgresPageState();
}

class _TambahProgresPageState extends State<TambahProgresPage> {
  final _formKey = GlobalKey<FormState>();
  final List<Map<String, dynamic>> _progressData = [];
  final DosenBuatPekerjaanService pekerjaanService =
      DosenBuatPekerjaanService();

  late int userId;

  int get _progressCount => widget.pekerjaanData['jumlahProgress'];

  @override
  void initState() {
    super.initState();
    // Inisialisasi progressData sesuai jumlah progress
    for (int i = 0; i < _progressCount; i++) {
      _progressData.add({
        'judulProgress': '',
        'jumlahJam': '',
        'hariDiperlukan': '',
      });
    }
    // Pastikan userId sesuai tipe data
    userId = int.parse(widget.pekerjaanData['userId'].toString());
  }

  Future<void> _saveData() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Ambil data pekerjaan dari widget
        final pekerjaanData = widget.pekerjaanData;

        // Konversi data pekerjaan dan progress menjadi DosenPekerjaanCreateRequest
        final request = DosenPekerjaanCreateRequest(
          userId: userId,
          jenisPekerjaan: pekerjaanData['jenisTugas'],
          pekerjaanNama: pekerjaanData['nama'],
          jumlahAnggota: pekerjaanData['jumlahAnggota'],
          deskripsiTugas: pekerjaanData['deskripsi'],
          persyaratan: List<String>.from(pekerjaanData['persyaratan']),
          progress: _progressData.map((progress) {
            final jumlahJam = int.tryParse(progress['jumlahJam'] ?? '');
            final hariDiperlukan =
                int.tryParse(progress['hariDiperlukan'] ?? '');

            if (jumlahJam == null || hariDiperlukan == null) {
              throw Exception(
                  'Jumlah Jam dan Hari Diperlukan harus berupa angka');
            }

            return ProgressItem(
              judulProgres: progress['judulProgress'],
              jumlahJam: jumlahJam,
              jumlahHari: hariDiperlukan,
            );
          }).toList(),
        );

        // Kirim request ke server
        await pekerjaanService.tambahPekerjaan(request);

        // Tampilkan notifikasi berhasil
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Data tambah pekerjaan berhasil terkirim'),
        ));

        // Navigasi ke halaman pekerjaan.dart
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PekerjaanDosenPage()),
        );
      } catch (e) {
        // Tampilkan notifikasi error
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Gagal menyimpan pekerjaan: $e'),
        ));
      }
    }
  }

  void _tampilkanAkumulasi() {
  // Hitung jumlah jam akumulasi dari progressData
  int totalJam = 0;
  for (var progress in _progressData) {
    final jumlahJam = int.tryParse(progress['jumlahJam'] ?? '0') ?? 0;
    totalJam += jumlahJam;
  }

  // Hitung tanggal batas pengerjaan dengan menambahkan hari
  DateTime now = DateTime.now();
  int totalHari = 0;
  for (var progress in _progressData) {
    final hari = int.tryParse(progress['hariDiperlukan'] ?? '0') ?? 0;
    totalHari += hari;
  }
  DateTime batasPengerjaan = now.add(Duration(days: totalHari));

  // Format batas pengerjaan menjadi 'yyyy-MM-dd HH:mm:ss'
  String formattedBatasPengerjaan =
      DateFormat('yyyy-MM-dd HH:mm:ss').format(batasPengerjaan);

  // Tampilkan Bottom Sheet dengan hasil perhitungan
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(14.0),
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Jumlah Jam:',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '$totalJam jam',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(14.0),
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Batas Pengerjaan:',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    formattedBatasPengerjaan,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _saveData();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Simpan',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}


  Widget _buildProgressForm(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.blueAccent),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            'Progress ${index + 1}',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Judul Progress',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Mohon masukkan judul progress';
              }
              return null;
            },
            onChanged: (value) {
              _progressData[index]['judulProgress'] = value;
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Jumlah Jam',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              suffixIcon: const Icon(Icons.access_time),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Mohon masukkan jumlah jam';
              }
              if (int.tryParse(value) == null) {
                return 'Jumlah jam harus berupa angka';
              }
              return null;
            },
            onChanged: (value) {
              _progressData[index]['jumlahJam'] = value;
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Hari yang diperlukan',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              suffixIcon: const Icon(Icons.calendar_today),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Mohon masukkan hari yang diperlukan';
              }
              if (int.tryParse(value) == null) {
                return 'Hari yang diperlukan harus berupa angka';
              }
              return null;
            },
            onChanged: (value) {
              _progressData[index]['hariDiperlukan'] = value;
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Tambah Progress',
          style: GoogleFonts.poppins(fontSize: 20),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 20,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF84F2F9),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black),
              ),
              child: Center(
                child: Text(
                  'Jumlah Progress: $_progressCount',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 80,
            left: 0,
            right: 0,
            bottom: 80,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    for (int i = 0; i < _progressCount; i++)
                      _buildProgressForm(i),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 15,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width *
                      0.8, // 80% dari lebar layar
                      height: 50,
                  child: ElevatedButton(
                    onPressed: _tampilkanAkumulasi,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceBetween, // Tulisan di kiri, ikon di kanan
                      children: [
                        Text(
                          'Akumulasi',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        const Icon(
                          Icons.arrow_upward, // Ikon panah ke atas
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
