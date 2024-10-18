// Login Page
import 'package:firstapp/login/login.dart';
import 'package:firstapp/login/register_dosen.dart';
import 'package:firstapp/login/register_kaprodi.dart';
import 'package:firstapp/login/register_mhs.dart';
import 'package:flutter/material.dart';
import '../mahasiswa.dart';
import '../dosen.dart';
import '../kaprodi.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _role = 'Mahasiswa'; // Default role
  // bool _showErrorMessage = false;
  // bool _isPasswordVisible = false; // To track visibility of password

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
              'Sign Up',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
              
              textAlign: TextAlign.center,
              
            ),
            const SizedBox(height: 40),
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
            const SizedBox(height: 10,),
            TextField(
              controller: _namaController,
              style:  GoogleFonts.poppins(
                
              ),
              decoration: const InputDecoration(
                labelText: 'NIM / NIP',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10,),
            TextField(
              controller: _passwordController,
              style:  GoogleFonts.poppins(
                
              ),
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            // const SizedBox(height: 10),
            // TextField(
            //   controller: _passwordController,
            //   style: GoogleFonts.poppins(
                
            //   ),
            //   obscureText: !_isPasswordVisible, // Show/hide password
            //   decoration: InputDecoration(
            //     labelText: 'Password',
            //     border: const OutlineInputBorder(),
            //     suffixIcon: IconButton(
            //       icon: Icon(
            //         // Toggle between visibility icons
            //         _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            //       ),
            //       onPressed: () {
            //         setState(() {
            //           _isPasswordVisible = !_isPasswordVisible; // Toggle visibility
            //         });
            //       },
            //     ),
            //   ),
            // ),
            
            
            SizedBox(height: 10,),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
              },
              child:  Text('Sudah Punya Akun ? Login', style: GoogleFonts.poppins(color: Colors.blue),),
            ),

            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _register,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: Text('Berikutnya',
              style: GoogleFonts.poppins(color: Colors.white),),
            ),
          ],
        ),
      ),
    );
  }

  void _register(){
    setState(() {
      if (_role == 'Mahasiswa'){
        Navigator.push(context, MaterialPageRoute(builder: (context) => Register2()));
      }
      else if (_role == 'Dosen/Tendik'){
        Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterDosen()));
      }
      else if (_role == 'Kaprodi'){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterKaprodi()));
      }
    });
  }
}