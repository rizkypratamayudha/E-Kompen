import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/kompetensi_service.dart';
import '../Model/kompetensi_model.dart';
import 'kompetensi.dart';

class UploadKompetensi extends StatefulWidget {
  const UploadKompetensi({super.key});

  @override
  State<UploadKompetensi> createState() => _UploadKompetensiState();
}

class _UploadKompetensiState extends State<UploadKompetensi> {
  String nama = '';
  String nim = '';
  String semester = ''; // Untuk menampilkan nama semester seperti "Semester 5"
  int semesterId = 0;   // Untuk menyimpan semester_id
  final TextEditingController kompetensiController = TextEditingController();
  final TextEditingController pengalamanController = TextEditingController();
  final TextEditingController buktiController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      nama = prefs.getString('nama') ?? 'User';
      nim = prefs.getString('username') ?? 'Username';
    });

    // Ambil data userId dari SharedPreferences
    int userId = prefs.getInt('userId') ?? 0;
    if (userId != 0) {
      KompetensiService kompetensiService = KompetensiService();

      // Ambil semester_id dan semester berdasarkan userId
      var semesterData = await kompetensiService.fetchSemesterByUserId(userId);
      setState(() {
        semesterId = semesterData['semester_id']; // Menyimpan semester_id untuk disimpan di database
        semester = semesterData['semester']; // Menampilkan nama semester seperti "Semester 5"
      });
    }
  }

  Future<void> _saveKompetensi() async {
    final prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('userId') ?? 0;

    Kompetensi kompetensi = Kompetensi(
      userId: userId,
      semesterId: semesterId, // Kirim semesterId ke database
      kompetensiNama: kompetensiController.text,
      pengalaman: pengalamanController.text,
      bukti: buktiController.text,
    );

    bool success = await KompetensiService().addKompetensi(kompetensi);

    if (success) {
      showSuccessDialog();
    } else {
      showErrorDialog();
    }
  }

  void showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Berhasil'),
          content: Text('Data kompetensi anda berhasil tersimpan'),
          actions: [
            TextButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => KompetensiMahasiswaPage()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Gagal'),
          content: Text('Gagal menyimpan data kompetensi'),
          actions: [
            TextButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => KompetensiMahasiswaPage()),
            );
          },
        ),
        title: Text(
          'Upload Kompetensi',
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
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildInfo('Nama', nama),
                    buildInfo('NIM', nim),
                    buildInfo('Semester', semester), // Tampilkan nama semester (misal: "Semester 5")
                    buildInfoInput('Kompetensi', kompetensiController),
                    buildInfoInput('Pengalaman', pengalamanController),
                    buildInfoInput('Bukti', buktiController),
                    SizedBox(height: 10),
                    buildSimpan(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
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

  Widget buildInfoInput(String label, TextEditingController controller) {
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
            controller: controller,
            style: GoogleFonts.poppins(
              fontSize: 14,
            ),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSimpan() {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: _saveKompetensi,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          'Simpan',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
      ),
    );
  }
}
