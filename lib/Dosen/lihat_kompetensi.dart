import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bottombar/bottombarDosen.dart';
import '../controller/kompetensi_service.dart';
import '../Model/kompetensi_model.dart';
import 'lihat_detail_kompetensi.dart';
import '../dosen.dart';
import 'pekerjaan.dart';
import 'profile.dart';
import 'penerimaan_dosen1.dart';

class LihatKompetensi extends StatefulWidget {
  final String nama;
  final String id;
  final String tugas;

  const LihatKompetensi({
    Key? key,
    required this.nama,
    required this.id,
    required this.tugas,
  }) : super(key: key);

  @override
  _LihatKompetensiState createState() => _LihatKompetensiState();
}

class _LihatKompetensiState extends State<LihatKompetensi> {
  int _selectedIndex = 2;
  List<Kompetensi> kompetensiList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchKompetensi();
  }

  void fetchKompetensi() async {
    try {
      KompetensiService service = KompetensiService();
      List<Kompetensi> data = await service.fetchKompetensi(int.parse(widget.id));
      setState(() {
        kompetensiList = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Tampilkan pesan error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data kompetensi: $e')),
      );
    }
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) {
      return;
    }

    setState(() {
      _selectedIndex = index;
    });

    if (index == 2) {
      return;
    } else if (index == 1) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => PekerjaanDosenPage()));
    } else if (index == 3) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => ProfilePage()));
    } else if (index == 0) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => DosenDashboard()));
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
                MaterialPageRoute(builder: (context) => PenerimaanDosen1()));
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
                    userName: widget.nama,
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
                            'Mahasiswa ini tidak memiliki kompetensi.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                        )
                      : Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: kompetensiList.length,
                            itemBuilder: (context, index) {
                              Kompetensi kompetensi = kompetensiList[index];
                              return buildKompetensiDosen(
                                'Kompetensi ${index + 1}',
                                kompetensi.kompetensiNama ?? 'Nama Kompetensi Tidak Tersedia',
                              );
                            },
                          ),
                        ),
                ],
              ),
      ),
      bottomNavigationBar: BottomNavBarDosen(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget buildKompetensiDosen(String title, String description) {
    final double boxWidth = MediaQuery.of(context).size.width * 0.80;

    return Center(
      child: Container(
        width: boxWidth,
        margin: const EdgeInsets.only(bottom: 10),
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LihatDetailKompetensi(
                          nama: widget.nama,
                          id: widget.id,
                          tugas: widget.tugas,
                        )));
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 17,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade700,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(
                    minHeight: 90, // Ukuran minimal untuk 3 baris
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.military_tech,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              description,
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
              ),
            ],
          ),
        ),
      ),
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
