import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bottombar/bottombarDosen.dart'; // Pastikan di-import
import 'profile.dart';
import 'pekerjaan.dart';
import '../dosen.dart';

class PenerimaanDosenPage extends StatefulWidget {
  @override
  _PenerimaanDosenPageState createState() => _PenerimaanDosenPageState();
}

class _PenerimaanDosenPageState extends State<PenerimaanDosenPage> {
  PageController _pageController = PageController(initialPage: 0);
  int _selectedIndex = 2; // Index awal disesuaikan dengan tab yang aktif

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
        backgroundColor: Colors.white,
        title: Text(
          'Penerimaan',
          style: GoogleFonts.poppins(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TabButton(
                  icon: Icons.assignment, // Ikon untuk "Penerimaan Tugas"
                  text: "Penerimaan Tugas",
                  isSelected: _selectedIndex == 0,
                  onTap: () {
                    setState(() {
                      _selectedIndex = 0;
                    });
                    _pageController.animateToPage(
                      0,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
              ),
              Expanded(
                child: TabButton(
                  icon: Icons.work, // Ikon untuk "Proses Pengerjaan"
                  text: "Proses Pengerjaan",
                  isSelected: _selectedIndex == 1,
                  onTap: () {
                    setState(() {
                      _selectedIndex = 1;
                    });
                    _pageController.animateToPage(
                      1,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
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
                _buildPenerimaanList(context), // Menampilkan penerimaan tugas
                _buildProsesList(context),     // Menampilkan proses pengerjaan
              ],
            ),
          ),
        ],
      ),
      // Tambahkan BottomNavBar di sini
      bottomNavigationBar: BottomNavBarDosen(
        selectedIndex: _selectedIndex, // Set index yang dipilih
        onItemTapped: _onItemTapped, // Fungsi saat item diklik
      ),
    );
  }

  // Fungsi untuk membuat daftar penerimaan tugas
  Widget _buildPenerimaanList(BuildContext context) {
    return ListView(
      children: [
        _buildCard(
          context,
          'Solikhin',
          '2241760020',
          'Memasukkan Nilai',
        ),
        _buildCard(
          context,
          'M Rizky Yudha',
          '2241760020',
          'Membuat Web',
        ),
      ],
    );
  }

  // Fungsi untuk membuat daftar proses pengerjaan (Anda bisa mengubahnya dengan data yang sesuai)
  Widget _buildProsesList(BuildContext context) {
    return ListView(
      children: [
        _buildCard(
          context,
          'Task Example 1',
          '000000001',
          'Proses Pengerjaan',
        ),
        _buildCard(
          context,
          'Task Example 2',
          '000000002',
          'Proses Pengerjaan Lain',
        ),
      ],
    );
  }

  // Fungsi untuk membuat tampilan Card pada tiap item
  Widget _buildCard(BuildContext context, String name, String id, String task) {
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  id,
                  style: GoogleFonts.poppins(fontSize: 14),
                ),
                SizedBox(height: 10),
                Text(
                  task,
                  style: GoogleFonts.poppins(fontSize: 14),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(Icons.check_circle, color: Colors.green),
                      onPressed: () {
                        // Handle action for accepting the task
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.cancel, color: Colors.red),
                      onPressed: () {
                        // Handle action for rejecting the task
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TabButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const TabButton({
    required this.icon,
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
          color: isSelected ? Colors.blue : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.black,
            ),
            SizedBox(width: 6),
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
