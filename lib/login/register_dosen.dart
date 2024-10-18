import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterDosen extends StatefulWidget {
  const RegisterDosen({super.key});

  @override
  State<RegisterDosen> createState() => _RegisterDosenState();
}

class _RegisterDosenState extends State<RegisterDosen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Form Registrasi \nDosen', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40,),
            TextField(
              style: GoogleFonts.poppins(),
              decoration: InputDecoration(
                labelText: 'Nama',
                border: OutlineInputBorder()
              ),
            ),
            const SizedBox(height: 10,),
            TextField(
              style: GoogleFonts.poppins(),
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder()
              ),
            ),
            const SizedBox(height: 10,),
            TextField(
              style: GoogleFonts.poppins(),
              decoration: InputDecoration(
                labelText: 'No.HP',
                border: OutlineInputBorder()
              ),
            ),
            const SizedBox(height: 10,),
            TextField(
              style: GoogleFonts.poppins(),
              decoration: InputDecoration(
                
              ),
            )
          ],
        ),
      ),
    );
  }
}