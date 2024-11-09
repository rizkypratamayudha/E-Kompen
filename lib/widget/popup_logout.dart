import 'package:firstapp/controller/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../login/login.dart';


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
                  left: 0,
                  right: 0,
                  top: 31,
                  child: Text(
                    'Apakah Anda ingin keluar?',
                    textAlign: TextAlign.center,
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () async {
                          // Panggil fungsi logout dari AuthService
                          final authService = AuthService();
                          await authService.logout();

                          // Bersihkan SharedPreferences jika diperlukan
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.clear();

                          // Navigasi ke halaman Login
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()),
                            (Route<dynamic> route) => false,
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
