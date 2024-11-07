import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bottombar/bottombar.dart';
import 'profile.dart';
import 'pekerjaan.dart';
import '../mahasiswa.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CetakSuratPage extends StatefulWidget {
  const CetakSuratPage({super.key});

  @override
  _CetakSuratPageState createState() => _CetakSuratPageState();
}

class _CetakSuratPageState extends State<CetakSuratPage> {
  int _selectedIndex = 2;

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
                _buildDetailRow('Nama Mahasiswa', 'M. Isroqi Gelby Firmansyah'),
                _buildDetailRow('NIM', '2241760041'),
                _buildDetailRow('Tingkat / Kelas', '3 / C (SIB - 3C)'),
                _buildDetailRow(
                    'Program Studi', 'Diploma IV Sistem Informasi Bisnis'),
                _buildDetailRow('Semester', '5'),
                _buildDetailRow('Tugas Kompen', 'Pemrograman Web'),
                _buildDetailRow('Pemberi Tugas', 'Dr. Topek S.T., M.T'),
                _buildDetailRow('Jumlah Jam', '100 Jam'),
                _buildDetailRow('Status', 'Selesai'),
                const SizedBox(height: 30),
                Text(
                  'Deskripsi:',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Dengan ini, kami menyatakan bahwa mahasiswa atas nama M. Isroqi Gelby Firmansyah, '
                  'NIM 2241760041, telah menyelesaikan tugas kompensasi yang diberikan sebagai bagian dari kewajiban '
                  'akademis. Tugas kompen ini berupa Pemrograman Web dengan jumlah jam 100, dan telah dipenuhi dengan baik '
                  'sesuai dengan standar yang ditetapkan oleh Program Studi Diploma IV Sistem Informasi Bisnis.\n\n'
                  'Mahasiswa telah menunjukkan komitmen dan keterampilan yang memadai dalam menyelesaikan tugas tepat waktu. '
                  'Oleh karena itu, yang bersangkutan dinyatakan telah memenuhi kewajiban kompensasi dan tidak memiliki tanggungan '
                  'terkait tugas kompen di semester ini.\n\n'
                  'Kami berharap prestasi ini dapat memotivasi mahasiswa untuk lebih bersemangat dalam melaksanakan kegiatan '
                  'akademik di masa mendatang.',
                  style: GoogleFonts.poppins(fontSize: 12),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildQrSignature(
                      'Malang, 07 Juli 2024',
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
          QrImageView(
            data: 'QR Code for $name',
            version: QrVersions.auto,
            size: 80.0,
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
}
