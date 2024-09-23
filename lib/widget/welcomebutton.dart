import 'package:firstapp/login/login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Welcomebutton extends StatelessWidget {
  const Welcomebutton({super.key, this.buttonText});
  final String? buttonText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 30.0 ),
      child: ElevatedButton(
      onPressed: () {
        // Navigasi ke halaman login saat tombol ditekan
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 100.0),
        backgroundColor: const Color.fromARGB(64, 255, 255, 255), // Warna latar belakang tombol
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Bentuk tombol
        ),
      ),
      child: Text(
        buttonText!,
        style: GoogleFonts.poppins(
          fontSize: 20.0,
          fontWeight: FontWeight.normal,
          color: Colors.white, // Warna teks
        ),
      ),
    )
    
    
    );
  }
}
