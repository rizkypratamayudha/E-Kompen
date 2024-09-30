import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bottombar/bottombar.dart'; // Import BottomNavBar
import 'profile.dart';
import 'riwayat.dart';
import '../mahasiswa.dart';

class PekerjaanKosongPage extends StatefulWidget {
  const PekerjaanKosongPage({super.key});

  @override
  _PekerjaanKosongPageState createState() => _PekerjaanKosongPageState();
}

class _PekerjaanKosongPageState extends State<PekerjaanKosongPage> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    if (index == _selectedIndex) {
      return;
    }

    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      return;
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => RiwayatPage()),
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
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 50.0, 20.0, 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,  // Aligns "Pekerjaan" to the left
            children: [
              Text(
                'Pekerjaan',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(height: 50),
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/img/no_taks.png', // Ensure the correct path to the image
                      height: 150,
                      width: 150,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Tidak ada tugas yang dikerjakan',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center, // Aligns the text to the center
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      backgroundColor: Colors.white,
    );
  }
}
