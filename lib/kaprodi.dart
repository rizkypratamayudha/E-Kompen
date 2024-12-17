import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/servicedashboardKap.dart';
import 'package:firstapp/Model/dashboardKapModel.dart';
import 'bottombar/bottombarKaprodi.dart';
import 'Kaprodi/profile.dart';
import 'Kaprodi/penandatanganan_kaprodi.dart';

class KaprodiDashboard extends StatefulWidget {
  const KaprodiDashboard({super.key});

  @override
  _KaprodiDashboardState createState() => _KaprodiDashboardState();
}

class _KaprodiDashboardState extends State<KaprodiDashboard> {
  int _selectedIndex = 0;
  String _nama = 'User';
  String _avatarUrl = '';
  DashboardKap? _dashboardData;
  bool _isLoading = true;
  bool _isError = false;
  String _token = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _fetchDashboardData();
  }

  // Load user data from SharedPreferences
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nama = prefs.getString('nama') ?? 'User';
      _avatarUrl = prefs.getString('avatarUrl') ?? '';
      _token = prefs.getString('token') ?? '';
    });
  }

  // Fetch dashboard data from the API
  Future<void> _fetchDashboardData() async {
    try {
      final dashboardData = await ServiceDashboardKap().fetchDashboard();
      setState(() {
        _dashboardData = dashboardData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isError = true;
      });
      print('Error fetching dashboard data: $e');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      return;
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PenandatangananKaprodi(),
        ),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ProfilePage(),
        ),
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
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Task Summary Section
                        Container(
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Jumlah Penandatanganan: ${_dashboardData?.approveCount ?? 0}',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 5, bottom: 5),
                                child: Divider(
                                  color: Colors.white,
                                  thickness: 2,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                _dashboardData?.pendingCount == 0
                                    ? 'Tidak terdapat Pengajuan Penandatanganan'
                                    : 'Status: ${_dashboardData?.pendingCount ?? 0} membutuhkan tanda tangan',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Card Section
                        Column(
                          children: [
                            _buildCard(
                              title: 'Butuh tanda tangan',
                              count: '${_dashboardData?.pendingCount ?? 0}',
                              icon: Icons.pending_actions,
                              color: Colors.orange,
                            ),
                            const SizedBox(height: 10),
                            _buildCard(
                              title: 'Tanda tangan selesai',
                              count: '${_dashboardData?.approveCount ?? 0}',
                              icon: Icons.check_circle,
                              color: Colors.green,
                            ),
                            const SizedBox(height: 10),
                            _buildCard(
                              title: 'Total tanda tangan',
                              count:
                                  '${(_dashboardData?.approveCount ?? 0) + (_dashboardData?.pendingCount ?? 0)}',
                              icon: Icons.format_list_numbered,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
      bottomNavigationBar: BottomNavBarKaprodi(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required String count,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8), // Jarak antar kartu lebih kecil
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white, // Latar belakang kartu berwarna putih
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15), // Bayangan lembut
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Bagian ikon
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.1),
            ),
            padding: const EdgeInsets.all(12),
            child: Icon(
              icon,
              size: 28,
              color: color,
            ),
          ),
          const SizedBox(width: 15), // Jarak antar ikon dan teks
          // Bagian teks
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          // Bagian angka
          Padding(
            padding: const EdgeInsets.only(
                right:
                    10), // Menambahkan padding untuk menjauhkan angka dari sudut
            child: Text(
              count,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
