import 'package:firstapp/Dosen/penerimaan_dosen1.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bottombar/bottombarDosen.dart';
import 'profile.dart';
import 'pekerjaan.dart';
import '../dosen.dart';
import 'lihat_detail_kompetensi.dart';

class LihatKompetensi extends StatefulWidget{
  const LihatKompetensi({super.key});

  @override
  _LihatKompetensiState createState() => _LihatKompetensiState();
}

class _LihatKompetensiState extends State<LihatKompetensi>{
  int _selectedIndex = 2;

  void _onItemTapped(int index){
    if (index == _selectedIndex){
      return;
    }

    setState(() {
      _selectedIndex = index;
    });

    if(index == 2){
      return;
    }
    else if (index == 1){
      Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => PekerjaanDosenPage())
      );
    }
    else if (index == 3){
      Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context)=> ProfilePage())
      );
    }
    else if (index == 0){
      Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context)=> DosenDashboard())
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
                MaterialPageRoute(builder: (context) => PenerimaanDosen1()));
          },
        ),
        title: Text(
          'Kompetensi',
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
            const CustomLihatKompetensiWidget(),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          buildKompetensiDosen(
                            'Kompetensi 1',
                            'Menguasai Bahasa Pemrograman',
                          ),
                          buildKompetensiDosen(
                            'Kompetensi 2',
                            'Menguasai Excel',
                          ),
                          buildKompetensiDosen(
                            'Kompetensi 3',
                            'Menguasai Word',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      
      bottomNavigationBar: BottomNavBarDosen(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget buildKompetensiDosen(String title, String description) {
    final double boxWidth = MediaQuery.of(context).size.width * 0.80;

    return Center(
      child: Container(
        width: boxWidth,
        margin: const EdgeInsets.only(bottom: 10),
        child: InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => LihatDetailKompetensi()));
          },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 17,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade700,
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints: const BoxConstraints(
                  minHeight: 90, // Ukuran minimal untuk 3 baris
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.military_tech,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            description,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
          ],
        ),
      ),
      ),
    );
  }

}

class CustomLihatKompetensiWidget extends StatelessWidget {
  const CustomLihatKompetensiWidget({super.key});

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
            Icon(
              Icons.leaderboard,
              color: Colors.white,
              size: 40,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'M. Isroqi Gelby Firmansyah',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  Divider(color: Colors.white),
                  Text(
                    'Kompetensi 3',
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