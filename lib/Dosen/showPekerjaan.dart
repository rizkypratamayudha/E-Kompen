import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Model/dosen_pekerjaan_model.dart';
import '../controller/dosen_pekerjaan_service.dart';
import '../Model/kompetensi_admin_model.dart';
import 'package:intl/intl.dart';

class ShowPekerjaanPage extends StatefulWidget {
  final int pekerjaanId;
  final String pekerjaanNama;

  const ShowPekerjaanPage({
    Key? key,
    required this.pekerjaanId,
    required this.pekerjaanNama,
  }) : super(key: key);

  @override
  _ShowPekerjaanPageState createState() => _ShowPekerjaanPageState();
}

class _ShowPekerjaanPageState extends State<ShowPekerjaanPage> {
  late Future<PekerjaanDetail> _futurePekerjaanDetail;
  bool _isAkumulasiVisible = false;

  @override
  void initState() {
    super.initState();
    _futurePekerjaanDetail =
        _fetchPekerjaanDetailWithKompetensi(widget.pekerjaanId);
  }

  Future<PekerjaanDetail> _fetchPekerjaanDetailWithKompetensi(
      int pekerjaanId) async {
    final pekerjaanDetail =
        await DosenBuatPekerjaanService().fetchPekerjaanDetail(pekerjaanId);
    final kompetensiAdminList =
        await DosenBuatPekerjaanService().fetchKompetensiAdmin();

    // Gabungkan data kompetensi
    final updatedKompetensi = pekerjaanDetail.kompetensi.map((k) {
      final kompetensiNama = kompetensiAdminList
          .firstWhere(
            (ka) => ka.id == k.kompetensiAdminId,
            orElse: () => KompetensiAdmin(
                id: k.kompetensiAdminId, nama: "Tidak ditemukan"),
          )
          .nama;
      return AmbilKompetensi(
        id: k.id,
        kompetensiAdminId: k.kompetensiAdminId,
        namaKompetensi: kompetensiNama,
      );
    }).toList();

    return PekerjaanDetail(
      pekerjaan: pekerjaanDetail.pekerjaan,
      deskripsiTugas: pekerjaanDetail.deskripsiTugas,
      jumlahAnggota: pekerjaanDetail.jumlahAnggota,
      persyaratan: pekerjaanDetail.persyaratan,
      progress: pekerjaanDetail.progress,
      kompetensi: updatedKompetensi,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detail Pekerjaan: ${widget.pekerjaanNama}',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 14, // Atur ukuran font sesuai keinginan Anda
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 80, // Memberi ruang untuk tombol floating di bawah
            child: FutureBuilder<PekerjaanDetail>(
              future: _futurePekerjaanDetail,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: GoogleFonts.poppins(color: Colors.red),
                    ),
                  );
                } else if (snapshot.hasData) {
                  final pekerjaanDetail = snapshot.data!;
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildReadonlyBox('Jenis Tugas',
                            pekerjaanDetail.pekerjaan.jenisPekerjaan),
                        const SizedBox(height: 10),
                        _buildReadonlyBox('Nama Pekerjaan',
                            pekerjaanDetail.pekerjaan.pekerjaanNama),
                        const SizedBox(height: 10),
                        _buildReadonlyBox('Jumlah Anggota',
                            pekerjaanDetail.jumlahAnggota.toString()),
                        const SizedBox(height: 10),
                        _buildReadonlyBox(
                            'Deskripsi Tugas', pekerjaanDetail.deskripsiTugas),
                        const SizedBox(height: 10),
                        const Divider(color: Colors.black),
                        const SizedBox(height: 10),
                        _buildJumlahBox('Jumlah Persyaratan',
                            pekerjaanDetail.persyaratan.length.toString()),
                        const SizedBox(height: 10),
                        Column(
                          children: [
                            const Divider(color: Colors.black),
                            const SizedBox(height: 10),
                            pekerjaanDetail.persyaratan.isEmpty
                                ? Column(
                                    children: [
                                      Container(
                                        width: 320,
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.blue[
                                              100], // Warna latar belakang biru muda
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          'Pekerjaan ini tidak memiliki persyaratan yang dibutuhkan.',
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            fontWeight:
                                                FontWeight.bold, // Tulisan bold
                                            color: Colors.blue[
                                                900], // Warna teks biru gelap
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                          height:
                                              10), // Jarak tambahan di bawah teks
                                    ],
                                  )
                                : Column(
                                    children: [
                                      ..._buildNumberedItems(
                                          pekerjaanDetail.persyaratan,
                                          'Persyaratan',
                                          (p) => p.nama),
                                    ],
                                  ),
                          ],
                        ),
                        const Divider(color: Colors.black),
                        const SizedBox(height: 10),
                        _buildJumlahBox('Jumlah Kompetensi',
                            pekerjaanDetail.kompetensi.length.toString()),
                        const SizedBox(height: 10),
                        Column(
                          children: [
                            const Divider(color: Colors.black),
                            const SizedBox(height: 10),
                            pekerjaanDetail.kompetensi.isEmpty
                                ? Column(
                                    children: [
                                      Container(
                                        width: 320,
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.blue[
                                              100], // Warna latar belakang biru muda
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          'Pekerjaan ini tidak memiliki kompetensi yang dibutuhkan.',
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            fontWeight:
                                                FontWeight.bold, // Tulisan bold
                                            color: Colors.blue[
                                                900], // Warna teks biru gelap
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                          height:
                                              10), // Jarak tambahan di bawah teks
                                    ],
                                  )
                                : Column(
                                    children: [
                                      ..._buildNumberedItems(
                                        pekerjaanDetail.kompetensi,
                                        'Kompetensi',
                                        (k) => k.namaKompetensi,
                                      ),
                                    ],
                                  ),
                          ],
                        ),
                        const Divider(color: Colors.black),
                        const SizedBox(height: 10),
                        _buildJumlahBox('Jumlah Progres',
                            pekerjaanDetail.progress.length.toString()),
                        const SizedBox(height: 10),
                        const Divider(color: Colors.black),
                        ..._buildProgressItems(pekerjaanDetail.progress),
                      ],
                    ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          if (_isAkumulasiVisible)
            FutureBuilder<PekerjaanDetail>(
              future: _futurePekerjaanDetail,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final pekerjaanDetail = snapshot.data!;
                  final akumulasi = _buildAkumulasi(pekerjaanDetail.progress);

                  return Positioned(
                    bottom: 80,
                    left: (MediaQuery.of(context).size.width - 350) / 2,
                    child: Container(
                      width: 350,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors
                                .black54, // Warna bayangan lebih gelap sedikit
                            blurRadius: 10, // Menyebarkan bayangan lebih jauh
                            spreadRadius: 2, // Menambah ukuran bayangan
                            offset: Offset(0,
                                10), // Menambahkan offset untuk efek realistis
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDataAkumulasiBox('Total Jam                  :',
                              '${akumulasi['totalJam']} jam'),
                          _buildDataAkumulasiBox(
                            'Batas Pengerjaan  :',
                            DateFormat('yyyy-MM-dd HH:mm:ss')
                                .format(akumulasi['batasPengerjaan']),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
        ],
      ),
      floatingActionButton: Container(
        width: 360,
        height: 50,
        child: FloatingActionButton.extended(
          onPressed: () {
            setState(() {
              _isAkumulasiVisible = !_isAkumulasiVisible;
            });
          },
          backgroundColor: Colors.blue,
          label: Text(
            'Akumulasi',
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
          ),
          icon: Icon(
            _isAkumulasiVisible ? Icons.arrow_downward : Icons.arrow_upward,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  /// Fungsi untuk menghitung akumulasi total jam dan batas pengerjaan.
  Map<String, dynamic> _buildAkumulasi(List<AmbilProgres> progressList) {
    final totalJam = progressList.fold(0, (sum, item) => sum + item.jumlahJam);
    final batasPengerjaan = progressList.isNotEmpty
        ? progressList.last.deadline ?? DateTime.now()
        : DateTime.now();

    return {
      'totalJam': totalJam,
      'batasPengerjaan': batasPengerjaan,
    };
  }

  Widget _buildReadonlyBox(String title, String value) {
    return FractionallySizedBox(
      widthFactor: 0.9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 30,
            decoration: const BoxDecoration(
              color: Color(0xFFF4D03F),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(
              minHeight: 60,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFF1A6FD3),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildNumberedItems<T>(
    List<T> items,
    String title,
    String Function(T) displayValue,
  ) {
    return List.generate(
      items.length,
      (index) => Column(
        children: [
          _buildReadonlyBox('$title ${index + 1}', displayValue(items[index])),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  List<Widget> _buildProgressItems(List<AmbilProgres> progressList) {
    return List.generate(progressList.length, (index) {
      final prog = progressList[index];
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bagian atas (header kuning)
            Container(
              width: double.infinity,
              height: 30,
              decoration: const BoxDecoration(
                color: Color(0xFFF4D03F),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'Progres ${index + 1}', // Menampilkan nomor progres
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            // Bagian bawah (konten biru dengan ikon)
            Container(
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 60),
              decoration: const BoxDecoration(
                color: Color(0xFF1A6FD3),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.task_alt, color: Colors.white),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Progres Nama: ${prog.judulProgres}',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white),
                  Row(
                    children: [
                      const Icon(Icons.timer, color: Colors.white),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Jam Kompen: ${prog.jumlahJam} jam',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.white),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Hari yang Diperlukan: ${prog.jumlahHari} hari',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white),
                  Row(
                    children: [
                      const Icon(Icons.date_range, color: Colors.white),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Deadline: ${prog.formattedDeadline}',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildJumlahBox(String title, String value) {
    return FractionallySizedBox(
      widthFactor: 0.9, // Menentukan lebar relatif terhadap layar
      child: Container(
        padding:
            const EdgeInsets.all(16), // Padding agar teks tidak terlalu rapat
        decoration: BoxDecoration(
          color: const Color(0xFF6FC9D9), // Warna biru muda
          borderRadius: BorderRadius.circular(10), // Sudut membulat
        ),
        alignment: Alignment
            .center, // Teks berada di tengah secara horizontal dan vertikal
        child: Text(
          '$title: $value', // Format teks (misalnya: "Jumlah Progress: 4")
          style: GoogleFonts.poppins(
            fontSize: 16, // Ukuran font
            fontWeight: FontWeight.bold, // Teks bold
            color: Colors.black, // Warna teks hitam
          ),
          textAlign: TextAlign.center, // Teks di tengah
        ),
      ),
    );
  }

  Widget _buildDataAkumulasiBox(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 6,
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: Text(
              value,
              style: GoogleFonts.poppins(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
