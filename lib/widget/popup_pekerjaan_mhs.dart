import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PopUpPekerjaan extends StatelessWidget {
  const PopUpPekerjaan({super.key});

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
              'Nama Dosen : Taufiq S.Tr S.I.B',
              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            Text(
              'Nomor Dosen : 083166441802',
              style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 10),
            Text(
              'Jenis Tugas : Teknis',
              style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 10),
            Text(
              'Jumlah Jam : 100 Jam',
              style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 10),
            Text(
              'Persyaratan : Bisa Coding',
              style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 10),
            Text(
              'Batas Pengerjaan : 2024-10-30',
              style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Membantu web sederhana untuk pelaporan jumlah komputer yang tidak layak pakai. Berkolaborasi dengan 5 mahasiswa.',
                style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w300),
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Tutup popup
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Apply',
                  style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
