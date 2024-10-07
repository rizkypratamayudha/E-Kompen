import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TambahPekerjaanPage extends StatefulWidget {
  @override
  _TambahPekerjaanPageState createState() => _TambahPekerjaanPageState();
}

class _TambahPekerjaanPageState extends State<TambahPekerjaanPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _dateController = TextEditingController();

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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
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
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 300),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Jumlah Jam',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 300),
                      child: TextFormField(
                        controller: _dateController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Batas pengerjaan',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        onTap: () => _selectDate(context),
                      ),
                    ),
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
                    SizedBox(height: 32.0),
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
                              backgroundColor: Colors.green[400],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              minimumSize: Size(120, 40),
                            ),
                            child: Text(
                              'Buat',
                              style: GoogleFonts.poppins(color: Colors.white),
                            ),
                          ),
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
    );
  }
}
