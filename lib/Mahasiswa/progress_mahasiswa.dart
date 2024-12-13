import 'package:firstapp/Mahasiswa/riwayat.dart';
import 'package:firstapp/controller/pengerjaan.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bottombar/bottombar.dart';
import 'profile.dart';
import 'pekerjaan.dart';
import '../mahasiswa.dart';
import 'pengumpulan_bukti.dart';

class ProgressMahasiswaPage extends StatefulWidget {
  final Pekerjaan pekerjaan; 

  const ProgressMahasiswaPage({
    super.key,
    required this.pekerjaan, 
  });

  @override
  _ProgressMahasiswaPageState createState() => _ProgressMahasiswaPageState();
}

class _ProgressMahasiswaPageState extends State<ProgressMahasiswaPage> {
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RiwayatPage()),
            );
          },
        ),
        title: Text(
          'Proses Pengerjaan',
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
            CustomProgressWidget(pekerjaan: widget.pekerjaan),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      ...widget.pekerjaan.progres.asMap().entries.map((entry) {
                        // Determine the color based on status
                        int index = entry.key;
                        var progres = entry.value;  
                        bool hasPengumpulan = progres.pengumpulan.isNotEmpty;

                        // Determine the color based on pengumpulan status
                        Color rightBoxColor = Colors.red; // Default color
                        
                        if (hasPengumpulan) {
                          // If there's pengumpulan, check the status
                          var status = progres.pengumpulan[0].status;
                          if (status != 'pending') {
                            rightBoxColor = Colors.yellow; // Yellow if status is not pending
                          } else {
                            rightBoxColor = Colors.green; // Green if status is pending
                          }
                        }
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PengumpulanBuktiPage(
                                  pekerjaan: widget.pekerjaan,
                                  progres: progres,
                                  
                                ),
                              ),
                            );
                          },
                          child: buildCombinedProgressCard(
                            'Progress ${index + 1}',
                            progres.judulProgres,
                            '\r\r${progres.jamKompen}',
                            rightBoxColor,
                          ),
                        );
                      }).toList(),
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

  Widget buildCombinedProgressCard(
      String title, String description, String hours, Color rightBoxColor) {
    final double boxWidth = MediaQuery.of(context).size.width * 0.80;

    return Center(
      child: Container(
        width: boxWidth,
        margin: const EdgeInsets.only(bottom: 10),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 4,
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
                        Icons.upload,
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
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
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              description,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
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

class CustomProgressWidget extends StatelessWidget {
  final Pekerjaan pekerjaan;

  const CustomProgressWidget({
    super.key,
    required this.pekerjaan,
  });

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
              Icons.hourglass_empty,
              color: Colors.white,
              size: 40,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Jumlah Progress: ${pekerjaan.progres.length}',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  Divider(color: Colors.white),
                  Text(
                    'Pekerjaan: ${pekerjaan.pekerjaanNama}',
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