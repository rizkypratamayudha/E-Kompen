import 'package:firstapp/Dosen/pekerjaan.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PopupDosenEditPekerjaan extends StatefulWidget {
  const PopupDosenEditPekerjaan({super.key});

  @override
  State<PopupDosenEditPekerjaan> createState() => _PopupDosenEditPekerjaanState();
}

class _PopupDosenEditPekerjaanState extends State<PopupDosenEditPekerjaan> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.black, width: 2), // Ubah border menjadi warna hitam
      ),
      backgroundColor: Color(0xFF5FDB7A), // Ubah background menjadi hijau (#5FDB7A)
      content: SizedBox(
        width: 350,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle, color: Colors.black), // Ubah icon centang menjadi hitam
                const SizedBox(width: 8),
                Text(
                  'Berhasil',
                  style: GoogleFonts.poppins(
                    color: Colors.black, // Ubah teks menjadi hitam
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const Divider(color: Colors.black),
            const SizedBox(height: 10),
            Text(
              'Data Pekerjaan Berhasil Diperbaharui',
              style: GoogleFonts.poppins(),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PekerjaanDosenPage())
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1C7A1F), // Ubah warna button menjadi hijau gelap (#1C7A1F)
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text('Okay', style: GoogleFonts.poppins(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
