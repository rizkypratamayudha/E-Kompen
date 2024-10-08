import 'dart:ffi';

import 'package:firstapp/Dosen/pekerjaan.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TambahProgresPage extends StatefulWidget {
  @override
  _TambahProgresPageState createState() => _TambahProgresPageState();
}

class _TambahProgresPageState extends State<TambahProgresPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _dateController = TextEditingController();
  int _progressCount = 4;

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

  void _addProgress() {
    setState(() {
      _progressCount++;
    });
  }

  void _removeProgress() {
    if (_progressCount > 1) {
      setState(() {
        _progressCount--;
      });
    }
  }

  void _showAkumulasi() {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 16),
            _buildJam('Jumlah Jam:', '40'),
            SizedBox(height: 5),
            _buildTanggal('Batas Pengerjaan:', '2024-01-01'),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,  // Menempatkan tombol di sebelah kanan
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) =>PekerjaanDosenPage())
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Simpan',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}



  Widget _buildProgressForm(int index) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Progress $index',
                  style: GoogleFonts.poppins(
                      fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.red),
                  onPressed: _removeProgress,
                ),
              ],
            ),
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Judul Progress',
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10)
              ),
            ),
          ),
          SizedBox(height: 10),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Jumlah Jam',
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10)
              ),
              suffixIcon: Icon(Icons.access_alarm)
            ),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 10),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Hari yang diperlukan',
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10)
              ),
              suffixIcon: Icon(Icons.calendar_month)
            ),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }

  @override
  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      title: Text(
        'Tambah Pekerjaan',
        style: GoogleFonts.poppins(fontSize: 20),
      ),
    ),
    body: Stack(
      children: [
        SingleChildScrollView(
          padding: EdgeInsets.only(left: 16, right: 16, bottom: 80), // Tambahkan padding bawah agar tidak tertutup
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Jumlah Progress: $_progressCount',
                style: GoogleFonts.poppins(fontSize: 16),
              ),
              for (int i = 1; i <= _progressCount; i++) _buildProgressForm(i),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
            child: _buildAkumulasi('Akumulasi'),
          )
        ),
      ],
    ),
  );
}


  Widget _buildAkumulasi(String akumulasi){
    return Card(
      color: Colors.blue,
      child: ListTile(
        title: Text(
          akumulasi, style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_drop_up,
          color: Colors.white,
          size: 30,
          ),
          onPressed: () => _showAkumulasi(),
        ),
      ),
    );
  }

  Widget _buildJam(String judul, String jam){
    return Card(
      color: Colors.blue,
      child: ListTile(
        title: Text(
          judul, style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
        ),
        trailing: Text(
          jam, style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
        ),
      ),
    );
  }
  Widget _buildTanggal(String judul, String tanggal){
    return Card(
      color: Colors.blue,
      child: ListTile(
        title: Text(
          judul, style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
        ),
        trailing: Text(
          tanggal, style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
        ),
      ),
    );
  }
}
