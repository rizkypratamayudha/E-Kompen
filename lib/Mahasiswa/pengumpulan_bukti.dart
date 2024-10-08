import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PengumpulanBuktiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Progress 1',
          style: GoogleFonts.poppins(fontSize: 20, color: Colors.black),
        ),
        backgroundColor: Colors.white, // Warna AppBar putih
        elevation: 0, // Menghilangkan bayangan AppBar
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Colors.black), // Tombol back dengan ikon hitam
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: Colors.white, // Warna background body putih
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tugas : Memasukkan Nilai',
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.black),
            ),
            SizedBox(height: 10),
            Text(
              'Batas pengerjaan : 2024-10-30',
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.black),
            ),
            SizedBox(height: 10),
            Text(
              'Jumlah jam : 100 jam',
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.black),
            ),
            SizedBox(height: 20),
            Text(
              'Foto bukti :',
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.black),
            ),
            SizedBox(height: 10),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[100], // Warna latar belakang abu muda
                borderRadius:
                    BorderRadius.circular(10), // Menambahkan border radius
              ),
              child: Center(
                child: Icon(Icons.image, size: 50, color: Colors.grey),
              ),
            ),
            SizedBox(height: 200),
            SizedBox(
              width: double.infinity, // Lebar tombol memenuhi layar
              child: ElevatedButton(
                onPressed: () {
                  // Tambahkan logika untuk mengunggah bukti atau mengambil foto
                },
                child: Text(
                  '+ Tambah / buat',
                  style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Warna tombol biru
                  padding: EdgeInsets.symmetric(vertical: 16),
                  textStyle: GoogleFonts.poppins(fontSize: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Border radius 10
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}