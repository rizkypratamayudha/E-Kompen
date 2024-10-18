import 'kompetensi.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditKompetensi extends StatefulWidget {
  const EditKompetensi({super.key});

  @override
  State<EditKompetensi> createState() => _EditKompetensiState();
}

class _EditKompetensiState extends State<EditKompetensi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(context,
            MaterialPageRoute(builder: (context) => KompetensiMahasiswaPage())
            );
          },
        ),
        title: Text('Edit Kompetensi',
        style: GoogleFonts.poppins(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10)
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildInfo('Nama', 'M. Gelby Firmansyah'),
                      buildInfo('Nim', '2241760020'),
                      buildInfo('IPK', '4.00'),
                      buildInfo('Semester', '5'),
                      buildInfoinput('Kompetensi', ),
                      buildInfoinput('Pengalaman', ),
                      buildInfoinput('Bukti', ),
                      SizedBox(height: 10,),
                      buildsimpan()
                    ],
                  
                  ),
                  
                ),
                
              )
            ],
          ),
        ),
      
      )
    );
  }

  Widget buildInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
            ),
          ),
          const Divider(
            color: Colors.black,
          ),
        ],
      ),
    );
  }
  Widget buildInfoinput(String label,) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 2),
            TextFormField(
              style: GoogleFonts.poppins(
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
  }

  Widget buildsimpan(){
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: () {
          
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          )
        ),
        child: Text('Simpan'
        ,style: GoogleFonts.poppins(color: Colors.white),
        ),
      )
    );
  }
  
}