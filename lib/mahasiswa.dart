import 'package:firstapp/config/config.dart';
import 'package:firstapp/controller/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Mahasiswa/pekerjaan.dart';
import 'Mahasiswa/profile.dart';
import 'Mahasiswa/riwayat.dart';
import 'bottombar/bottombar.dart';
import '../Model/dashboardMhsModel.dart';
import '../controller/serviceDashboardMhs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MahasiswaDashboard extends StatefulWidget {
  const MahasiswaDashboard({super.key});

  @override
  _MahasiswaDashboardState createState() => _MahasiswaDashboardState();
}

class _MahasiswaDashboardState extends State<MahasiswaDashboard> {
  bool _isLoading = true;
  bool _isError = false;
  int _selectedIndex = 0;
  String _nama = 'User';
  String _avatarUrl = '';
  String _prodi = 'Tidak Diketahui';
  String _periode = 'Tidak Diketahui';
  int _totalJamKompen = 0;
  List<Map<String, dynamic>> _details = [];
  String _token = '';

  int _notificationCount = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _fetchDashboardData();
    _fetchNotificationCount();
  }

  Future<void> _fetchNotificationCount() async {
  try {
    final userId = await AuthService().getUserId();
    final token = await AuthService().getToken();
    final response = await http.get(
      Uri.parse('${config.baseUrl}/mahasiswa/$userId/notifikasijumlah'), // Your endpoint for notification count
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Add the token if necessary
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _notificationCount = data['jumlah'];
      });
    } else {
      print('Failed to load notification count');
    }
  } catch (e) {
    print('Error fetching notification count: $e');
  }
}

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nama = prefs.getString('nama') ?? 'User';
      _avatarUrl = prefs.getString('avatarUrl') ?? '';
      _token = prefs.getString('token') ?? '';
    });
  }

  Future<void> _fetchDashboardData() async {
    ServiceDashboardMhs service = ServiceDashboardMhs();
    DashboardMhs? data = await service.fetchDashboard();

    if (data != null) {
      setState(() {
        _prodi = data.user.detailMahasiswa.prodi.prodiNama ?? 'Tidak Diketahui';
        _periode =
            data.user.detailMahasiswa.periode.periodeNama ?? 'Tidak Diketahui';
        _totalJamKompen =
            data.jamKompen.isNotEmpty ? data.jamKompen.first.akumulasiJam : 0;
        _details = data.jamKompen.isNotEmpty
            ? data.jamKompen.first.detailJamKompen.map((item) {
                return {
                  'matkulId': item.matkulId,
                  'detailJamKompenId': item.detailJamKompenId,
                  'matkulNama': item.matkul.matkulNama,
                  'jumlahJam': item.jumlahJam,
                };
              }).toList()
            : [];
        _isLoading = false;
      });
    } else {
      setState(() {
        _isError = true;
        _isLoading = false;
      });
      print("No data received from the server.");
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PekerjaanPage()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const RiwayatPage()),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfilePage()),
      );
    }
  }

// Hanya bagian build yang diperbarui untuk meningkatkan desain
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
                      children: [
                        // Header
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
                        // Program Studi Card
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
                                  'Program Studi',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _prodi,
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const Divider(color: Colors.white),
                                Text(
                                  'Periode: $_periode',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Total Akumulasi Jam Card
                        Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.yellow[600],
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.access_time, size: 28),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    'Total Akumulasi Jam',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Text(
                                  '$_totalJamKompen Jam',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (_totalJamKompen > 0)
                          Card(
                            elevation: 3,
                            color: Colors.red[50],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  Icon(Icons.warning_amber_rounded,
                                      color: Colors.red[800], size: 28),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      'Silahkan selesaikan kompen Anda agar bisa mengikuti UAS.',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Colors.red[800],
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),
                        // Detail Section
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Detail Jam Kompen',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _details.length,
                          itemBuilder: (context, index) {
                            final detail = _details[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 0,
                                vertical: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 3,
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                leading: CircleAvatar(
                                  backgroundColor: Colors.blueAccent,
                                  child: const Icon(Icons.book,
                                      color: Colors.white),
                                ),
                                title: Text(
                                  detail['matkulNama'] ?? 'Tidak Diketahui',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                subtitle: Text(
                                  'Jumlah Jam: ${detail['jumlahJam']} Jam',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
        notificationCount: _notificationCount,
      ),
    );
  }
}
