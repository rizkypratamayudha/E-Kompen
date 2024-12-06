import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bottombar/bottombarDosen.dart';
import 'profile.dart';
import 'pekerjaan.dart';
import '../dosen.dart';
import 'lihat_kompetensi.dart';

class LihatDetailKompetensi extends StatefulWidget {
  final String nama;
  final String id;
  final String tugas;

  const LihatDetailKompetensi({
    Key? key,
    required this.nama,
    required this.id,
    required this.tugas,
  }) : super(key: key);

  @override
  _LihatDetailKompetensiState createState() => _LihatDetailKompetensiState();
}

class _LihatDetailKompetensiState extends State<LihatDetailKompetensi> {
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    setState(() {
      _selectedIndex = index;
    });

    if (index == 2)
      return;
    else if (index == 1) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => PekerjaanDosenPage()));
    } else if (index == 3) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => ProfilePage()));
    } else if (index == 0) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => DosenDashboard()));
    }
  }

  Widget buildBoxLihatDetailKompetensi(String title, String description) {
    return FractionallySizedBox(
      widthFactor: 0.9, // Lebar 90% dari layar
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Container (Lebih ramping)
          Container(
            width: double.infinity, // Lebar penuh
            height: 30, // Tinggi lebih kecil untuk judul
            decoration: const BoxDecoration(
              color: Color(0xFFF4D03F),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            alignment: Alignment.centerLeft, // Teks berada di tengah kiri
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
          // Description Container
          Container(
            width: double.infinity, // Lebar penuh
            constraints: const BoxConstraints(
              minHeight: 60, // Minimal tinggi kontainer deskripsi
            ),
            decoration: const BoxDecoration(
              color: Color(0xFF1A6FD3),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            alignment: Alignment.centerLeft, // Teks berada di tengah kiri
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            child: Text(
              description,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => LihatKompetensi(
                  nama: widget.nama, // Pass dynamic data
                  id: widget.id,
                  tugas: widget.tugas,
                  // kompetensiList: [],
                )));
          },
        ),
        title: Text(
          'Kompetensi 1',
          style: GoogleFonts.poppins(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Center(
        // Menempatkan konten di tengah layar
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Kolom berukuran minimum
              children: [
                buildBoxLihatDetailKompetensi(
                    "Nama", widget.nama),
                const SizedBox(height: 8),
                buildBoxLihatDetailKompetensi("NIM", widget.id),
                const SizedBox(height: 8),
                buildBoxLihatDetailKompetensi("Periode", "2024/2025 Genap"),
                const SizedBox(height: 8),
                const Divider(color: Colors.black, thickness: 3),
                const SizedBox(height: 8),
                buildBoxLihatDetailKompetensi(
                    "Kompetensi", "Menguasai Pembuatan Flowchart"),
                const SizedBox(height: 8),
                buildBoxLihatDetailKompetensi("Pengalaman",
                    "Pernah membuat use case dan activity diagram untuk mata kuliah APSO"),
                const SizedBox(height: 8),
                buildBoxLihatDetailKompetensi(
                    "Bukti", "Phttps://app.diagrams.net#G1N3t5Xuboff26bE-mCJ7BuNy5TTWj5Rd#%7B%22pageId%22%3A%22zflMTrrlGC0nfNbhAmkl%22%7D"),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBarDosen(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
