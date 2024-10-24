import 'package:firstapp/widget/popup_register.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/retry.dart';

class RegisterDosen extends StatefulWidget {
  const RegisterDosen({super.key});

  @override
  State<RegisterDosen> createState() => _RegisterDosenState();
}

class _RegisterDosenState extends State<RegisterDosen> {
  final _formKey = GlobalKey<FormState>();
  String? _nama;
  String? _email;
  String? _nohp;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Form Registrasi Dosen',
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
                    ConstrainedBox(constraints: BoxConstraints(maxWidth: 300),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Nama',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        )
                      ),
                      validator: (value) {
                        if(value == null || value.isEmpty){
                          return 'Mohon masukkan nama';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        _nama;
                      },
                    ),
                    ),
                    SizedBox(height: 10,),
                    ConstrainedBox(constraints: BoxConstraints(maxWidth: 300),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)
                        )
                      ),
                      validator: (value) {
                        if(value == null || value.isEmpty){
                          return 'Mohon masukkan email';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        _email;
                      },
                    ),),
                    SizedBox(height: 10,),
                    ConstrainedBox(constraints: BoxConstraints(maxWidth: 300),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'No HP',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)
                        )
                      ),
                      validator: (value) {
                        if(value == null || value.isEmpty){
                          return 'Mohon masukkan No HP';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        _nohp;
                      },
                    ),
                    ),
                    SizedBox(height: 20,),
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
          ),
        ),
      ),
    );
  }
}