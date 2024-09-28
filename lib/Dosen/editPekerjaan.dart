import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditPekerjaanPage extends StatefulWidget {
  @override
  _EditPekerjaanPageState createState() => _EditPekerjaanPageState();
}

class _EditPekerjaanPageState extends State<EditPekerjaanPage> {
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
        title: Text('Edit Pekerjaan'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment
                .start, // Keeps the top box aligned at the top
            children: [
              Center(
                child: Column(
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 300),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Memasukkan Nilai',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 300),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: '2',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 300),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: '1',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 300),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Menguasai Excel',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 300),
                      child: TextFormField(
                        controller: _dateController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Tanggal',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        onTap: () => _selectDate(context),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 300),
                      child: TextFormField(
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText:
                              'Tugas input nilai Mahasiswa menggunakan microsoft Excel',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(height: 32.0),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                          maxWidth: 300), // Aligns buttons with the rest
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Add delete logic here
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
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Add edit logic here
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              minimumSize: Size(120, 40),
                            ),
                            child: Text(
                              'Edit',
                              style: TextStyle(color: Colors.white),
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
