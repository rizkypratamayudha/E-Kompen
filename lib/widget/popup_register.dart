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
        borderRadius: BorderRadius.circular(10)
      ),
      content: SizedBox(
        width: 350,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Text('Data Telah Tersimpan, \nMohon menunggu verifikasi dari admin',
              style: GoogleFonts.poppins(),
              ),
            ),
            const SizedBox(height: 10,),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, 
                  MaterialPageRoute(builder: (context) => LoginPage())
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  )
                ),
                child: Text('Okay', style: GoogleFonts.poppins(color: Colors.white)),
              ),
            )
          ],
        )
      ),
    );
  }
}