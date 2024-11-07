import 'package:firstapp/login/login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PopupRegister extends StatefulWidget {
  const PopupRegister({super.key});

  @override
  State<PopupRegister> createState() => _PopupRegisterState();
}

class _PopupRegisterState extends State<PopupRegister> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.green, width: 2), // Border stroke color dan ketebalan
      ),
      content: SizedBox(
        width: 350,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle, color: Colors.green), // Icon centang warna hijau
                const SizedBox(width: 8),
                Text(
                  'Data Telah Tersimpan',
                  style: GoogleFonts.poppins(
                    color: Colors.green,
                    fontWeight: FontWeight.bold, // Bold text
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const Divider(color: Colors.black), // Garis hitam
            const SizedBox(height: 10),
            Text(
              'Mohon menunggu verifikasi dari admin Maksimal 3 hari, pemberian informasi akan terkirim pada email anda',
              style: GoogleFonts.poppins(),
              textAlign: TextAlign.justify, // Text-align justified
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage())
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
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
