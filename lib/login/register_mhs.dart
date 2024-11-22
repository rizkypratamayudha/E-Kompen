import 'package:firstapp/config/config.dart';
import 'package:firstapp/widget/popup_register.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RegisterMahasiswa extends StatefulWidget {
  final String username;
  final String password;
  final String nama;
  final int roleId;

  const RegisterMahasiswa({
    required this.username,
    required this.password,
    required this.nama,
    required this.roleId,
    Key? key,
  }) : super(key: key);

  @override
  State<RegisterMahasiswa> createState() => _RegisterMahasiswaState();
}

class _RegisterMahasiswaState extends State<RegisterMahasiswa> {
  final _formKey = GlobalKey<FormState>();
  int? _prodiId;
  int? _periodeId;
  String? _email;
  String? _nohp;
  String? _angkatan;

  Future<void> _registerMahasiswa() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse('${config.baseUrl}/registerWithDetails'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'username': widget.username,
          'password': widget.password,
          'nama': widget.nama,
          'level_id': widget.roleId,
          'prodi_id': _prodiId,
          'email': _email,
          'no_hp': _nohp,
          'angkatan': _angkatan,
          'periode_id': _periodeId,
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
          'Form Registrasi Mahasiswa',
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
                      child: DropdownButtonFormField<int>(
                        decoration: InputDecoration(
                          labelText: 'Pilih Prodi',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        items: [
                          DropdownMenuItem(value: 1, child: Text('D4 Sistem Informasi Bisnis')),
                          DropdownMenuItem(value: 2, child: Text('D4 Teknik Informatika')),
                          DropdownMenuItem(value: 3, child: Text('D2 PPLS')),
                        ],
                        onChanged: (int? newValue) {
                          setState(() {
                            _prodiId = newValue;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Mohon pilih jenis prodi';
                          }
                          return null;
                        },
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
                    SizedBox(height: 10),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 300),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Angkatan',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Mohon masukkan Angkatan';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          _angkatan = value;
                        },
                      ),
                    ),
                    SizedBox(height: 10,),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 300),
                      child: DropdownButtonFormField<int>(
                        decoration: InputDecoration(
                          labelText: 'Pilih Periode',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        items: [
                          DropdownMenuItem(value: 20221, child: Text('2022/2023 Ganjil')),
                          DropdownMenuItem(value: 20222, child: Text('2022/2023 Genap')),
                          DropdownMenuItem(value: 20241, child: Text('2023/2024 Ganjil')),
                          DropdownMenuItem(value: 20242, child: Text('2023/2024 Genap')),
                        ],
                        onChanged: (int? newValue) {
                          setState(() {
                            _periodeId = newValue;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Mohon pilih Periode';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _registerMahasiswa,
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
