import 'package:firstapp/widget/popup_register.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Register2 extends StatefulWidget {
  const Register2({super.key});

  @override
  State<Register2> createState() => _Register2State();
}

class _Register2State extends State<Register2> {
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
            Text('Form Registrasi Mahasiswa',
            style: GoogleFonts.poppins(
              fontSize: 32, fontWeight: FontWeight.bold
            ),
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
                labelText: 'No. HP',
                border: OutlineInputBorder()
              ),
            ),
            const SizedBox(height: 10,),
            TextField(
              style: GoogleFonts.poppins(),
              decoration: InputDecoration(
                labelText: 'Prodi',
                border: OutlineInputBorder()
              ),
            ),
            const SizedBox(height: 10,),
            TextField(
              style: GoogleFonts.poppins(),
              decoration: InputDecoration(
                labelText: 'Tahun Angkatan',
                border: OutlineInputBorder()
              ),
            ),
            const SizedBox(height: 10,),
            ElevatedButton(
              onPressed: () {
                showDialog(context: context,
                builder: (BuildContext context) {
                  return const PopupRegister();
                }
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 15)
              ),
              child: Text('Register',
              style: GoogleFonts.poppins(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}