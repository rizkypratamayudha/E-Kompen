import 'package:firstapp/Dosen/edit_progres.dart';
import 'package:firstapp/Dosen/pekerjaan.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'penerimaan_dosen1.dart';
import 'profile.dart';
import '../dosen.dart';
import '../bottombar/bottombarDosen.dart';

class EditPekerjaanPage extends StatefulWidget {
  @override
  _EditPekerjaanPageState createState() => _EditPekerjaanPageState();
}

class _EditPekerjaanPageState extends State<EditPekerjaanPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _dateController = TextEditingController();
  int _selectedIndex = 1;

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
          'Edit Pekerjaan',
          style: GoogleFonts.poppins(fontSize: 22),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all( 16.0, ),
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
                          
                        },
                      ),
                    ),
                    SizedBox(height: 10,),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 300),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Nama Pekerjaan ',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
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
                          suffixIcon: InkWell(
                            onTap: () {
                              Navigator.push(context, 
                              MaterialPageRoute(builder: (context)=>EditProgresPage())
                              );
                            },
                            child: Icon(Icons.menu),
                          )
                          )
                        ),
                      ),
                    
                    // SizedBox(height: 10.0),
                    // ConstrainedBox(
                    //   constraints: BoxConstraints(maxWidth: 300),
                    //   child: TextFormField(
                    //     decoration: InputDecoration(
                    //       labelText: 'Jumlah Jam',
                    //       border: OutlineInputBorder(
                    //           borderRadius: BorderRadius.circular(10)),
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(height: 10.0),
                    // ConstrainedBox(
                    //   constraints: BoxConstraints(maxWidth: 300),
                    //   child: TextFormField(
                    //     controller: _dateController,
                    //     readOnly: true,
                    //     decoration: InputDecoration(
                    //       labelText: 'Batas pengerjaan',
                    //       border: OutlineInputBorder(
                    //           borderRadius: BorderRadius.circular(10)),
                    //       suffixIcon: Icon(Icons.calendar_today),
                    //     ),
                    //     onTap: () => _selectDate(context),
                    //   ),
                    // ),
                    SizedBox(height: 10.0),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 300),
                      child: SizedBox(
                        height: 150.0, 
                        child: TextFormField(
                          maxLines:
                              null, 
                          expands: true, 
                          textAlignVertical:
                              TextAlignVertical.top, 
                          decoration: InputDecoration(
                            labelText: 'Deskripsi tugas...',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30.0),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 300),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Add save logic here
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              minimumSize: Size(120, 40),
                            ),
                            child: Text(
                              'Hapus',
                              style: GoogleFonts.poppins(color: Colors.white),
                            ),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: (){
                              Navigator.push(
                                context, MaterialPageRoute(builder: (context)=>PekerjaanDosenPage())
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              minimumSize: Size(120, 40)
                            ),
                            child: Text('Simpan',
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
