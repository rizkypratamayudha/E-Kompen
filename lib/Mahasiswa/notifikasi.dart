import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bottombar/bottombar.dart';
import 'riwayat.dart';
import 'profile.dart';
import 'pekerjaan.dart';
import '../mahasiswa.dart';

class NotifikasiMahasiswaPage extends StatefulWidget {
  const NotifikasiMahasiswaPage({super.key});

  @override
  _NotifikasiMahasiswaPageState createState() =>
      _NotifikasiMahasiswaPageState();
}

class _NotifikasiMahasiswaPageState extends State<NotifikasiMahasiswaPage> {
  int _selectedIndex = 3;

  void _onItemTapped(int index) {
    if (index == _selectedIndex) {
      return;
    }
    setState(() {
      _selectedIndex = index;
    });
    if (index == 3) {
      return;
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PekerjaanPage()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => RiwayatPage()),
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProfilePage()));
          },
        ),
        title: Text(
          'Notifikasi',
          style: GoogleFonts.poppins(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildNotificationCard(
            color: Colors.blue,
            icon: Icons.announcement,
            description: 'Anda mengajukan tugas memasukkan nilai ke Dosen Topek',
            time: '5 Hari yang lalu',
          ),
          const SizedBox(height: 8),
          _buildNotificationCard(
            color: Colors.blue,
            icon: Icons.announcement,
            description: 'Tugas Anda Sedang dalam review Dosen Topek',
            time: '5 Hari yang lalu',
          ),
          const SizedBox(height: 8),
          _buildNotificationCard(
            color: Colors.red,
            icon: Icons.announcement,
            description: 'Tugas anda telah ditolak oleh Dosen Topek',
            time: '4 Hari yang lalu',
          ),
          const SizedBox(height: 8),
          _buildNotificationCard(
            color: Colors.blue,
            icon: Icons.announcement,
            description: 'Anda mengajukan tugas Pemrograman Web ke Dosen Topek',
            time: '3 Hari yang lalu',
          ),
          const SizedBox(height: 8),
          _buildNotificationCard(
            color: Colors.blue,
            icon: Icons.announcement,
            description: 'Tugas Anda Sedang dalam review Dosen Topek',
            time: '3 Hari yang lalu',
          ),
          const SizedBox(height: 8),
          _buildNotificationCard(
            color: Colors.green,
            icon: Icons.announcement,
            description: 'Tugas anda telah diterima oleh Dosen Topek',
            time: '2 Hari yang lalu',
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildNotificationCard({
    required Color color,
    required IconData icon,
    required String description,
    required String time,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 32,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  time,
                  style: GoogleFonts.poppins(
                    color: const Color.fromARGB(255, 255, 249, 202),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
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
