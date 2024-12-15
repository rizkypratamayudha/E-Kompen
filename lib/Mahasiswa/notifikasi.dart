import 'dart:convert';
import 'package:firstapp/config/config.dart';
import 'package:firstapp/controller/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../bottombar/bottombar.dart';
import 'riwayat.dart';
import 'profile.dart';
import 'pekerjaan.dart';
import '../mahasiswa.dart';

class NotifikasiMahasiswaPage extends StatefulWidget {
  const NotifikasiMahasiswaPage({super.key});

  @override
  _NotifikasiMahasiswaPageState createState() =>
      _NotifikasiMahasiswaPageState();
}

class _NotifikasiMahasiswaPageState extends State<NotifikasiMahasiswaPage> {
  int _selectedIndex = 3;
  List<dynamic> _notifikasiList = [];
  bool _isLoading = true;
  int _notificationCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchNotifikasi();
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

  // Fungsi untuk mengambil data notifikasi dari API
  Future<void> _fetchNotifikasi() async {
    final userId = await AuthService().getUserId();
    try {
      final token = await AuthService().getToken();
      final response = await http.get(
        Uri.parse('${config.baseUrl}/mahasiswa/$userId/notifikasi'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _notifikasiList = data['data']['notifikasi'];
          _isLoading = false;
        });
      } else {
        throw Exception('Gagal mengambil notifikasi');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error: $e');
    }
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
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
          },
        ),
        title: Text(
          'Notifikasi',
          style: GoogleFonts.poppins(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _notifikasiList.length,
              itemBuilder: (context, index) {
                final item = _notifikasiList[index];
                final pesan = _getFormattedPesan(item);
                final waktuRaw = item['created_at'] ?? 'Tidak ada waktu';
                final waktu = _formatTime(waktuRaw);
                return Column(
                  children: [
                    _buildNotificationCard(
                      color: _getNotificationColor(pesan),
                      icon: Icons.notifications,
                      description: pesan,
                      time: waktu,
                      notificationIndex: index,
                    ),
                    const SizedBox(height: 8),
                  ],
                );
              },
            ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
        notificationCount: _notificationCount,
      ),
    );
  }

  // Fungsi untuk memeriksa dan memformat pesan jika sesuai
  String _getFormattedPesan(dynamic item) {
    final pesan = item['pesan'] ?? 'Tidak ada pesan';
    if (pesan.startsWith('Selamat!!!, Anda telah diterima pada pekerjaan')) {
      final pekerjaanNama =
          item['pekerjaan']?['pekerjaan_nama'] ?? 'tidak diketahui';
      return '$pesan ($pekerjaanNama)';
    }
    return pesan;
  }

  // Fungsi untuk menentukan warna berdasarkan isi pesan
  Color _getNotificationColor(String pesan) {
    if (pesan.startsWith('Selamat') || pesan.startsWith('Jam Kompen')) {
      return Colors.green;
    } else if (pesan.startsWith('Mohon maaf') || pesan.startsWith('Coba')) {
      return Colors.red;
    } else {
      return Colors.blue;
    }
  }

  // Fungsi untuk memformat waktu
  String _formatTime(String rawTime) {
    try {
      final DateTime parsedTime = DateTime.parse(rawTime);
      return DateFormat('dd MMM yyyy HH:mm').format(parsedTime);
    } catch (e) {
      return 'Format waktu tidak valid';
    }
  }

  Widget _buildNotificationCard({
    required Color color,
    required IconData icon,
    required String description,
    required String time,
    required int
        notificationIndex, // Add an index for identifying the notification to delete
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 32,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  time,
                  style: GoogleFonts.poppins(
                    color: const Color.fromARGB(255, 255, 249, 202),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.white,
            ),
            onPressed: () {
              _deleteNotification(
                  notificationIndex); // Call the delete function
            },
          ),
        ],
      ),
    );
  }

  Future<void> _deleteNotification(int index) async {
    final notificationId = _notifikasiList[index]['notifikasi_id'];
    final token = await AuthService().getToken();

    try {
      final response = await http.delete(
        Uri.parse('${config.baseUrl}/mahasiswa/$notificationId/notifikasihapus'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // If the deletion was successful, remove the notification from the local list
        setState(() {
          _notifikasiList.removeAt(index);
        });
        // Show a success message if needed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Notifikasi berhasil dihapus')),
        );
      } else {
        // If the deletion failed, show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menghapus notifikasi')),
        );
      }
    } catch (e) {
      // Handle network or other errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    }
  }
}
