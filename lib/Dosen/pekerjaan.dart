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
              _buildPekerjaan('Pembuatan Web','2/5'),
              const SizedBox(height: 5),
              _buildPekerjaan('Memasukkan Nilai','0/2'),
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

  Widget _buildPekerjaan(String title, String anggota) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: Card(
          color: Colors.blue,
          child: ListTile(
            title: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                Text(
                  anggota,
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
      Container(
        decoration: BoxDecoration(
          color: Colors.blue, 
          shape: BoxShape.rectangle, 
          borderRadius: BorderRadius.circular(10)
        ),
        padding: EdgeInsets.all(4), // Padding agar ikon tidak terlalu kecil
        child: IconButton(
          onPressed: () {
            Navigator.push(
              context, MaterialPageRoute(builder: (context)=>EditPekerjaanPage())
            );
          },
          icon: Icon(
            Icons.menu,
            color: Colors.white, // Warna ikon
          ),
        ),
      )
    ],
  );
}

}
