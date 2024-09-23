import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import GoogleFonts
import '../login/login.dart'; // Sesuaikan dengan path file LoginPage

class PopupLogout {
  // Static method untuk menampilkan popup logout
  static void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), 
          ),
          contentPadding: EdgeInsets.zero, 
          content: SizedBox(
            width: 320, 
            height: 126, 
            child: Stack(
              children: [
                Positioned(
                  left: 0, // Mengatur mulai dari sisi kiri
                  right: 0, // Mengatur sampai sisi kanan
                  top: 31, // Mengatur posisi vertikal
                  child: Text(
                    'Apakah Anda ingin keluar?',
                    textAlign:
                        TextAlign.center, 
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 78, 
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Rata kanan-kiri
                    children: [
                      TextButton(
                        onPressed: () {
                          // Navigasi ke halaman Login jika pilih "Ya"
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()),
                            (Route<dynamic> route) =>
                                false, // Menghapus stack sebelumnya
                          );
                        },
                        child: Text(
                          'Ya',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Tutup popup jika pilih "Tidak"
                        },
                        child: Text(
                          'Tidak',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}