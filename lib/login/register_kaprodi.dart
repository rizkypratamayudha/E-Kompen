import 'package:firstapp/config/config.dart';
import 'package:firstapp/widget/popup_register.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RegisterKaprodi extends StatefulWidget {
  final String username;
  final String password;
  final String nama;
  final int roleId;

  const RegisterKaprodi({
    required this.username,
    required this.password,
    required this.nama,
    required this.roleId,
    Key? key,
  }) : super(key: key);

  @override
  State<RegisterKaprodi> createState() => _RegisterKaprodiState();
}

class _RegisterKaprodiState extends State<RegisterKaprodi> {
  final _formKey = GlobalKey<FormState>();
  String? _email;
  String? _nohp;

  Future<void> _registerKaprodi() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse('${config.baseUrl}/registerWithDetails'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'username': widget.username,
          'password': widget.password,
          'nama': widget.nama,
          'level_id': widget.roleId,
          'prodi_id': null,  // Tidak diperlukan untuk dosen
          'angkatan': null,  // Tidak diperlukan untuk dosen
          'email': _email,
          'no_hp': _nohp,
        }),
      );

      if (response.statusCode == 201) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const PopupRegister();
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Form Registrasi Kaprodi',
          style: GoogleFonts.poppins(fontSize: 22),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16.0, 30.0, 16.0, 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 300),
                      child: TextFormField(
                        initialValue: widget.nama,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Nama',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 300),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Mohon Masukkan Email';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          _email = value;
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 300),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'No HP',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Mohon Masukkan No HP';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          _nohp = value;
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _registerKaprodi,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 120),
                      ),
                      child: Text(
                        'Register',
                        style: GoogleFonts.poppins(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
