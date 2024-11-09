import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Mahasiswa/pekerjaan.dart';
import 'Mahasiswa/profile.dart';
import 'Mahasiswa/riwayat.dart';
import 'bottombar/bottombar.dart';

class MahasiswaDashboard extends StatefulWidget {
  const MahasiswaDashboard({super.key});

  @override
  _MahasiswaDashboardState createState() => _MahasiswaDashboardState();
}

class _MahasiswaDashboardState extends State<MahasiswaDashboard> {
  int _selectedIndex = 0;
  String _nama = '';

  @override
  void initState() {
    super.initState();
    _loadNama();
  }

  // Fungsi untuk mengambil nama pengguna dari SharedPreferences
  Future<void> _loadNama() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nama = prefs.getString('nama') ?? 'User';
    });
  }

  // Fungsi untuk menangani navigasi berdasarkan index dari BottomNavigationBar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PekerjaanPage()),
      );
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 50.0, 10.0, 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, size: 40),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Halo',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _nama,
                      style: GoogleFonts.poppins(),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 0, 20.0),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Jam kompen: 192 jam',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 5, bottom: 5),
                    child: Divider(
                      color: Colors.white,
                      thickness: 2,
                      endIndent: 20,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Status: tidak dalam proses Kompen',
                    style:
                        GoogleFonts.poppins(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(right: 20),
                    child: DropdownButtonFormField<String>(
                      value: 'Semester 1',
                      items: [
                        'Semester 1',
                        'Semester 2',
                        'Semester 3',
                        'Semester 4',
                        'Semester 5'
                      ]
                          .map((semester) => DropdownMenuItem(
                                value: semester,
                                child: Text(
                                  semester,
                                  style: GoogleFonts.poppins(),
                                ),
                              ))
                          .toList(),
                      onChanged: (value) {
                        // Handle perubahan pilihan semester
                      },
                      decoration: const InputDecoration(
                        labelText: 'Pilih Semester',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      backgroundColor: Colors.blue,
                      iconColor: Colors.white,
                      fixedSize: const Size(76, 44)),
                  child: const Icon(Icons.search),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildKompenCard('Praktikum Basis Data', '8 Jam'),
                  _buildKompenCard('Praktikum Daspro', '4 Jam'),
                  _buildKompenCard('Total Alpha', '12 Jam'),
                  _buildSummaryCard('Semester Mahasiswa Saat Ini: 5'),
                  _buildSummaryCard(
                      'Total Akumulasi Alpha sampai semester 5 (x2 setiap semester)\n12 * 2^4 = 192 Jam'),
                  _buildKompenCard('Akumulasi Alpha', '192 Jam'),
                ],
              ),
            ),
          ],
        ),
      ),
      // Menggunakan BottomNavBar yang sudah dipisahkan
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      backgroundColor: Colors.white,
    );
  }

  Widget _buildKompenCard(String title, String hours) {
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
        trailing: Text(
          hours,
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String summary) {
    return Card(
      color: Colors.grey[400],
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          summary,
          style: GoogleFonts.poppins(fontSize: 14),
        ),
      ),
    );
  }
}
