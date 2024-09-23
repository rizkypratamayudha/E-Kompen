import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class KaprodiDashboard extends StatelessWidget {
  const KaprodiDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Kaprodi'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: const [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, size: 40),
                ),
                SizedBox(width: 10),
                Text(
                  'Hanum Mufida S.T',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Card(
              color: Colors.blue[200],
              child: ListTile(
                title: const Text('Jumlah Penandatangan : 2'),
                subtitle: const Text('Status: Terdapat Tanda Tangan'),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 2,
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Pembuatan Web'),
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('Memasukkan Nilai'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: Column(
                children: const [
                  ListTile(
                    title: Text('Butuh tanda tangan'),
                    trailing: Text('2'),
                  ),
                  ListTile(
                    title: Text('Tanda Tangan Selesai'),
                    trailing: Text('1'),
                  ),
                  ListTile(
                    title: Text('Total Tanda Tangan'),
                    trailing: Text('3'),
                  ),
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
            icon: Icon(Icons.assignment),
            label: 'Tugas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}