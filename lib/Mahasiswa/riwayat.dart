import 'package:firstapp/config/config.dart';
import 'package:firstapp/controller/auth_service.dart';
import 'package:firstapp/controller/pengerjaan.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../bottombar/bottombar.dart'; // Import BottomNavBar
import 'profile.dart';
import 'pekerjaan.dart';
import '../mahasiswa.dart';
import 'progress_mahasiswa.dart';
import 'cetak_surat.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({super.key});

  @override
  _RiwayatPageState createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  int _selectedIndex = 2; // Sesuaikan dengan tab yang sedang aktif

  List<Pekerjaan> prosesItems = [];
  List<Pekerjaan> selesaiItems = [];
  List<Pekerjaan> ttdKaprodiItems = [];

  Future<void> _fetchData() async {
    try {
      final authService = AuthService();
      final userId =
          await authService.getUserId(); // Ambil userId dari AuthService

      if (userId != null) {
        // Ganti URL dengan endpoint API Anda
        final token = await AuthService().getToken();
        final response = await http.get(
            Uri.parse(
                '${config.baseUrl}/pekerjaan/$userId/getPekerjaanPengerjaan'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            });

        if (response.statusCode == 200) {
          final decodedData = json.decode(response.body);
          final data = decodedData['data'] as List;

          setState(() {
            // Map data ke model Pekerjaan
            final pekerjaanList =
                data.map((e) => Pekerjaan.fromJson(e)).toList();

            // Pisahkan data berdasarkan kategori
            prosesItems = pekerjaanList.where((pekerjaan) {
              // Cek apakah ada setidaknya satu progres yang statusnya bukan "pending"
              return pekerjaan.progres
                  .any((progres) => progres.pengumpulan.isEmpty);
            }).toList();
            selesaiItems = pekerjaanList.where((pekerjaan) {
              return pekerjaan.progres
                  .every((progres) => progres.pengumpulan.isNotEmpty);
            }).toList();

            ttdKaprodiItems =
                pekerjaanList.where((e) => e.status == 'ttd_kaprodi').toList();
          });
        } else {
          print("Failed to fetch data: ${response.statusCode}");
        }
      } else {
        print("User ID is null. Redirecting to login.");
        // Arahkan ke halaman login jika userId tidak tersedia
      }
    } catch (error) {
      // Tangani error (misalnya tampilkan dialog)
      print("Error fetching data: $error");
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData(); // Panggil fungsi fetch data saat halaman pertama kali dimuat
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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PekerjaanPage()),
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
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Menyembunyikan banner "Debug"
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white, // Warna putih untuk background app bar
          title: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 60.0, 20.0, 40.0),
            child: Text(
              'Riwayat',
              style: GoogleFonts.poppins(fontSize: 22),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: RiwayatScreen(
          prosesItems: prosesItems,
          selesaiItems: selesaiItems,
          ttdKaprodiItems: ttdKaprodiItems,
        ),
        bottomNavigationBar: BottomNavBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
      ),
    );
  }
}

class RiwayatScreen extends StatefulWidget {
  List<Pekerjaan> prosesItems = [];
  List<Pekerjaan> selesaiItems = [];
  List<Pekerjaan> ttdKaprodiItems = [];

  RiwayatScreen({
    Key? key,
    required this.prosesItems,
    required this.selesaiItems,
    required this.ttdKaprodiItems,
  }) : super(key: key);

  @override
  _RiwayatScreenState createState() => _RiwayatScreenState();
}

class _RiwayatScreenState extends State<RiwayatScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TabButton(
                  icon: Icons.access_time, // Ikon jam untuk 'Proses'
                  text: "Proses",
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
                  icon: Icons
                      .check_circle_outline, // Ikon ceklis untuk 'Telah Selesai'
                  text: "Telah Selesai",
                  isSelected: _selectedIndex == 1,
                  onTap: () {
                    setState(() {
                      _selectedIndex = 1;
                    });
                    _pageController.animateToPage(1,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut);
                  },
                ),
              ),
              Expanded(
                child: TabButton(
                  icon: Icons.edit, // Ikon tanda tangan untuk 'TTD Kaprodi'
                  text: "TTD Kaprodi",
                  isSelected: _selectedIndex == 2,
                  onTap: () {
                    setState(() {
                      _selectedIndex = 2;
                    });
                    _pageController.animateToPage(2,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut);
                  },
                ),
              ),
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
                _buildRiwayatList(context, widget.prosesItems),
                _buildRiwayatList(context, widget.selesaiItems),
                _buildRiwayatList(context, widget.ttdKaprodiItems),
              ],
            ),
          ),
        ],
      ),
    );
  }

// Fungsi untuk membangun daftar riwayat untuk tiap kategori
  Widget _buildRiwayatList(BuildContext context, List<Pekerjaan> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final pekerjaan = items[index];

        if (pekerjaan == null) {
        return Container();  // Return an empty container or an error message if pekerjaan is null
      }

        // Mengecek apakah item ini berasal dari selesaiItems
        return GestureDetector(
          onTap: () {
            // Menambahkan kondisi untuk memanggil popup hanya jika pekerjaan berasal dari selesaiItems
            if (items == widget.selesaiItems) {
              // Memanggil fungsi showWebPopup jika pekerjaan ada di selesaiItems
              _showWebPopup(context, pekerjaan);
            } else {
              // Aksi ketika item lainnya ditekan
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProgressMahasiswaPage(
                    pekerjaan: pekerjaan,
                  ),
                ),
              );
            }
          },
          child: _buildRiwayat(context, pekerjaan),
        );
      },
    );
  }

  // Fungsi untuk membangun satu item riwayat
  // Fungsi untuk membangun satu item riwayat
  Widget _buildRiwayat(BuildContext context, Pekerjaan pekerjaan) {
    DateTime? deadline;
    deadline = DateTime.parse(pekerjaan.akumulasiDeadline.toString());
    String formatDeadline = '';

    formatDeadline = DateFormat('dd MMM yyyy HH:mm').format(deadline);
    return Align(
      alignment: Alignment.topCenter,
      child: FractionallySizedBox(
        widthFactor: 0.9,
        child: Card(
          color: Colors.blue,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: ListTile(
                title: Text(
                  pekerjaan.pekerjaanNama ?? 'Nama Pekerjaan tidak tersedia',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (pekerjaan.akumulasiDeadline != null)
                      Text(
                        'Akumulasi Deadline: ${formatDeadline ?? 'Tidak tersedia'}',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                  ],
                ),
                onTap: () {
                  if (widget.selesaiItems.contains(pekerjaan)) {
                    // Navigasi ke ProgressMahasiswaPage jika berasal dari selesaiItems
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProgressMahasiswaPage(
                          pekerjaan: pekerjaan,
                        ),
                      ),
                    );
                  } else if (widget.prosesItems.contains(pekerjaan)) {
                    // Navigasi ke ProgressMahasiswaPage jika berasal dari prosesItems
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProgressMahasiswaPage(
                          pekerjaan: pekerjaan,
                        ),
                      ),
                    );
                  }
                },
                onLongPress: () {
                  if (widget.selesaiItems.contains(pekerjaan)) {
                    // Cek apakah semua status di progres.pengumpulan tidak 'pending'
                    final allStatusNonPending =
                        pekerjaan.progres.every((progres) {
                      return progres.pengumpulan.isNotEmpty &&
                          progres.pengumpulan.every(
                              (pengumpulan) => pengumpulan.status != 'pending');
                    });

                    // Tampilkan popup jika semua status tidak 'pending'
                    if (allStatusNonPending) {
                      _showWebPopup(context, pekerjaan);
                    } else {
                      // Tambahkan aksi lain jika ada, misalnya menampilkan pesan
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                          "Beberapa status masih pending.",
                        )),
                      );
                    }
                  }
                }),
          ),
        ),
      ),
    );
  }

  // Fungsi untuk menampilkan popup dialog
  void _showWebPopup(BuildContext context, Pekerjaan pekerjaan) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nama Dosen : ${pekerjaan.user?.nama ?? 'Nama tidak tersedia'}',
                    style: GoogleFonts.poppins(fontSize: 14)),
                SizedBox(height: 8),
                Text('Nomor Dosen: ${pekerjaan.user?.detailDosen?.noHp ?? '-'}',
                    style: GoogleFonts.poppins(fontSize: 14)),
                SizedBox(height: 8),
                Text('Jenis Tugas : ${pekerjaan.jenisPekerjaan}',
                    style: GoogleFonts.poppins(fontSize: 14)),
                SizedBox(height: 8),
                Text('Nama Tugas : ${pekerjaan.pekerjaanNama}',
                    style: GoogleFonts.poppins(fontSize: 14)),
                SizedBox(height: 8),
                Text('Jumlah Jam : ${pekerjaan.jumlahJamKompen}',
                    style: GoogleFonts.poppins(fontSize: 14)),
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(8),
                  color: Colors.grey[200],
                  child: Text(
                    'Deskripsi Pekerjaan :\n\n${pekerjaan.detailpekerjaan.deskripsiTugas}',
                    style: GoogleFonts.poppins(fontSize: 12),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Tutup dialog
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text('Request TTD Kaprodi',
                        style: GoogleFonts.poppins(
                            fontSize: 14, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class TabButton extends StatelessWidget {
  final IconData icon; // Tambahkan parameter ikon
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const TabButton({
    super.key,
    required this.icon, // Parameter ikon harus disertakan
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
            color: isSelected ? Colors.blue : Colors.transparent,
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(10)),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Colors.white
                  : Colors.black, // Ubah warna ikon sesuai kondisi isSelected
            ),
            SizedBox(width: 6), // Jarak antara ikon dan teks
            Text(
              text,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
