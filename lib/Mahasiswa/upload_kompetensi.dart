import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/kompetensi_service.dart';
import '../Model/kompetensi_model.dart';
import 'kompetensi.dart';
import '../widget/popup_kompetensi_create.dart';


class UploadKompetensi extends StatefulWidget {
  const UploadKompetensi({super.key});

  @override
  State<UploadKompetensi> createState() => _UploadKompetensiState();
}

class _UploadKompetensiState extends State<UploadKompetensi> {
  String nama = '';
  String nim = '';
  String periode =
      ''; // Untuk menampilkan nama periode seperti "2024/2025 Ganjil"
  int periodeId = 0; // Untuk menyimpan periode_id
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

  int userId = prefs.getInt('userId') ?? 0;
  if (userId != 0) {
    KompetensiService kompetensiService = KompetensiService();

    try {
      // Ambil periode_id dan periode berdasarkan userId
      var periodeData = await kompetensiService.fetchPeriodeByUserId(userId);

      // Pastikan periodeData tidak null dan memiliki data yang diperlukan
      setState(() {
        periodeId = periodeData['periode_id'] ?? 0; // Menyimpan periode_id
        periode = periodeData['periode'] ?? 'Periode Tidak Ditemukan'; // Mengatasi null pada periode
      });
    } catch (e) {
      print("Error fetching periode data: $e");
      setState(() {
        periode = 'Periode Tidak Ditemukan';
      });
    }
  }
}


  Future<void> _saveKompetensi() async {
    final prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('userId') ?? 0;

    Kompetensi kompetensi = Kompetensi(
      userId: userId,
      periodeNama: periode, // tambahkan nilai untuk periodeNama
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
      return const PopupKompetensiCreate();
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
              MaterialPageRoute(
                  builder: (context) => KompetensiMahasiswaPage()),
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
                    buildInfo('Periode', periode), // Tampilkan nama periode
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
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 12),
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
