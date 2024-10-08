import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bottombar/bottombar.dart'; // Import BottomNavBar
import 'profile.dart';
import 'pekerjaan.dart';
import '../dosen.dart';
import 'pengumpulan_bukti.dart'; // Import PengumpulanBuktiPage

class ProgressDosenPage extends StatefulWidget {
  @override
  _ProgressDosenPageState createState() => _ProgressDosenPageState();
}

class _ProgressDosenPageState extends State<ProgressDosenPage> {
  int _selectedIndex = 2; // Sesuaikan dengan tab yang sedang aktif

  void _onItemTapped(int index) {
    if (index == _selectedIndex) {
      return;
    }

    setState(() {
      _selectedIndex = index;
    });

    if (index == 2) {
      return;
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PekerjaanDosenPage()),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()),
      );
    } else if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DosenDashboard()),
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
            // Add your back button functionality here
          },
        ),
        title: Text(
          'Solikhin',
          style: GoogleFonts.poppins(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded( // Tambahkan Expanded di sini agar scroll bekerja
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(16), // Padding inside the border
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildInfoRow('Jenis Tugas:', 'Teknis'),
                      buildInfoRow('Tugas:', 'Pembuatan Mobile'),
                      buildInfoRow('Tugas Progress:', 'Pembuatan dashboard dan fitur riwayat Mahasiswa'),
                      buildInfoRow('Jumlah Jam:', '20 jam'),
                      buildInfoRow('Batas Pengerjaan:', '2024-10-30'),
                      const SizedBox(height: 16),
                      // Foto Bukti
                      Text(
                        'Foto bukti :',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[200],
                        ),
                        child: Icon(
                          Icons.image,
                          size: 50,
                          color: Colors.grey[400],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Tombol Tambah/Edit
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50), // Button size
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.blue,
                        ),
                        onPressed: () {
                          // Handle button press
                        },
                        child: Text(
                          '+ Tambah / Edit',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      backgroundColor: Colors.white,
    );
  }

  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
            ),
          ),
          const Divider(
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}
