import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'bottombar/bottombarKaprodi.dart';
import 'Kaprodi/profile.dart';
import 'Kaprodi/penandatanganan_kaprodi.dart';

class KaprodiDashboard extends StatefulWidget {
  const KaprodiDashboard({super.key});

  @override
  _KaprodiDashboardState createState() => _KaprodiDashboardState();
}

class _KaprodiDashboardState extends State<KaprodiDashboard> {
  int _selectedIndex = 0;


void _onItemTapped(int index) {
  setState(() {
    _selectedIndex = index;
  });

  if (index == 0) {
    return;
  } else if (index == 1) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PenandatangananKaprodi()), // Halaman Penerimaan
    );
  } else if (index == 2) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ProfilePage()), // Halaman Profile
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section (This part will stay fixed)
          Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 50.0, 10.0, 20.0),
            child: Row(
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
                      'Hanum Mufida S.T',
                      style: GoogleFonts.poppins(),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Content Section (Scrollable content)
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                          'Jumlah Penandatanganan: 2',
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
                          'Status: Terdapat Tanda Tangan',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Task List Section
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        _buildTaskCard('Pembuatan Web', Colors.blue),
                        _buildTaskCard('Memasukkan Nilai', Colors.blue),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Table Section
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Table(
                      columnWidths: const {
                        0: FlexColumnWidth(1),
                        1: FlexColumnWidth(1),
                        2: FlexColumnWidth(1),
                      },
                      border: TableBorder.symmetric(
                        inside: BorderSide(color: Colors.grey, width: 1),
                      ),
                      children: [
                        _buildTableRow('Butuh tanda tangan', '2'),
                        _buildTableRow('Tanda tangan selesai', '1'),
                        _buildTableRow('Total tanda tangan', '3'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavBarKaprodi(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  // Task Card Widget
  Widget _buildTaskCard(String title, Color color) {
    return Card(
      margin:
          const EdgeInsets.symmetric(vertical: 5), // Add margin between cards
      color: color,
      child: ListTile(
        title: Text(
          title,
          style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
        ),
        // trailing: const Icon(Icons.arrow_forward, color: Colors.white), // Example icon
      ),
    );
  }

  // Table Row Widget
  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            label,
            style: GoogleFonts.poppins(fontSize: 14),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            value,
            style: GoogleFonts.poppins(fontSize: 14),
          ),
        ),
      ],
    );
  }
}
