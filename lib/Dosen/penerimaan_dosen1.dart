import 'dart:async';
import 'dart:convert';
import 'package:firstapp/Mahasiswa/riwayat.dart';
import 'package:firstapp/config/config.dart';
import 'package:firstapp/controller/getPelamaran.dart';
import 'package:firstapp/controller/pending_pekerjaan.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bottombar/bottombarDosen.dart';
import 'profile.dart';
import 'pekerjaan.dart';
import '../dosen.dart';
import '../widget/popup_tugas_selesai_dosen.dart';
import 'progress_dosen.dart';
import 'lihat_Kompetensi.dart';
import 'package:http/http.dart' as http;

class PenerimaanDosen1 extends StatefulWidget {
  const PenerimaanDosen1({super.key});

  @override
  _PenerimaanDosen1State createState() => _PenerimaanDosen1State();
}

class _PenerimaanDosen1State extends State<PenerimaanDosen1> {
  final PelamaranService pelamaranService = PelamaranService();
  int _selectedIndex = 2;

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(
        Theme.of(context).textTheme,
      )),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Padding(
            padding: EdgeInsets.fromLTRB(20.0, 60.0, 20.0, 40.0),
            child: Text('Penerimaan', style: GoogleFonts.poppins(fontSize: 22)),
          ),
        ),
        backgroundColor: Colors.white,
        body: PenerimaanScreen(),
        bottomNavigationBar: BottomNavBarDosen(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
      ),
    );
  }
}

class PenerimaanScreen extends StatefulWidget {
  const PenerimaanScreen({super.key});

  @override
  _PenerimaanScreenState createState() => _PenerimaanScreenState();
}

class _PenerimaanScreenState extends State<PenerimaanScreen> {
  final PelamaranService pelamaranService = PelamaranService();
  Future<List<PendingPekerjaan>> fetchPelamaran() async {
    final response = await pelamaranService.getPelamaran();
    if (response['success']) {
      return (response['data'] as List)
          .map((item) => PendingPekerjaan.fromJson(item))
          .toList();
    } else {
      throw Exception('Gagal memuat pelamaran: ${response['message']}');
    }
  }

  Future<void> approvePekerjaan(int pekerjaanId, int userId) async {
    try {
      final client = http.Client();
      final response = await client.post(
        Uri.parse('${config.baseUrl}/pekerjaan/approve-pekerjaan'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'pekerjaan_id': pekerjaanId,
          'user_id': userId,
        }),
      );

      if (response.statusCode == 200) {
        print('Pekerjaan approved');
        _showSuccessDialog();
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  Future<void> declinePekerjaan(int pekerjaanId, int userId) async {
    try {
      final client = http.Client();
      final response = await client.post(
        Uri.parse('${config.baseUrl}/pekerjaan/decline-pekerjaan'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'pekerjaan_id': pekerjaanId,
          'user_id': userId,
        }),
      );

      if (response.statusCode == 200) {
        print('Pekerjaan approved');
        _showdeclineDialog();
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Berhasil', style: GoogleFonts.poppins()),
          content: Text('Pelamaran Disetujui',
              style: GoogleFonts.poppins()),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.push(context,
                MaterialPageRoute(builder: (context) => PenerimaanDosen1())
                );
              },
              child: Text('OK', style: GoogleFonts.poppins()),
            ),
          ],
        );
      },
    );
  }

  void _showdeclineDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Berhasil', style: GoogleFonts.poppins()),
          content: Text('Pelamar Ditolak',
              style: GoogleFonts.poppins()),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.push(context,
                MaterialPageRoute(builder: (context) => PenerimaanDosen1())
                );
              },
              child: Text('OK', style: GoogleFonts.poppins()),
            ),
          ],
        );
      },
    );
  }


  final PageController _pageController = PageController(initialPage: 0);
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 20),
        child: Column(children: [
          Row(
            children: [
              Expanded(
                child: TabButton(
                  icon: Icons.assignment,
                  text: 'Pelamaran',
                  isSelected: _selectedIndex == 0,
                  onTap: () {
                    setState(() {
                      _selectedIndex = 0;
                    });
                    _pageController.animateToPage(0,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut);
                  },
                ),
              ),
              Expanded(
                child: TabButton(
                  icon: Icons.work,
                  text: 'Pengerjaan',
                  isSelected: _selectedIndex == 1,
                  onTap: () {
                    setState(() {
                      _selectedIndex = 0;
                    });
                    _pageController.animateToPage(1,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut);
                  },
                ),
              ),
              Expanded(
                child: TabButton(
                  icon: Icons.done,
                  text: 'Selesai',
                  isSelected: _selectedIndex == 2,
                  onTap: () {
                    setState(() {
                      _selectedIndex = 0;
                    });
                    _pageController.animateToPage(2,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut);
                  },
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              children: [
                _buildPenerimaanList(context),
                _buildProsesList(context),
                _buildSelesaiList(context),
              ],
            ),
          )
        ]));
  }

  Widget _buildCard(BuildContext context, String nama, String id, String tugas,
      int pekerjaanId, int userId) {
    return Align(
      alignment: Alignment.topCenter,
      child: FractionallySizedBox(
        widthFactor: 0.9,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LihatKompetensi(
                  nama: nama,
                  id: id,
                  tugas: tugas,
                ),
              ),
            );
          },
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nama,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          id,
                          style: GoogleFonts.poppins(fontSize: 14),
                        ),
                        SizedBox(height: 10),
                        Text(
                          tugas,
                          style: GoogleFonts.poppins(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 50,
                        ),
                        onPressed: () async {
                          await approvePekerjaan(pekerjaanId, userId);
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.cancel,
                          color: Colors.red,
                          size: 50,
                        ),
                        onPressed: () async{
                            await declinePekerjaan(pekerjaanId, userId);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildCardProses(BuildContext context, String nama, String id,
      String tanggal, String tugas) {
    return Align(
      alignment: Alignment.topCenter,
      child: FractionallySizedBox(
        widthFactor: 0.9,
        child: InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProgressDosenPage()));
          },
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment.center, // Vertically center the content
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nama,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          id,
                          style: GoogleFonts.poppins(fontSize: 14),
                        ),
                        Text(
                          tanggal,
                          style: GoogleFonts.poppins(
                              fontSize: 14, fontWeight: FontWeight.w300),
                        ),
                        SizedBox(height: 10),
                        Text(
                          tugas,
                          style: GoogleFonts.poppins(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 50,
                        ),
                        onPressed: () {
                          // Action when check is clicked
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.cancel,
                          color: Colors.red,
                          size: 50,
                        ),
                        onPressed: () {
                          // Action when cancel is clicked
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelesai(BuildContext context, String nama, String id,
      String tanggal, String tugas) {
    return Align(
      alignment: Alignment.topCenter,
      child: FractionallySizedBox(
        widthFactor: 0.9,
        child: InkWell(
          // onTap: () {
          //   showDialog(
          //     context: context,
          //     builder: (BuildContext context) {
          //       return const PopupTugasSelesaiDosen();
          //     },
          //   );
          // },
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment.center, // Vertically center the content
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nama,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          id,
                          style: GoogleFonts.poppins(fontSize: 14),
                        ),
                        Text(
                          tanggal,
                          style: GoogleFonts.poppins(
                              fontSize: 14, fontWeight: FontWeight.w300),
                        ),
                        SizedBox(height: 10),
                        Text(
                          tugas,
                          style: GoogleFonts.poppins(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPenerimaanList(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: PelamaranService().getPelamaran(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data?['success'] == false) {
          return Center(child: Text('Tidak ada data pelamaran.'));
        } else {
          var pelamaranList = snapshot.data?['data'] ?? [];

          return ListView.builder(
            itemCount: pelamaranList.length,
            itemBuilder: (context, index) {
              var pelamaran = pelamaranList[index] as PendingPekerjaan;
              return _buildCard(
                context,
                pelamaran.user.nama,
                pelamaran.user.username,
                pelamaran.pekerjaan.pekerjaanNama,
                pelamaran.pekerjaanId,
                pelamaran.user.userId,
              );
            },
          );
        }
      },
    );
  }


  Widget _buildProsesList(BuildContext context) {
    return ListView(
      children: [
        _buildCardProses(
            context, 'Solikhin', '2241760020', '\n\n1/4', 'Memasukkan Nilai'),
        _buildCardProses(context, 'M Rizky Yudha', '2241760020',
            '\n\nBelum Selesai', 'Membuat Web')
      ],
    );
  }

  Widget _buildSelesaiList(BuildContext context) {
    return ListView(
      children: [
        _buildSelesai(
            context, 'Solikhin', '2241760020', '\n\n2024-12-12', 'Membuat Web')
      ],
    );
  }
}
class TabButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isSelected;
  final Function onTap;

  const TabButton({
    super.key,
    required this.icon,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          border: isSelected
              ? Border(bottom: BorderSide(color: Colors.blue, width: 3))
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.blue : Colors.grey,
              size: 20,
            ),
            SizedBox(width: 8), // Spasi antara ikon dan teks
            Text(
              text,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.blue : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

