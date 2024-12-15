import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/dosen_pekerjaan_service.dart';
import '../Model/dosen_pekerjaan_model.dart';
import 'pekerjaan.dart';

class LihatDaftarMahasiswa extends StatefulWidget {
  final int pekerjaanId;
  final String pekerjaanNama;

  const LihatDaftarMahasiswa({
    Key? key,
    required this.pekerjaanId,
    required this.pekerjaanNama,
  }) : super(key: key);

  @override
  State<LihatDaftarMahasiswa> createState() => _LihatDaftarMahasiswaState();
}

class _LihatDaftarMahasiswaState extends State<LihatDaftarMahasiswa> {
  final DosenBuatPekerjaanService _service = DosenBuatPekerjaanService();
  List<DosenPekerjaanModel> anggota = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final data = await _service.fetchDaftarMahasiswa(widget.pekerjaanId);
      setState(() {
        anggota = data;
        isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        anggota = [];
        isLoading = false;
      });
    }
  }

  Future<void> _kickMahasiswa(int pekerjaanId, int userId, String nama) async {
    try {
      await _service.kickMahasiswa(pekerjaanId, userId);
      setState(() {
        anggota.removeWhere((item) => item.userId == userId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$nama berhasil dikeluarkan dari pekerjaan'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menghapus $nama: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _confirmKickMahasiswa(
      int pekerjaanId, int userId, String nama) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Konfirmasi Penghapusan',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Setelah mengkick mahasiswa $nama, maka mahasiswa $nama akan dikeluarkan dari pekerjaan ${widget.pekerjaanNama}. Apakah anda yakin ingin megkick mahasiswa $nama dari pekerjaan ${widget.pekerjaanNama}?',
            style: GoogleFonts.poppins(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // Tutup dialog
              child: Text(
                'Batal',
                style: GoogleFonts.poppins(color: Colors.blue, fontSize: 14),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true), // Konfirmasi
              child: Text(
                'Ya',
                style: GoogleFonts.poppins(color: Colors.red, fontSize: 14),
              ),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      // Jika pengguna memilih 'Ya'
      await _kickMahasiswa(pekerjaanId, userId, nama);
    }
  }

  Widget _buildDetailContainer(String nama, String nim, String periode,
      String email, String noHp, int userId) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                nama,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: const Color(0xFFF8D302),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Divider(color: Colors.white, thickness: 2),
              _buildDetailRow('Nim', nim),
              _buildDetailRow('Periode', periode),
              _buildDetailRow('Email', email),
              _buildDetailRow('No hp', noHp),
            ],
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 215, 168, 184),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.close, color: Colors.red, size: 32),
                onPressed: () =>
                    _confirmKickMahasiswa(widget.pekerjaanId, userId, nama),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Klik icon ‘X’ untuk mengeluarkan $nama dari pekerjaan ${widget.pekerjaanNama}',
                  style: GoogleFonts.poppins(color: Colors.black, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Text(
            '$title :',
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 12),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Text(
        "Belum ada Mahasiswa yang join pada Pekerjaan '${widget.pekerjaanNama}'",
        style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detail Pekerjaan: ${widget.pekerjaanNama}',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => PekerjaanDosenPage(),
              ),
            );
          },
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Positioned(
                  top: 120,
                  left: 0,
                  right: 0,
                  bottom: 20,
                  child: anggota.isEmpty
                      ? _buildEmptyState()
                      : SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: anggota.map((item) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: _buildDetailContainer(
                                  item.nama,
                                  item.nim,
                                  item.periode,
                                  item.email,
                                  item.noHp,
                                  item.userId, // Tambahkan userId
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                ),
                Positioned(
                  top: 16,
                  left: 0,
                  right: 0,
                  child: CustomKompetensiWidget(
                    pekerjaanNama: widget.pekerjaanNama,
                    AnggotaCount: anggota.length,
                  ),
                ),
              ],
            ),
    );
  }
}

class CustomKompetensiWidget extends StatelessWidget {
  final String pekerjaanNama;
  final int AnggotaCount;

  const CustomKompetensiWidget({
    required this.pekerjaanNama,
    required this.AnggotaCount,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final double boxWidth = MediaQuery.of(context).size.width * 0.85;

    return Center(
      child: Container(
        width: boxWidth,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blue.shade700,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            const Icon(Icons.leaderboard, color: Colors.white, size: 40),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pekerjaanNama,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(color: Colors.white),
                  Text(
                    'Jumlah Anggota: $AnggotaCount',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
