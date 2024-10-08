import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bottombar/bottombar.dart'; // Import BottomNavBar
import 'profile.dart';
import 'pekerjaan.dart';
import '../mahasiswa.dart';
import 'pengumpulan_bukti.dart'; // Import PengumpulanBuktiPage

class ProgressMahasiswaPage extends StatefulWidget {
  @override
  _ProgressMahasiswaPageState createState() => _ProgressMahasiswaPageState();
}

class _ProgressMahasiswaPageState extends State<ProgressMahasiswaPage> {
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
        MaterialPageRoute(builder: (context) => PekerjaanPage()),
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Add your back button functionality here
          },
        ),
        title: Text(
          'Proses Pengerjaan',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
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
            CustomProgressWidget(),
            const SizedBox(height: 16),
            // Black border wrapping all progress cards with scrolling
            Expanded( // Tambahkan Expanded di sini agar scroll bekerja
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2), // Black border around all boxes
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(8), // Padding inside the border
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      // Wrap Progress 1 with GestureDetector to navigate
                      GestureDetector(
                        onTap: () {
                          // Navigate to PengumpulanBuktiPage when Progress 1 is clicked
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PengumpulanBuktiPage()),
                          );
                        },
                        child: buildCombinedProgressCard(
                          'Progress 1',
                          'Pembuatan Dashboard dan Fitur Riwayat Mahasiswa',
                          '20',
                          Colors.green,
                        ),
                      ),
                      buildCombinedProgressCard(
                        'Progress 2',
                        'Pembuatan Pekerjaan dan Profil Mahasiswa',
                        '20',
                        Colors.lightBlue.shade400,
                      ),
                      buildCombinedProgressCard(
                        'Progress 3',
                        'Pembuatan Dashboard Pemberian Pekerjaan Dosen',
                        '20',
                        Colors.lightBlue.shade400,
                      ),
                      buildCombinedProgressCard(
                        'Progress 4',
                        'Pembuatan profil dan penerimaan pekerjaan dan upload TTD',
                        '40',
                        Colors.lightBlue.shade400,
                      ),
                      // Tambahkan card-card lainnya di sini
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget buildCombinedProgressCard(String title, String description, String hours, Color rightBoxColor) {
    final double boxWidth = MediaQuery.of(context).size.width * 0.80; // 90% width of screen

    return Center(
      child: Container(
        width: boxWidth,
        margin: const EdgeInsets.only(bottom: 10),
        child: IntrinsicHeight( // Gunakan IntrinsicHeight agar kedua container menyesuaikan tingginya
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch, // Memastikan kedua container sama tinggi
            children: [
              // Left box (80% width)
              Expanded( // Membungkus container kiri dengan Expanded
                flex: 4, // Flex untuk mengatur proporsi
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade700,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.download, // Change this to the desired icon
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded( // Gunakan Expanded di sekitar kolom teks
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1, // Membatasi judul hanya 1 baris
                              overflow: TextOverflow.ellipsis, // Tambahkan overflow ellipsis
                            ),
                            const SizedBox(height: 8),
                            Text(
                              description,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                              maxLines: 5, // Membatasi deskripsi maksimal 5 baris
                              overflow: TextOverflow.ellipsis, // Tambahkan overflow ellipsis
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Right box (20% width)
              Expanded( // Menggunakan Expanded di container kanan juga
                flex: 1, // Flex untuk mengatur proporsi
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  decoration: BoxDecoration(
                    color: rightBoxColor,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '$hours Jam',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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

// Your custom progress widget
class CustomProgressWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double boxWidth = MediaQuery.of(context).size.width * 0.85;

    return Center(
      child: Container(
        width: boxWidth, // Set the container width to 75%
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blue.shade700,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(
              Icons.hourglass_empty, // Simple built-in icon
              color: Colors.white,
              size: 40,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Jumlah Progress: 4',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  Divider(color: Colors.white), // The separator line
                  Text(
                    'Pekerjaan: Pembuatan Mobile',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
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
