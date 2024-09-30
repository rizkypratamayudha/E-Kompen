import 'dart:async';

import 'package:firstapp/Mahasiswa/riwayat.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bottombar/bottombarDosen.dart';
import 'profile.dart';
import 'pekerjaan.dart';
import '../dosen.dart';

class PenerimaanDosen1 extends StatefulWidget{
  @override
  _PenerimaanDosen1State createState() => _PenerimaanDosen1State();
}

class _PenerimaanDosen1State extends State<PenerimaanDosen1>{
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
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        )
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Padding(
            padding: EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 40.0),
            child: Text('Penerimaan',
            style: GoogleFonts.poppins(fontSize: 22)),
          ),
        ),
        backgroundColor: Colors.white,
        body: PenerimaanScreen(),
        bottomNavigationBar: BottomNavBarDosen(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
      ),
    );
  }
}

class PenerimaanScreen extends StatefulWidget{
  @override
  _PenerimaanScreenState createState() => _PenerimaanScreenState();
}

class _PenerimaanScreenState extends State<PenerimaanScreen>{
  PageController _pageController = PageController(initialPage: 0);
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context){
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TabButton(
                icon: Icons.assignment,
                text: 'Penerimaan Tugas',
                isSelected: _selectedIndex == 0,
                onTap: (){
                  setState(() {
                    _selectedIndex = 0;
                  });
                  _pageController.animateToPage(
                    0,duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut
                  );
                },
              ),
            ),
            Expanded(
              child: TabButton(
                icon: Icons.work,
                text: 'Proses Pengerjaan',
                isSelected: _selectedIndex == 1,
                onTap: (){
                  setState(() {
                    _selectedIndex = 0;
                  });
                  _pageController.animateToPage(
                    1,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut
                    );
                },
              ),
            )
          ],
        ),
        const SizedBox(height: 20),
        Expanded(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index){
              setState(() {
                _selectedIndex = index;
              });
            },
            children: [
              _buildPenerimaanList(context),
              _buildProsesList(context),
            ],
          ),
        )
      ],
    );
  }
  Widget _buildCard(BuildContext context, String nama, String id, String tugas) {
  return Align(
    alignment: Alignment.topCenter,
    child: FractionallySizedBox(
      widthFactor: 0.9,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center, // Vertically center the content
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nama,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      id,
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                    SizedBox(height: 10),
                    Text(
                      tugas,
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 40,
                    ),
                    onPressed: () {
                      
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.cancel,
                      color: Colors.red,
                      size: 40,
                    ),
                    onPressed: () {
                      
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget _buildCardProses(BuildContext context, String nama, String id, String tanggal, String tugas) {
  return Align(
    alignment: Alignment.topCenter,
    child: FractionallySizedBox(
      widthFactor: 0.9,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center, // Vertically center the content
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nama,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      id,
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                    Text(
                      tanggal,
                      style: GoogleFonts.poppins(fontSize: 14,fontWeight: FontWeight.w300),
                    ),
                    SizedBox(height: 10),
                    Text(
                      tugas,
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 40,
                    ),
                    onPressed: () {
                      
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.cancel,
                      color: Colors.red,
                      size: 40,
                    ),
                    onPressed: () {
                      
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
  Widget _buildPenerimaanList(BuildContext context){
    return ListView(
      children: [
        _buildCard(context,
        'Solikhin',
        '2241760020',
        'Memasukkan Nilai'
        ),
        _buildCard(context, 
        'M Rizky Yudha',
        '2241760020',
        'Membuat Web'
        )
      ],
    );
  }

  Widget _buildProsesList(BuildContext context){
    return ListView(
      children: [
        _buildCardProses(context,
        'Contoh Nama','Contoh nim','2024-12-12','Contoh Tugas'),
        _buildCardProses(context,
        'Contoh nama2','Contoh nim2','2021-19-10','Contoh tugas2'),
      ],
    );
  }
}