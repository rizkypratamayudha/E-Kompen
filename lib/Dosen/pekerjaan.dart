import 'package:flutter/material.dart';

class PekerjaanPage extends StatelessWidget {
  const PekerjaanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pekerjaan'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Card(
              color: Colors.blue,
              child: ListTile(
                title: const Text('Pembuatan Web',
                    style: TextStyle(color: Colors.white)),
                trailing: const Icon(Icons.menu, color: Colors.white),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              color: Colors.blue,
              child: ListTile(
                title: const Text('Memasukkan Nilai',
                    style: TextStyle(color: Colors.white)),
                trailing: const Icon(Icons.menu, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Tambahkan fungsi untuk menambah pekerjaan
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
