import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bottombar/bottombar.dart'; // Import BottomNavBar
import 'profile.dart';
import 'pekerjaan.dart';
import '../mahasiswa.dart';

class PenerimaanDosenPage extends StatefulWidget {
  @override
  _PenerimaanDosenPageState createState() => _PenerimaanDosenPageState();
}

class _PenerimaanDosenPageState extends State<PenerimaanDosenPage> {
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
        MaterialPageRoute(builder: (context) => const MahasiswaDashboard()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Menyembunyikan banner "Debug"
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text('Riwayat'),
          ),
        ),
        body: RiwayatScreen(),
        bottomNavigationBar: BottomNavBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
      ),
    );
  }
}

class RiwayatScreen extends StatefulWidget {
  @override
  _RiwayatScreenState createState() => _RiwayatScreenState();
}

class _RiwayatScreenState extends State<RiwayatScreen> {
  PageController _pageController = PageController(initialPage: 0);
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TabButton(
                icon: Icons.access_time, // Ikon jam untuk 'Proses'
                text: "Proses",
                isSelected: _selectedIndex == 0,
                onTap: () {
                  setState(() {
                    _selectedIndex = 0;
                  });
                  _pageController.animateToPage(0,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut);
                },
              ),
            ),
            Expanded(
              child: TabButton(
                icon: Icons.check_circle_outline, // Ikon ceklis untuk 'Telah Selesai'
                text: "Telah Selesai",
                isSelected: _selectedIndex == 1,
                onTap: () {
                  setState(() {
                    _selectedIndex = 1;
                  });
                  _pageController.animateToPage(1,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut);
                },
              ),
            ),
            Expanded(
              child: TabButton(
                icon: Icons.edit, // Ikon tanda tangan untuk 'TTD Kaprodi'
                text: "TTD Kaprodi",
                isSelected: _selectedIndex == 2,
                onTap: () {
                  setState(() {
                    _selectedIndex = 2;
                  });
                  _pageController.animateToPage(2,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Expanded(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            children: [
              _buildRiwayat(context, 'Memasukkan Nilai'),
              _buildRiwayat(context, 'Pembuatan Nilai'),
              Center(
                child: Text('Halaman TTD Kaprodi'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class TabButton extends StatelessWidget {
  final IconData icon; // Tambahkan parameter ikon
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const TabButton({
    required this.icon, // Parameter ikon harus disertakan
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.white,
          border: Border.all(color: Colors.white),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.black, // Ubah warna ikon sesuai kondisi isSelected
            ),
            SizedBox(width: 6), // Jarak antara ikon dan teks
            Text(
              text,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildRiwayat(BuildContext context, String title) {
  return Align(
    alignment: Alignment.topCenter,
    child: FractionallySizedBox(
      widthFactor: 0.9,
      child: Card(
        color: Colors.blue,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: ListTile(
            title: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
            onTap: () {
              if (title == 'Memasukkan Nilai') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PengumpulanBuktiPage()),
                );
              }
            },
          ),
        ),
      ),
    ),
  );
}



class PengumpulanBuktiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pengumpulan Bukti Pekerjaan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tugas : Memasukkan Nilai',
              style: GoogleFonts.poppins(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Batas pengerjaan : 2024-10-30',
              style: GoogleFonts.poppins(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Jumlah jam : 100 jam',
              style: GoogleFonts.poppins(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Foto bukti :',
              style: GoogleFonts.poppins(fontSize: 16),
            ),
            SizedBox(height: 10),
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: Center(
                child: Icon(Icons.image, size: 50, color: Colors.grey),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Tambahkan logika untuk mengunggah bukti atau mengambil foto
              },
              child: Text('+ Tambah / buat'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                textStyle: GoogleFonts.poppins(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

