import 'package:firstapp/Dosen/tambah_progres.dart';
import 'package:firstapp/controller/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'penerimaan_dosen1.dart';
import 'profile.dart';
import '../dosen.dart';
import '../bottombar/bottombarDosen.dart';

class TambahPekerjaanPage extends StatefulWidget {
  const TambahPekerjaanPage({super.key});

  @override
  _TambahPekerjaanPageState createState() => _TambahPekerjaanPageState();
}

class _TambahPekerjaanPageState extends State<TambahPekerjaanPage> {
  final _formKey = GlobalKey<FormState>();
  final AuthService authService = AuthService();

  final TextEditingController _dateController = TextEditingController();
  int _selectedIndex = 1;
  String? _nama;
  String? _jenisTugas;
  String? _jumlahAnggota;
  String? _persyaratan;
  String? _jumlahProgress;
  String? _deskripsi;


  void _onItemTapped(int index) {
    if (index == _selectedIndex) {
      return;
    }

    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      return;
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PenerimaanDosen1()),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()),
      );
    } else if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DosenDashboard()),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = picked.toIso8601String().split('T')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tambah Pekerjaan',
          style: GoogleFonts.poppins(fontSize: 22),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
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
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Jenis Tugas',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        items: <String>[
                          'Penelitian',
                          'Pengabdian',
                          'Teknis'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _jenisTugas = newValue; // Menyimpan nilai
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
                    SizedBox(height: 10),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 300),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Nama Pekerjaan',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Mohon masukkan nama pekerjaan';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          _nama = value;
                        },
                      ),
                    ),
                    SizedBox(height: 10.0),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 300),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Jumlah Anggota',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Mohon masukkan jumlah anggota';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          _jumlahAnggota = value;
                        },
                      ),
                    ),
                    SizedBox(height: 10.0),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 300),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Persyaratan',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Mohon masukkan persyaratan';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          _persyaratan = value;
                        },
                      ),
                    ),
                    SizedBox(height: 10.0),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 300),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Jumlah Progress',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Mohon masukkan jumlah progress';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          _jumlahProgress = value;
                        },
                      ),
                    ),
                    SizedBox(height: 10.0),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 300),
                      child: SizedBox(
                        height: 150.0,
                        child: TextFormField(
                          maxLines: null,
                          expands: true,
                          textAlignVertical: TextAlignVertical.top,
                          decoration: InputDecoration(
                            labelText: 'Deskripsi tugas...',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Mohon masukkan deskripsi tugas';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            _deskripsi = value;
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 40.0),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 300),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(width: 70),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                // Jika semua validasi berhasil
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            TambahProgresPage()));
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                minimumSize: Size(120, 40)),
                            child: Text(
                              'Next',
                              style: GoogleFonts.poppins(color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBarDosen(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      backgroundColor: Colors.white,
    );
  }
}
