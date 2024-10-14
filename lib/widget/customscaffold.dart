import 'package:flutter/material.dart';

class Customscaffold extends StatelessWidget {
  const Customscaffold({super.key, this.child});
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false, 
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Positioned.fill( 
            child: Image.asset(
              'assets/img/bg1.jpg',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: child ?? const SizedBox.shrink(), 
          ),
        ],
      ),
    );
  }
}
