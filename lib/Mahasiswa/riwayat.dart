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
                _buildSelesaiListsurat(context)
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
          return Container(); // Return an empty container or an error message if pekerjaan is null
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
  deadline = pekerjaan.akumulasiDeadline != null
      ? DateTime.parse(pekerjaan.akumulasiDeadline.toString())
      : null;
  String? formatDeadline;

  if (deadline != null) {
    formatDeadline = DateFormat('dd MMM yyyy HH:mm').format(deadline);
  }

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
                if (formatDeadline != null)
                  Text(
                    'Akumulasi Deadline: $formatDeadline',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                if (formatDeadline == null)
                  Text(
                    'Akumulasi Deadline: Tidak tersedia',
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
            },
          ),
        ),
      ),
    ),
  );
}

  Future<void> selesai(String pekerjaanId, String userId) async {
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Berhasil Menyetujui'),
          backgroundColor: Colors.green,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Approval failed: ${response.body}'),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      // Handle any errors during the API call
      print('Error: $e'); // Debug log
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('An error occurred: $e'),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<List<dynamic>> fetchDataSelesai() async {
    final token = await AuthService().getToken();
    final userId = await AuthService().getUserId();
    try {
      final response = await http
          .get(Uri.parse('${config.baseUrl}/kaprodi/$userId/mhs'), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['success'] == true) {
          return jsonData['data'];
        } else {
          throw Exception(jsonData['message']);
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<dynamic>> fetchDataSelesaisurat() async {
    final token = await AuthService().getToken();
    final userId = await AuthService().getUserId();
    try {
      final response = await http.get(
          Uri.parse('${config.baseUrl}/kaprodi/$userId/mhssurat'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          });

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['success'] == true) {
          return jsonData['data'];
        } else {
          throw Exception(jsonData['message']);
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Widget _buildSelesaiList(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: fetchDataSelesai(),
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
              return _buildSelesai(
                context,
                tandaTangan['user']['nama'], // Replace with correct key path
                tandaTangan['user']
                    ['username'], // Replace with correct key path
                tandaTangan['created_at'], // Replace with correct key path
                tandaTangan['pekerjaan']['pekerjaan_nama'],
              );
            },
          );
        }
      },
    );
  }

  Widget _buildSelesaiListsurat(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: fetchDataSelesaisurat(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Tidak ada Surat yang disetujui.'));
        } else {
          var tandaTanganList = snapshot.data!;

          return ListView.builder(
            itemCount: tandaTanganList.length,
            itemBuilder: (context, index) {
              var tandaTangan = tandaTanganList[index];
              return _buildSelesaisurat(
                context,
                tandaTangan['kaprodi']['nama'], // Replace with correct key path
                tandaTangan['user']
                    ['username'], // Replace with correct key path
                tandaTangan['created_at'], // Replace with correct key path
                tandaTangan['pekerjaan']['pekerjaan_nama'],
                  tandaTangan['user']['nama'],
                  tandaTangan['user']['detail_mahasiswa']['prodi']['prodi_nama'],
                  tandaTangan['user']['detail_mahasiswa']['angkatan'],
                  tandaTangan['user']['detail_mahasiswa']['periode']['periode_nama'],
                  tandaTangan['pekerjaan']['user']['nama'],
                  tandaTangan['pekerjaan']['jumlah_jam_kompen'],
                  tandaTangan['pekerjaan']['user']['username'],
                  tandaTangan['kaprodi']['username'],
                  tandaTangan['t_approve_cetak_id']
              );
            },
          );
        }
      },
    );
  }

  Widget _buildSelesai(BuildContext context, String nama, String id,
      String tanggal, String tugas) {
    DateTime? deadline;
    deadline = DateTime.parse(tanggal);
    String formatdeadline = '';
    formatdeadline = DateFormat('dd MMM yyyy HH:mm').format(deadline);
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
                              'Kaprodi: $nama',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
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
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Status: Pengajuan',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ),
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

  Widget _buildSelesaisurat(BuildContext context, String nama, String id,
      String tanggal, String tugas, String namauser, String prodi, String angkatan, String periode, String namadosen, int jamkompen, String iddosen, String idkap, int id_cetak) {
    DateTime? deadline;
    deadline = DateTime.parse(tanggal);
    String formatdeadline = '';
    formatdeadline = DateFormat('dd MMM yyyy HH:mm').format(deadline);
    return Align(
      alignment: Alignment.topCenter,
      child: FractionallySizedBox(
        widthFactor: 0.9,
        child: InkWell(
          onTap: () async {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(
                    'Pekerjaan: $tugas',
                    style: TextStyle(fontSize: 14),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment
                        .start, // Menambahkan ini untuk memastikan teks di kiri
                    children: [
                      Text('Nama: $nama', style: GoogleFonts.poppins()),
                      Text('NIM: $id', style: GoogleFonts.poppins()),
                      Text('Disetujui pada: $formatdeadline',
                          style: GoogleFonts.poppins()),
                    ],
                  ),
                  actions: [
                    OutlinedButton(
                      onPressed: () {
                        Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CetakSuratPage(
                          nama: nama,
                          id: id,
                          formattanggal: formatdeadline,
                          tugas: tugas,
                          namauser: namauser,
                          prodi: prodi,
                          angkatan: angkatan.toString(),
                          periode: periode,
                          namadosen: namadosen,
                          jamkompen: jamkompen.toString(),
                          iddosen: iddosen,
                          idkap: idkap,
                          id_cetak: id_cetak,
                        ))
                        );
                    
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                            color: Colors
                                .blue), // Menambahkan border berwarna biru
                        backgroundColor:
                            Colors.white, // Warna latar belakang tombol
                        padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10), // Menambahkan padding
                      ),
                      child: Text(
                        'Cetak Surat',
                        style:
                            TextStyle(color: Colors.blue), // Warna teks tombol
                      ),
                    ),
                  ],
                );
              },
            );
          },
          child: Card(
            color: Colors.green,
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
                              'Kaprodi: $nama',
                              style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),
                            ),
                            Text(
                              formatdeadline,
                              style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              id,
                              style: GoogleFonts.poppins(
                                  fontSize: 14, color: Colors.white),
                            ),
                            Text(
                              tugas,
                              style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Status: Telah di TTD',
                          style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                              color: Colors.white),
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

  // Fungsi untuk menampilkan popup dialog
  void _showWebPopup(BuildContext context, Pekerjaan pekerjaan) {
    Future<void> _requestTTDKaprodi(int pekerjaanId) async {
      try {
        final userId = await AuthService().getUserId();
        final token = await AuthService().getToken();
        final response = await http.post(
            Uri.parse(
                '${config.baseUrl}/mahasiswa/$pekerjaanId/request-cetak-surat'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization':
                  'Bearer $token', // Ganti dengan token autentikasi Anda
            },
            body: jsonEncode({
              'user_id': userId,
              'pekerjaan_id': pekerjaanId,
            }));

        if (response.statusCode == 201) {
          // Permintaan berhasil
          final data = json.decode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(data['message'] ?? 'Permintaan berhasil!'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          // Permintaan gagal
          final data = json.decode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(data['message'] ??
                  'Terjadi kesalahan saat mengajukan permintaan.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        // Error jaringan atau server
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi kesalahan: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

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
                Text(
                    'Nama Dosen : ${pekerjaan.user?.nama ?? 'Nama tidak tersedia'}',
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
                    onPressed: () async {
                      Navigator.pop(context); // Tutup dialog
                      await _requestTTDKaprodi(
                          pekerjaan.pekerjaanId); // Kirim permintaan API
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
