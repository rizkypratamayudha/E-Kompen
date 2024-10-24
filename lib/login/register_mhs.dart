import 'package:firstapp/widget/popup_register.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Register2 extends StatefulWidget {
  const Register2({super.key});

  @override
  State<Register2> createState() => _Register2State();
}

class _Register2State extends State<Register2> {
  final _formKey = GlobalKey<FormState>();
  String? _nama;
  String? _prodi;
  String? _email;
  String? _nohp;
  String? _angkatan;
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
                          decoration: InputDecoration(
                              labelText: 'Nama',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Mohon Masukkan Nama';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            _nama;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 300),
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Pilih Prodi',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          items: <String>[
                            'D4 Sistem Informasi Bisnis',
                            'D4 Teknik Informatika'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _prodi = newValue;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Mohon pilih jenis tugas';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 300),
                        child: TextFormField(
                          decoration: InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Mohon Masukkan Email';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            _email;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 300),
                        child: TextFormField(
                          decoration: InputDecoration(
                              labelText: 'No HP',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Mohon Masukkan No HP';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            _nohp;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 300),
                        child: TextFormField(
                          decoration: InputDecoration(
                              labelText: 'Angkatan',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Mohon masukkan Angkatan';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            _angkatan;
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if(_formKey.currentState!.validate()){
                            showDialog(context: context,
                            builder: (BuildContext context){
                              return const PopupRegister();
                            }
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 120)
                        ),
                        child: Text('Register',
                          style: GoogleFonts.poppins(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }
}
