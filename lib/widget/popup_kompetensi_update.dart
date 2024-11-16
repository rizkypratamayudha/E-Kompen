import 'package:firstapp/Mahasiswa/kompetensi.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PopupKompetensiUpdate extends StatefulWidget {
  const PopupKompetensiUpdate({super.key});

  @override
  State<PopupKompetensiUpdate> createState() => _PopupKompetensiUpdateState();
}

class _PopupKompetensiUpdateState extends State<PopupKompetensiUpdate> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.black, width: 2), // Border tetap hitam
      ),
      backgroundColor: Color(0xFF72F4FC), // Ubah background menjadi biru muda (#72F4FC)
      content: SizedBox(
        width: 350,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle, color: Colors.black), // Icon tetap hitam
                const SizedBox(width: 8),
                Text(
                  'Data Telah Terbaharui',
                  style: GoogleFonts.poppins(
                    color: Colors.black, // Teks tetap hitam
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const Divider(color: Colors.black),
            const SizedBox(height: 10),
            Text(
              'Data kompetensi anda berhasil tersimpan',
              style: GoogleFonts.poppins(),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => KompetensiMahasiswaPage())
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF007BFF), // Ubah warna tombol menjadi biru (#007BFF)
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
