import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Mahasiswa/pekerjaan.dart'; // Import halaman pekerjaan



// Mahasiswa Dashboard Page
class MahasiswaDashboard extends StatelessWidget {
  const MahasiswaDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
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
                      'M. Isroqi Gelby',
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
                        // Handle semester selection change
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
                  child: const Icon(Icons.search),
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      backgroundColor: Colors.blue,
                      iconColor: Colors.white,
                      fixedSize: const Size(76, 44)),
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
                  _buildSummaryCard(
                      'Semester Mahasiswa Saat Ini: 5'),
                  _buildSummaryCard('Total Akumulasi Alpha sampai semester 5 (x2 setiap semester)\n12 * 2^4 = 192 Jam'),
                  _buildKompenCard('Akumulasi Alpha', '192 Jam'),
                ],
              ),
            ),
          ],
        ),
      ),
      
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_add),
            label: 'Tugas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'history',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          )
        ],
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
      ),
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
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(summary, style: GoogleFonts.poppins(
          fontSize: 14
        ),
        ),
      ),
      color: Colors.grey[400],
    );
  }
}
