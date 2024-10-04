import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Dosen/pekerjaan.dart'; 
import 'Dosen/profile.dart'; 
import 'Dosen/penerimaan_dosen1.dart'; 
import 'bottombar/bottombarDosen.dart';

class DosenDashboard extends StatefulWidget {
  const DosenDashboard({super.key});

  @override
  _DosenDashboardState createState() => _DosenDashboardState();
}

class _DosenDashboardState extends State<DosenDashboard> {
  int _selectedIndex = 0;

  // Function to handle navigation based on the index from BottomNavigationBar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>  PekerjaanDosenPage()), // Update the page if needed
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>  PenerimaanDosen1()), // Update the page if needed
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()), // Update the page if needed
      );
    } else if (index == 0) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(10.0, 50.0, 10.0, 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
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
                      'Taufik Abdus S.T',
                      style: GoogleFonts.poppins(),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Task Summary Section
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Jumlah Tugas Aktif: 2',
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
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Status: Terdapat Pengajuan tugas',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Task Status Section
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Status:',
                    style: GoogleFonts.poppins(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _buildStatusIndicator(Colors.black, 'Menunggu'),
                      const SizedBox(width: 25),
                      _buildStatusIndicator(Colors.green, 'Dalam Pekerjaan'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildTaskCard('Pembuatan Web', Colors.black),
                  _buildTaskCard('Memasukkan Nilai', Colors.green),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Task List Section
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTaskSummary('Tugas Aktif', '2'),
                  const Padding(
                    padding: EdgeInsets.only(top: 5, bottom: 5),
                    child: Divider(
                      color: Colors.white,
                      thickness: 2,
                    ),
                  ),
                  const SizedBox(height: 5),
                  _buildTaskSummary('Tugas Selesai', '1'),
                  const Padding(
                    padding: EdgeInsets.only(top: 5, bottom: 5),
                    child: Divider(
                      color: Colors.white,
                      thickness: 2,
                    ),
                  ),
                  const SizedBox(height: 5),
                  _buildTaskSummary('Total Tugas', '3'),
                ],
              ),
            ),
          ],
        ),
      ),
      // Using BottomNavBar
      bottomNavigationBar: BottomNavBarDosen(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      backgroundColor: Colors.white,
    );
  }

  // Status Indicator Widget
  Widget _buildStatusIndicator(Color color, String label) {
    return Row(
      children: [
        CircleAvatar(
          radius: 5,
          backgroundColor: color,
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 14),
        ),
      ],
    );
  }

  // Task Card Widget
  Widget _buildTaskCard(String taskName, Color statusColor) {
    return Card(
      child: ListTile(
        title: Text(
          taskName,
          style: GoogleFonts.poppins(fontSize: 14),
        ),
        trailing: CircleAvatar(
          radius: 5,
          backgroundColor: statusColor,
        ),
      ),
    );
  }

  // Task Summary Widget
  Widget _buildTaskSummary(String title, String count) {
    return Card(
      child: ListTile(
        title: Text(
          title,
          style: GoogleFonts.poppins(fontSize: 14),
        ),
        trailing: Text(
          count,
          style: GoogleFonts.poppins(fontSize: 14),
        ),
      ),
    );
  }
}
