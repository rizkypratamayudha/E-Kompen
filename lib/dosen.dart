import 'package:flutter/material.dart';


// Dosen Dashboard Page
class DosenDashboard extends StatelessWidget {
  const DosenDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Dosen'),
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
                  'Taufik Abdus S.T',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Card(
              color: Colors.blue[200],
              child: ListTile(
                title: const Text('Jumlah Tugas Aktif : 2'),
                subtitle: const Text('Status: Terdapat Pengajuan tugas'),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 2,
              child: Column(
                children: [
                  ListTile(
                    leading: const CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.black,
                    ),
                    title: const Text('Pembuatan Web'),
                    subtitle: const Text('Menunggu'),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.green,
                    ),
                    title: const Text('Memasukkan Nilai'),
                    subtitle: const Text('Dalam Pekerjaan'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: Column(
                children: const [
                  ListTile(
                    title: Text('Tugas Aktif'),
                    trailing: Text('2'),
                  ),
                  ListTile(
                    title: Text('Tugas Selesai'),
                    trailing: Text('1'),
                  ),
                  ListTile(
                    title: Text('Total Tugas'),
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
