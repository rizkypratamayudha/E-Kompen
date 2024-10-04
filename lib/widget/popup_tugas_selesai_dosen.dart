import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PopupTugasSelesaiDosen extends StatelessWidget{
  const PopupTugasSelesaiDosen({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      content: SizedBox(
        width: 350,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pekerjaan : Memasukkan Nilai',
              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            Text(
              'Jumlah Jam : 2 Jam',
              style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
            Text(
              'Nama Mahasiswa : Solikhin',
              style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
            Text(
              'Pengumpulan : Telah Diserahkan',
              style: GoogleFonts.poppins(fontSize: 14,fontWeight: FontWeight.w500),
              ),
            const SizedBox(height: 10,),
            Text(
              'Foto Bukti : ',
              style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            SizedBox(height: 20),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Icon(Icons.image, size: 50,color: Colors.grey,),
              ),
            ),
          ],
        ),
      ),
    );
  }
}