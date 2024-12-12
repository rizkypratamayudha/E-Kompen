import 'package:firstapp/config/config.dart';
import 'package:firstapp/controller/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bottombar/bottombar.dart';
import 'profile.dart';
import 'pekerjaan.dart';
import '../mahasiswa.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CetakSuratPage extends StatefulWidget {
  final String nama;
  final String id;
  final String formattanggal;
  final String tugas;
  final String namauser;
  final String prodi;
  final String periode;
  final String namadosen;
  final String jamkompen;
  final String angkatan;
  final String iddosen;
  final String idkap;
  final int id_cetak;

  const CetakSuratPage({
    super.key,
    required this.nama,
    required this.id,
    required this.formattanggal,
    required this.tugas,
    required this.namauser,
    required this.prodi,
    required this.periode,
    required this.namadosen,
    required this.jamkompen,
    required this.angkatan,
    required this.iddosen,
    required this.idkap,
    required this.id_cetak,
  });

  @override
  _CetakSuratPageState createState() => _CetakSuratPageState();
}

class _CetakSuratPageState extends State<CetakSuratPage> {
  int _selectedIndex = 2;
  String? qrUrl;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadQrUrl();
  }

  Future<void> _loadQrUrl() async {
    String? fetchedQrUrl = await fetchQrUrl(widget.id_cetak.toString());
    print('Fetched QR URL: $fetchedQrUrl'); // Debug log
    print('ID CETAK :: ${widget.id_cetak}');
    setState(() {
      qrUrl = fetchedQrUrl;
      isLoading = false;
    });
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PekerjaanPage()),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()),
      );
    } else if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MahasiswaDashboard()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
      ),
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); // Kembali ke halaman sebelumnya
            },
          ),
          title: Text(
            'Cetak Surat',
            style: GoogleFonts.poppins(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Colors.black,
        ),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/img/polinema.png', // Ganti dengan path gambar kamu
                      width: 60,
                      height: 60,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Center(
                        child: Text(
                          'KEMENTERIAN PENDIDIKAN, KEBUDAYAAN, RISET, DAN TEKNOLOGI\n'
                          'POLITEKNIK NEGERI MALANG\n'
                          'JURUSAN TEKNOLOGI INFORMASI\n'
                          'Jalan Soekarno-Hatta No.9 Jatimulyo, Lowokwaru, Malang, 65141\n'
                          'Telepon (0341) 404424 - 404425, Fax (0341) 404420,\n'
                          'https://www.polinema.ac.id',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(fontSize: 8),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(thickness: 2, color: Colors.black),
                const SizedBox(height: 10),
                _buildDetailRow('Nama Mahasiswa', widget.namauser),
                _buildDetailRow('NIM', widget.id),
                _buildDetailRow('Program Studi', widget.prodi),
                _buildDetailRow('Angkatan', widget.angkatan),
                _buildDetailRow('Periode', widget.periode),
                _buildDetailRow('Tugas Kompen', widget.tugas),
                _buildDetailRow('Pemberi Tugas', widget.namadosen),
                _buildDetailRow('Jumlah Jam', '${widget.jamkompen} jam'),
                const SizedBox(height: 30),
                Text(
                  'QR Code Surat:',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildQrSignature(
                      'Malang, ${widget.formattanggal}',
                      'Dr. Salam, S.T., M.T',
                      'NIP: 111',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Table(
        columnWidths: const {
          0: FixedColumnWidth(150),
          1: IntrinsicColumnWidth(),
        },
        children: [
          TableRow(
            children: [
              Text(
                '$title :',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
              Text(
                value,
                style: GoogleFonts.poppins(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // QR Signature di kanan tengah dengan ketua program studi
  Widget _buildQrSignature(String date, String name, String nip) {
    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            date,
            style: GoogleFonts.poppins(fontSize: 12),
          ),
          const SizedBox(height: 5),
          Text(
            'Ketua Program Studi',
            style: GoogleFonts.poppins(fontSize: 12),
          ),
          const SizedBox(height: 10),
          isLoading
                    ? Center(child: CircularProgressIndicator())
                    : qrUrl != null
                        ? QrImageView(
                            data: qrUrl!, // Data QR berupa URL
                            version: QrVersions.auto,
                            size: 200.0,
                          )
                        : Text(
                            'Gagal memuat QR Code',
                            style: GoogleFonts.poppins(color: Colors.red),
                          ),
          const SizedBox(height: 10),
          Text(
            name,
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          Text(
            nip,
            style: GoogleFonts.poppins(),
          ),
        ],
      ),
    );
  }

  Future<String?> fetchQrUrl(String id) async {
  try {
    final token = await AuthService().getToken();
    print('Token: $token'); // Debug log
    final response = await http.get(
      Uri.parse('${config.baseUrl}/geturl/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('Response data: $data'); // Debug log
      if (data['qrCodeUrl'] != null) {
        return data['qrCodeUrl'];  // Mengambil qrCodeUrl
      } else {
        print('QR URL is null');
        return null;  // URL QR tidak ada
      }
    } else {
      print('Error response: ${response.body}');
      return null;
    }
  } catch (e) {
    print('Error fetching QR URL: $e');
    return null;
  }
}


}
