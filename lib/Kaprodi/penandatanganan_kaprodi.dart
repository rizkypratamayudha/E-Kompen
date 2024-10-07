import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bottombar/bottombarKaprodi.dart';
import '../kaprodi.dart';
import 'profile.dart';

class PenandatangananKaprodi extends StatefulWidget {
  @override
  _PenandatangananKaprodiState createState() => _PenandatangananKaprodiState();
}

class _PenandatangananKaprodiState extends State<PenandatangananKaprodi> {
  int _selectedIndex = 1;

 void _onItemTapped(int index) {
  setState(() {
    _selectedIndex = index;
  });

  if (index == 1) {
    return; // Tetap di halaman Penandatanganan
  } else if (index == 0) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => KaprodiDashboard()),
    );
  } else if (index == 2) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ProfilePage()),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(
        Theme.of(context).textTheme,
      )),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Padding(
            padding: EdgeInsets.fromLTRB(20.0, 60.0, 20.0, 40.0),
            child: Text('Penerimaan', style: GoogleFonts.poppins(fontSize: 22)),
          ),
        ),
        backgroundColor: Colors.white,
        body: PenerimaanScreen(),
        bottomNavigationBar: BottomNavBarKaprodi(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
      ),
    );
  }
}

class PenerimaanScreen extends StatefulWidget {
  @override
  _PenerimaanScreenState createState() => _PenerimaanScreenState();
}

class _PenerimaanScreenState extends State<PenerimaanScreen> {
  PageController _pageController = PageController(initialPage: 0);
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTab = 0;
                    });
                    _pageController.jumpToPage(0);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _selectedTab == 0 ? Colors.blue : Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'Tanda Tangan',
                      style: TextStyle(
                        fontSize: 16,
                        color: _selectedTab == 0 ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTab = 1;
                    });
                    _pageController.jumpToPage(1);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _selectedTab == 1 ? Colors.blue : Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'Selesai',
                      style: TextStyle(
                        fontSize: 16,
                        color: _selectedTab == 1 ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _selectedTab = index;
              });
            },
            children: [
              _buildTandaTanganList(context),
              _buildSelesaiList(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTandaTanganList(BuildContext context) {
    return ListView(
      children: [
        _buildCardWithCheck(
            context, 'Solikhin', '2241760020', 'Memasukkan Nilai'),
      ],
    );
  }

  Widget _buildSelesaiList(BuildContext context) {
    return ListView(
      children: [
        _buildCardWithoutCheck(
          context,
          'Solikhin',
          '2241760020',
          '2024-10-06',
          'Membuat Web',
        ),
      ],
    );
  }

  Widget _buildCardWithCheck(
      BuildContext context, String nama, String id, String tugas) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.all(16),
          title: Text(
            nama,
            style:
                GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          subtitle: Text(tugas),
          trailing: Icon(Icons.check_circle, color: Colors.green, size: 32),
        ),
      ),
    );
  }

  Widget _buildCardWithoutCheck(BuildContext context, String nama, String id,
      String tanggal, String tugas) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.all(16),
          title: Text(
            nama,
            style:
                GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(tanggal),
              SizedBox(height: 8),
              Text(tugas),
            ],
          ),
        ),
      ),
    );
  }
}
