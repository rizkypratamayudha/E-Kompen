import 'kompetensi.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Model/kompetensi_model.dart';
import '../controller/kompetensi_service.dart';
import '../widget/popup_kompetensi_update.dart';

class EditKompetensi extends StatefulWidget {
  final Kompetensi kompetensi;

  const EditKompetensi({super.key, required this.kompetensi});

  @override
  State<EditKompetensi> createState() => _EditKompetensiState();
}

class _EditKompetensiState extends State<EditKompetensi> {
  String nama = '';
  String nim = '';
  String periode = '';
  int periodeId = 0;

  late TextEditingController _kompetensiController;
  late TextEditingController _pengalamanController;
  late TextEditingController _buktiController;

  @override
  void initState() {
    super.initState();
    _loadUserData();

    _kompetensiController =
        TextEditingController(text: widget.kompetensi.kompetensiNama);
    _pengalamanController =
        TextEditingController(text: widget.kompetensi.pengalaman);
    _buktiController = TextEditingController(text: widget.kompetensi.bukti);
  }

  @override
  void dispose() {
    _kompetensiController.dispose();
    _pengalamanController.dispose();
    _buktiController.dispose();
    super.dispose();
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
        var periodeData = await kompetensiService.fetchPeriodeByUserId(userId);

        setState(() {
          periodeId = periodeData['periode_id'] ?? 0;
          periode = periodeData['periode'] ?? 'Periode Tidak Ditemukan';
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

    int kompetensiId = widget.kompetensi.kompetensiId ?? 0;

    Kompetensi updatedKompetensi = Kompetensi(
      kompetensiId: kompetensiId,
      userId: userId,
      periodeNama: periode,
      kompetensiNama: _kompetensiController.text,
      pengalaman: _pengalamanController.text,
      bukti: _buktiController.text,
    );

    bool success = await KompetensiService()
        .updateKompetensi(kompetensiId, updatedKompetensi);

    if (success) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const PopupKompetensiUpdate();
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memperbarui kompetensi')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => KompetensiMahasiswaPage()),
            );
          },
        ),
        title: Text(
          'Edit Kompetensi',
          style: GoogleFonts.poppins(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
                    buildInfo('Periode', periode),
                    buildInfoInput('Kompetensi', _kompetensiController),
                    buildInfoInput('Pengalaman', _pengalamanController),
                    buildInfoInput('Bukti', _buktiController),
                    const SizedBox(height: 10),
                    buildSaveButton(),
                  ],
                ),
              ),
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
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSaveButton() {
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
