import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../bottombar/bottombar.dart';
import 'riwayat.dart';
import 'pekerjaan.dart';
import '../mahasiswa.dart';
import 'upload_kompetensi.dart';
import 'edit_kompetensi.dart';
import 'detail_kompetensi.dart';
import '../controller/kompetensi_service.dart';
import '../Model/kompetensi_model.dart';
import '../widget/popup_kompetensi_delete.dart';

class KompetensiMahasiswaPage extends StatefulWidget {
  const KompetensiMahasiswaPage({super.key});

  @override
  _KompetensiMahasiswaPageState createState() =>
      _KompetensiMahasiswaPageState();
}

class _KompetensiMahasiswaPageState extends State<KompetensiMahasiswaPage> {
  int _selectedIndex = 3;
  String nama = "";
  List<Kompetensi> kompetensiList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNama();
    _loadKompetensi();
  }

  // Fungsi untuk mengambil nama pengguna dari SharedPreferences
  Future<void> _loadNama() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      nama = prefs.getString('nama') ?? 'User';
    });
  }

  Future<void> _loadKompetensi() async {
    int userId = await _getUserId();
    KompetensiService kompetensiService = KompetensiService();
    try {
      List<Kompetensi> kompetensiData =
          await kompetensiService.fetchKompetensi(userId);

      // Sort competencies by `kompetensi_id` in ascending order
      kompetensiData.sort((a, b) => a.kompetensiId!.compareTo(b.kompetensiId!));

      setState(() {
        kompetensiList = kompetensiData;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<int> _getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId') ?? 0;
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) {
      return;
    }
    setState(() {
      _selectedIndex = index;
    });
    if (index == 3) {
      return;
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PekerjaanPage()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => RiwayatPage()),
      );
    } else if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MahasiswaDashboard()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => RiwayatPage()));
          },
        ),
        title: Text(
          'Kompetensi',
          style: GoogleFonts.poppins(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomKompetensiWidget(
                    userName: nama,
                    kompetensiCount: kompetensiList.length,
                  ),
                  const SizedBox(height: 16),
                  kompetensiList.isEmpty
                      ? Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            "Anda belum memiliki Kompetensi, silakan upload Kompetensi",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(fontSize: 14),
                          ),
                        )
                      : Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: kompetensiList.length <= 2
                              ? Column(
                                  children: kompetensiList
                                      .map((kompetensi) =>
                                          buildKompetensiWithEditDelete(
                                              kompetensi))
                                      .toList(),
                                )
                              : SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.5,
                                  child: Scrollbar(
                                    thumbVisibility: true,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: kompetensiList.length,
                                      itemBuilder: (context, index) {
                                        return buildKompetensiWithEditDelete(
                                            kompetensiList[index]);
                                      },
                                    ),
                                  ),
                                ),
                        ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UploadKompetensi()),
          );
        },
        backgroundColor: Colors.green,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget buildKompetensiWithEditDelete(Kompetensi kompetensi) {
    final double boxWidth = MediaQuery.of(context).size.width * 0.80;

    // Find the "index" or renumbered position based on sorted order
    int kompetensiIndex = kompetensiList.indexOf(kompetensi) + 1;

    return Center(
      child: Container(
        width: boxWidth,
        margin: const EdgeInsets.only(bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 17,
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade700,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minHeight: 110,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.military_tech,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Kompetensi $kompetensiIndex",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                kompetensi.kompetensiNama ??
                                    'Nama Kompetensi Tidak Tersedia',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailKompetensiMahasiswa(
                              kompetensiId: kompetensi.kompetensiId!,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF84F2F9),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          "Detail",
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EditKompetensi(kompetensi: kompetensi),
                        ),
                      ).then((_) =>
                          _loadKompetensi()); // Re-load kompetensi setelah edit
                    },
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 221, 204, 56),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.menu,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      showDeleteConfirmationDialog(context, kompetensi);
                    },
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showDeleteConfirmationDialog(
      BuildContext context, Kompetensi kompetensi) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PopupKompetensiDelete(
          onDeleteConfirmed: () async {
            bool success = await KompetensiService()
                .deleteKompetensi(kompetensi.kompetensiId!);
            if (success) {
              setState(() {
                kompetensiList.remove(kompetensi);
                // Re-sort and re-number the competencies after deletion
                kompetensiList
                    .sort((a, b) => a.kompetensiId!.compareTo(b.kompetensiId!));
              });

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return PopupKompetensiDeletedSuccess();
                },
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Gagal menghapus data Kompetensi')),
              );
            }
          },
        );
      },
    );
  }
}

class CustomKompetensiWidget extends StatelessWidget {
  final String userName;
  final int kompetensiCount;

  const CustomKompetensiWidget(
      {required this.userName, required this.kompetensiCount, super.key});

  @override
  Widget build(BuildContext context) {
    final double boxWidth = MediaQuery.of(context).size.width * 0.85;

    return Center(
      child: Container(
        width: boxWidth,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blue.shade700,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(
              Icons.leaderboard,
              color: Colors.white,
              size: 40,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  const Divider(color: Colors.white),
                  Text(
                    'Kompetensi: $kompetensiCount',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
