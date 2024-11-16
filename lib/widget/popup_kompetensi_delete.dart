import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Mahasiswa/kompetensi.dart';

class PopupKompetensiDelete extends StatelessWidget {
  final VoidCallback onDeleteConfirmed;

  const PopupKompetensiDelete({super.key, required this.onDeleteConfirmed});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Center(
        child: Text(
          "Apakah Anda ingin menghapus kompetensi?",
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade300,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Tidak',
                style: GoogleFonts.poppins(color: Colors.black),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close initial dialog
                onDeleteConfirmed(); // Confirm deletion
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Ya',
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class PopupKompetensiDeletedSuccess extends StatelessWidget {
  const PopupKompetensiDeletedSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.black, width: 2),
      ),
      backgroundColor: Color(0xFFB96565), // Change background to #B96565
      content: SizedBox(
        width: 350,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle, color: Colors.black),
                const SizedBox(width: 8),
                Text(
                  'Data Telah Terhapus',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const Divider(color: Colors.black),
            const SizedBox(height: 10),
            Text(
              'Data kompetensi anda berhasil terhapus',
              style: GoogleFonts.poppins(),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Simply close the dialog
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFF1100),
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

