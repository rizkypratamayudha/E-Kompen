// Login Page
import 'package:flutter/material.dart';
import '../mahasiswa.dart';
import '../dosen.dart';
import '../kaprodi.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _role = 'Mahasiswa'; // Default role
  bool _showErrorMessage = false;
  bool _isPasswordVisible = false; // To track visibility of password

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Sign in',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
              
              textAlign: TextAlign.center,
              
            ),
            const SizedBox(height: 40),
            if (_showErrorMessage)
            Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(8),
              child:  Text(
                'Username / Password Salah',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                  color: Colors.white, 
                  fontSize: 12,
                  ),
                  ),
                  textAlign: TextAlign.center,
              ),
            ),
              
            const SizedBox(height: 10),
            TextField(
              controller: _usernameController,
              style:  GoogleFonts.poppins(
                
              ),
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              style: GoogleFonts.poppins(
                
              ),
              obscureText: !_isPasswordVisible, // Show/hide password
              decoration: InputDecoration(
                labelText: 'Password',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    // Toggle between visibility icons
                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible; // Toggle visibility
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _role,
              items: ['Mahasiswa', 'Dosen/Tendik', 'Kaprodi']
                  .map((role) => DropdownMenuItem(
                        value: role,
                        child: Text(role, style: GoogleFonts.poppins(fontSize: 14),),
                        
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _role = value!;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Role',
                labelStyle: TextStyle(fontSize: 14),
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10)
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: Text('Login',
              style: GoogleFonts.poppins(color: Colors.white),),
            ),
          ],
        ),
      ),
    );
  }

  void _login() {
    setState(() {
      if (_usernameController.text == '12345' &&
          _passwordController.text == '12345') {
        _showErrorMessage = false;

        // Navigate to the appropriate dashboard based on the role
        if (_role == 'Mahasiswa') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MahasiswaDashboard()),
          );
        } else if (_role == 'Dosen/Tendik') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DosenDashboard()),
          );
        } else if (_role == 'Kaprodi') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const KaprodiDashboard()),
          );
        } else {
          // Handle other roles if necessary
          _showErrorMessage = true;
        }
      } else {
        _showErrorMessage = true;
      }
    });
  }
}