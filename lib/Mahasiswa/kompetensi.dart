import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bottombar/bottombar.dart';
import 'riwayat.dart';
import 'pekerjaan.dart';
import '../mahasiswa.dart';
import 'upload_kompetensi.dart';
import 'edit_kompetensi.dart';

class KompetensiMahasiswaPage extends StatefulWidget {
  const KompetensiMahasiswaPage({super.key});

  @override
  _KompetensiMahasiswaPageState createState() =>
      _KompetensiMahasiswaPageState();
}

class _KompetensiMahasiswaPageState extends State<KompetensiMahasiswaPage> {
  int _selectedIndex = 3;

  void _onItemTapped(int index) {
    if (index == _selectedIndex) {
      return;
    }

    setState(() {
      _selectedIndex = index;
    });

    if (index == 3) {
      return;
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PekerjaanPage()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => RiwayatPage()),
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => RiwayatPage()));
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
            const CustomKompetensiWidget(),
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
                          buildKompetensiWithEditDelete(
                            'Kompetensi 1',
                            'Menguasai Bahasa Pemrograman',
                          ),
                          buildKompetensiWithEditDelete(
                            'Kompetensi 2',
                            'Menguasai Excel',
                          ),
                          buildKompetensiWithEditDelete(
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UploadKompetensi()),
          );
        },
        backgroundColor: Colors.green,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget buildKompetensiWithEditDelete(String title, String description) {
    final double boxWidth = MediaQuery.of(context).size.width * 0.80;

    return Center(
      child: Container(
        width: boxWidth,
        margin: const EdgeInsets.only(bottom: 10),
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
            const SizedBox(width: 10),
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditKompetensi(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 221, 204, 56),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.menu,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  InkWell(
                    onTap: () {
                      showDeleteConfirmationDialog(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
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

  void showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Apakah Anda ingin menghapus kompetensi",
            style: GoogleFonts.poppins(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Tidak',
                style: GoogleFonts.poppins(
                  color: Colors.blue,
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue.shade100,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Add logic to delete the competency
              },
              child: Text(
                'Ya',
                style: GoogleFonts.poppins(
                  color: Colors.blue,
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue.shade100,
              ),
            ),
          ],
        );
      },
    );
  }
}

class CustomKompetensiWidget extends StatelessWidget {
  const CustomKompetensiWidget({super.key});

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
