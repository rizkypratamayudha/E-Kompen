import 'package:firstapp/dosen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bottombar/bottombarDosen.dart'; // Import BottomNavBar
import 'profile.dart';
import 'riwayat.dart';
import '../dosen.dart';

class PekerjaanPage extends StatefulWidget {
  const PekerjaanPage({super.key});

  @override
  _PekerjaanPageState createState() => _PekerjaanPageState();
}

class _PekerjaanPageState extends State<PekerjaanPage> {
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
        MaterialPageRoute(builder: (context) => const DosenDashboard()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pekerjaan',
          style: GoogleFonts.poppins(fontSize: 18),
        ),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 50.0, 10.0, 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pekerjaan',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 20),
              _buildPekerjaan('Pembuatan Web'),
              const SizedBox(height: 10),
              _buildPekerjaan('Memasukkan Nilai'),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Fungsi untuk menambah pekerjaan baru
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
      bottomNavigationBar: BottomNavBarDosen(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildPekerjaan(String title) {
    return Card(
      color: Colors.blue,
      child: ListTile(
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.white,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(
            Icons.menu_book,
            color: Colors.white,
          ),
          onPressed: () {
            // Navigasi ke halaman detail pekerjaan
          },
        ),
      ),
    );
  }
}


