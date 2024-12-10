import 'dart:async';
import 'package:firstapp/config/config.dart';
import 'package:firstapp/controller/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../bottombar/bottombarKaprodi.dart';
import '../kaprodi.dart';
import 'profile.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PenandatangananKaprodi extends StatefulWidget {
  const PenandatangananKaprodi({super.key});

  @override
  _PenandatangananKaprodiState createState() => _PenandatangananKaprodiState();
}

class _PenandatangananKaprodiState extends State<PenandatangananKaprodi> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      return; // Tetap di halaman Penandatanganan
    } else if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => KaprodiDashboard()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()),
      );
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
        body:
            PenandatangananScreen(), // Menyambungkan ke class PenandatangananScreen
        bottomNavigationBar: BottomNavBarKaprodi(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
      ),
    );
  }
}

class PenandatangananScreen extends StatefulWidget {
  const PenandatangananScreen({super.key});

  @override
  _PenandatangananScreenState createState() => _PenandatangananScreenState();
}

class _PenandatangananScreenState extends State<PenandatangananScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Tombol Tab untuk navigasi
        Container(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTab = 0;
                    });
                    _pageController.jumpToPage(0);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color:
                          _selectedTab == 0 ? Colors.blue : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.assignment,
                            color: _selectedTab == 0
                                ? Colors.white
                                : Colors.black),
                        SizedBox(width: 8),
                        Text(
                          'Tanda Tangan',
                          style: TextStyle(
                            fontSize: 15,
                            color:
                                _selectedTab == 0 ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTab = 1;
                    });
                    _pageController.jumpToPage(1);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color:
                          _selectedTab == 1 ? Colors.blue : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.done,
                            color: _selectedTab == 1
                                ? Colors.white
                                : Colors.black),
                        SizedBox(width: 8),
                        Text(
                          'Selesai',
                          style: TextStyle(
                            fontSize: 15,
                            color:
                                _selectedTab == 1 ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          // Konten berdasarkan PageView untuk Tanda Tangan dan Selesai
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _selectedTab = index;
              });
            },
            children: [
              _buildTandaTanganList(context),
              _buildSelesaiList(context),
            ],
          ),
        ),
      ],
    );
  }

  Future<List<dynamic>> _fetchTandaTanganData() async {
  try {
    final token = await AuthService().getToken();
    final response = await http.get(
      Uri.parse('${config.baseUrl}/kaprodi'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    print('Response status code: ${response.statusCode}');  // Log status code
    print('Response body: ${response.body}');  // Log response body

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['success'] == true) {
        return data['data']; // Return the data
      } else {
        throw Exception('Failed to load data');
      }
    } else {
      throw Exception('Failed to load data');
    }
  } catch (e) {
    print('Error: $e');  // Log the error message
    throw Exception('Error: $e');
  }
}


  // Fungsi untuk membuat daftar Tanda Tangan
  Widget _buildTandaTanganList(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _fetchTandaTanganData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Tidak ada data penerimaan.'));
        } else {
          var tandaTanganList = snapshot.data!;

          return ListView.builder(
            itemCount: tandaTanganList.length,
            itemBuilder: (context, index) {
              var tandaTangan = tandaTanganList[index];
              return _buildTandaTanganCard(
                context,
                tandaTangan['user']['nama'], // Replace with correct key path
                tandaTangan['user']
                    ['username'], // Replace with correct key path
                tandaTangan['created_at'], // Replace with correct key path
                tandaTangan['pekerjaan']
                    ['pekerjaan_nama'], // Replace with correct key path
                tandaTangan['pekerjaan_id'].toString(),
                tandaTangan['user']['user_id'].toString(),
              );
            },
          );
        }
      },
    );
  }

  Future<void> approveTandaTangan(String pekerjaanId, String userId) async {
    try {
      final token = await AuthService().getToken();
      final userIdKap = await AuthService().getUserId();
      
      final response = await http.post(
        Uri.parse('${config.baseUrl}/kaprodi/approvesurat'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'user_id': userId,
            'pekerjaan_id': pekerjaanId,
            'user_id_kap': userIdKap
        }),
      );

      if (response.statusCode == 200) {
        // If successful, show a confirmation message
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Berhasil Menyetujui'),backgroundColor: Colors.green,));
      } else {

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Approval failed: ${response.body}'),backgroundColor: Colors.red,));
      }
    } catch (e) {
      // Handle any errors during the API call
      print('Error: $e'); // Debug log
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('An error occurred: $e'),backgroundColor: Colors.red,));
    }
  }

  Widget _buildTandaTanganCard(BuildContext context, String nama, String id,
      String tanggal, String tugas, String pekerjaanId, String userId) {
    DateTime? deadline;
    deadline = DateTime.parse(tanggal);
    String formatdeadline = '';
    formatdeadline = DateFormat('dd MMM yyyy HH:mm').format(deadline);
    return Align(
      alignment: Alignment.topCenter,
      child: FractionallySizedBox(
        widthFactor: 0.9,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            nama,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            formatdeadline,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
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
                        size: 45,
                      ),
                      onPressed: () {
                        approveTandaTangan(pekerjaanId, userId);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Fungsi untuk membuat daftar yang sudah Selesai
  Widget _buildSelesaiList(BuildContext context) {
    return ListView(
      children: [
        _buildSelesai(
            context, 'Solikhin', '2241760020', '2024-12-12', 'Membuat Web'),
      ],
    );
  }

  Widget _buildSelesai(BuildContext context, String nama, String id,
      String tanggal, String tugas) {
    return Align(
      alignment: Alignment.topCenter,
      child: FractionallySizedBox(
        widthFactor: 0.9,
        child: InkWell(
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              nama,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              tanggal,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              id,
                              style: GoogleFonts.poppins(fontSize: 14),
                            ),
                            Text(
                              tugas,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
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
}
