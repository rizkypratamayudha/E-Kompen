import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bottombar/bottombarDosen.dart'; 
import 'profile.dart';
import 'penerimaan_dosen1.dart';
import '../dosen.dart';
import 'editPekerjaan.dart'; 
import 'tambah_pekerjaan.dart'; 

class PekerjaanDosenPage extends StatefulWidget {
  const PekerjaanDosenPage({super.key});

  @override
  _PekerjaanDosenPageState createState() => _PekerjaanDosenPageState();
}

class _PekerjaanDosenPageState extends State<PekerjaanDosenPage> {
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
        MaterialPageRoute(builder: (context) => PenerimaanDosen1()),
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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 50.0, 20.0, 5.0),
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
          // Navigasi ke halaman TambahPekerjaanPage
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TambahPekerjaanPage()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white,),
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
            Icons.border_color,
            color: Colors.white,
          ),
          onPressed: () {
            // Navigasi ke halaman EditPekerjaanPage
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditPekerjaanPage(),
              ),
            );
          },
        ),
      ),
    );
  }
}
