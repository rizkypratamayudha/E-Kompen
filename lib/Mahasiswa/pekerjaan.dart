import 'dart:convert';
import 'package:firstapp/config/config.dart';
import 'package:firstapp/controller/Pekerjaan.dart';

import 'package:firstapp/controller/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bottombar/bottombar.dart';
import 'profile.dart';
import 'riwayat.dart';
import '../mahasiswa.dart';
import '../widget/popup_pekerjaan_mhs.dart';
import '../widget/tag.dart';
import '../widget/tag_kompetensi.dart';
import 'package:http/http.dart' as http;

class PekerjaanPage extends StatefulWidget {
  const PekerjaanPage({super.key});

  @override
  _PekerjaanPageState createState() => _PekerjaanPageState();
}

class _PekerjaanPageState extends State<PekerjaanPage> {
  int _selectedIndex = 1;
  bool _isLoading = true;
  List<Pekerjaan> pekerjaanList = [];

  Future<int> fetchAnggotaSekarang(int pekerjaanId) async {
  try {
    final token = await AuthService().getToken();
    final response = await http.get(
      Uri.parse('${config.baseUrl}/pekerjaan/$pekerjaanId/get-anggota'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['anggotaJumlah'] ?? 0;
    } else {
      throw Exception('Failed to fetch anggota sekarang for pekerjaan_id $pekerjaanId');
    }
  } catch (e) {
    print('Error fetching anggota sekarang: $e');
    return 0; // Default nilai jika terjadi error
  }
}


  Future<void> _fetchPekerjaan() async {
  setState(() {
    _isLoading = true;
  });

  try {
    final token = await AuthService().getToken();
    final response = await http.get(
      Uri.parse('${config.baseUrl}/pekerjaan'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<Pekerjaan> pekerjaanTempList = data.map((json) {
        return Pekerjaan.fromJson(json);
      }).toList();

      // Fetch anggota sekarang untuk setiap pekerjaan
      for (var pekerjaan in pekerjaanTempList) {
        pekerjaan.anggotasekarang =
            await fetchAnggotaSekarang(pekerjaan.pekerjaan_id);
      }

      setState(() {
        pekerjaanList = pekerjaanTempList;
        _isLoading = false;
      });
    } else {
      print('Response body: ${response.body}');
      throw Exception('Failed to load pekerjaan');
    }
  } catch (e) {
    print("Error: $e");
    setState(() {
      pekerjaanList = [];
      _isLoading = false;
    });
  }
}


  @override
  void initState() {
    super.initState();
    _fetchPekerjaan();
  }

  Route _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) {
      return;
    }

    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      return;
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => RiwayatPage()),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 50.0, 20.0, 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pekerjaan',
                style: GoogleFonts.poppins(
                    fontSize: 22, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 20),
              _buildSearch(),
              const SizedBox(height: 20),
              // Kondisi untuk menampilkan loading, data pekerjaan, atau pesan kosong
              if (_isLoading)
                Center(child: CircularProgressIndicator())
              else if (pekerjaanList.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: pekerjaanList.length,
                  itemBuilder: (context, index) {
                    Pekerjaan pekerjaan = pekerjaanList[index];
                    int jumlahAnggota =
                        pekerjaan.detail_pekerjaan.jumlah_anggota;
                    return _buildPekerjaan(
                        pekerjaan.pekerjaan_nama, jumlahAnggota, pekerjaan, pekerjaan.anggotasekarang);
                  },
                )
              else
                Center(child: Text('Tidak ada data pekerjaan')),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      backgroundColor: Colors.white,
    );
  }

  Widget _buildPekerjaan(String title, int anggota, Pekerjaan pekerjaan, int anggotasekarang) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 6.0),
    decoration: BoxDecoration(
      color: Colors.blue,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 5,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.w300,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.person,
            color: Colors.white,
          ),
          const SizedBox(width: 5),
          Text(
            '$anggotasekarang/$anggota',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ],
      ),
      onTap: () {
        if (anggotasekarang >= anggota) {
          // Tampilkan pesan jika kapasitas penuh
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Pekerjaan ini sudah penuh. Tidak bisa melakukan apply.',
                style: GoogleFonts.poppins(),
              ),
              backgroundColor: Colors.red,
            ),
          );
        } else {
          // Tampilkan dialog apply jika kapasitas belum penuh
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return PopUpPekerjaan(pekerjaan: pekerjaan);
            },
          );
        }
      },
    ),
  );
}


  void _showlist() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      builder: (context) {
        return Container(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width,
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Jenis Tugas',
                style: GoogleFonts.poppins(),
              ),
              const SizedBox(height: 16),
              Tag(),
              const SizedBox(height: 16),
              Text(
                'List Kompetensi',
                style: GoogleFonts.poppins(),
              ),
              const SizedBox(height: 16),
              TagKompetensi(),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigasi atau aksi lainnya
                  },
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
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Cari Pekerjaan',
              hintStyle: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.black38,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.transparent,
            ),
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.black,
            ),
            onChanged: (value) {
              print('Judul pekerjaan: $value');
            },
          ),
        ),
        SizedBox(width: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(3),
          child: IconButton(
            onPressed: () => _showlist(),
            icon: const Icon(
              Icons.filter_list_rounded,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
