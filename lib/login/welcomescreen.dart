import 'package:firstapp/widget/customscaffold.dart';
import 'package:firstapp/widget/welcomebutton.dart';
import 'package:google_fonts/google_fonts.dart'; 
import 'package:flutter/material.dart';

class Welcomescreen extends StatefulWidget {
  const Welcomescreen({super.key});

  @override
  _WelcomescreenState createState() => _WelcomescreenState();
}

class _WelcomescreenState extends State<Welcomescreen> {
  @override
  Widget build(BuildContext context) {
    return Customscaffold(
      child: Column(
        children: [
          Expanded( 
            flex: 8,
            child: Container(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'E-Kompen',
                        style: GoogleFonts.poppins( // Menggunakan Google Fonts
                          fontSize: 45.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: '\nAplikasi Kompen Polinema',
                        style: GoogleFonts.poppins(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const Expanded(
            flex: 2,
            child: Center(
              child: Welcomebutton(
                buttonText: 'Sign in',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
