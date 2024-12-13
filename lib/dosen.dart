import 'package:firstapp/controller/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/servicedashboardDsn.dart';
import '../Model/dashboardDsnModel.dart';
import 'Dosen/pekerjaan.dart';
import 'Dosen/profile.dart';
import 'bottombar/bottombarDosen.dart';
import 'Dosen/penerimaan_dosen1.dart';

class DosenDashboard extends StatefulWidget {
  const DosenDashboard({super.key});

  @override
  _DosenDashboardState createState() => _DosenDashboardState();
}

class _DosenDashboardState extends State<DosenDashboard> {
  bool _isLoading = true;
  bool _isError = false;
  int _selectedIndex = 0;
  String _nama = 'User';
  String _avatarUrl = '';
  int _jumlahTugasAktif = 0;
  bool _adaPengajuanPekerjaan = false;
  
  List<Pekerjaan> _pekerjaanList = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _fetchDashboardData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nama = prefs.getString('nama') ?? 'User';
      _avatarUrl = prefs.getString('avatarUrl') ?? '';
      
    });
  }

  Future<void> _fetchDashboardData() async {
    try {
      final service = ServiceDashboardDsn();
      final data = await service.fetchDashboard();

      if (data != null) {
        setState(() {
          _jumlahTugasAktif = data.totalPekerjaanOpen;
          _adaPengajuanPekerjaan = data.pendingPekerjaan.isNotEmpty;
          _pekerjaanList = data.pekerjaan;
          _isError = false;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isError = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isError = true;
        _isLoading = false;
      });
      debugPrint('Error fetching dashboard data: $e');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PekerjaanDosenPage()),
      );
      } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PenerimaanDosen1()),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _isError
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Terjadi kesalahan, coba lagi.',
                        style: TextStyle(fontSize: 16, color: Colors.redAccent),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _fetchDashboardData,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 10.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 35,
                              backgroundColor: Colors.grey[300],
                              backgroundImage: _avatarUrl.isNotEmpty
                                  ? NetworkImage(_avatarUrl)
                                  : const AssetImage('assets/img/polinema.png')
                                      as ImageProvider,
                            ),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Selamat Datang,',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                Text(
                                  _nama,
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Informasi Pekerjaan Card
                        Card(
                          elevation: 6,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              gradient: const LinearGradient(
                                colors: [Colors.blue, Colors.lightBlueAccent],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Informasi Pekerjaan',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Jumlah Tugas Aktif: $_jumlahTugasAktif',
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const Divider(color: Colors.white),
                                Text(
                                  _adaPengajuanPekerjaan
                                      ? 'Status: Terdapat Pengajuan'
                                      : 'Status: Tidak Ada Pengajuan',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),
                        Column(
                          children: _pekerjaanList.map((pekerjaan) {
                            return Card(
                              elevation: 3,
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                leading: CircleAvatar(
                                  backgroundColor: Colors.blueAccent,
                                  child: const Icon(Icons.work,
                                      color: Colors.white),
                                ),
                                title: Text(
                                  pekerjaan.pekerjaanNama ??
                                      'Nama Pekerjaan Tidak Diketahui',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'ID Pekerjaan: ${pekerjaan.pekerjaanId ?? 'N/A'}',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    Text(
                                      'Status: ${pekerjaan.status}',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
      bottomNavigationBar: BottomNavBarDosen(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
