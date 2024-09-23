import 'package:firstapp/widget/customscaffold.dart';
import 'package:firstapp/widget/welcomebutton.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import '../login/login.dart';

class Welcomescreen extends StatelessWidget {
  const Welcomescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Customscaffold(
      child: Column(
        children: [
          Flexible(
              flex: 8,
              child: Container(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(children: [
                      TextSpan(
                          text: 'E-Kompen',
                          style: TextStyle(
                            fontSize: 45.0,
                            fontWeight: FontWeight.w600,
                          )),
                      TextSpan(
                        text: '\nAplikasi Kompen Polinema',
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.w200),
                      )
                    ]),
                  ),
                ),
              )),
          const Flexible(
              flex: 1,
              child: Center(
                child: Welcomebutton(
                  buttonText: 'Mulai >>>',
                ),
              ))
        ],
      ),
    );
  }
}
