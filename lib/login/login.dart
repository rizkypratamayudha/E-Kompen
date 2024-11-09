import 'dart:convert';
import 'package:firstapp/Model/user_model.dart';
import 'package:firstapp/config/config.dart';
import 'package:firstapp/controller/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firstapp/login/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  String _role = 'Mahasiswa';
  bool _showErrorMessage = false;
  String _errorMessage = '';
  bool _isPasswordVisible = false;
  final AuthService _authService = AuthService();

  Future<void> _login() async{
    final result = await _authService.login(
      _usernameController.text,
      _passwordController.text,
      _role,
    );

    if (result['success'] == true) {
      final user = result['user'] as UserModel;

      setState(() {
        _showErrorMessage = false;
      });

      if (user.role == 'Mahasiswa'){
        Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => const MahasiswaDashboard())
        );
      }
      else if (user.role == 'Dosen/Tendik'){
        Navigator.push(context, 
        MaterialPageRoute(builder: (context) => const DosenDashboard())
        );
      }
      else if (user.role == 'Kaprodi'){
        Navigator.push(context, MaterialPageRoute(builder: (context) => const KaprodiDashboard()));
      }
      else {
        setState(() {
          _showErrorMessage = true;
          _errorMessage = result['message'];
        });
      }
    }
  }

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
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
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
                child: Text(
                  _errorMessage,
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 10),
            TextField(
              controller: _usernameController,
              style: GoogleFonts.poppins(),
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              style: GoogleFonts.poppins(),
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Password',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
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
                        child: Text(role, style: GoogleFonts.poppins(fontSize: 14)),
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
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => RegisterPage()));
              },
              child: Text(
                'Tidak punya akun ? register',
                style: GoogleFonts.poppins(color: Colors.blue),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: Text(
                'Login',
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
