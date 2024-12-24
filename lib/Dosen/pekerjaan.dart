import 'package:firstapp/config/config.dart';
import 'package:firstapp/controller/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../bottombar/bottombarDosen.dart';
import 'profile.dart';
import 'penerimaan_dosen1.dart';
import '../dosen.dart';
import 'editPekerjaan.dart';
import 'showPekerjaan.dart';
import 'tambah_pekerjaan.dart';
import '../controller/dosen_pekerjaan_service.dart';
import '../Model/dosen_pekerjaan_model.dart';
import 'mulai_deadline.dart';
import 'edit_deadline.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'lihat_daftar_mahasiswa.dart';

class PekerjaanDosenPage extends StatefulWidget {
  const PekerjaanDosenPage({super.key});

  @override
  _PekerjaanDosenPageState createState() => _PekerjaanDosenPageState();
}

class _PekerjaanDosenPageState extends State<PekerjaanDosenPage> {
  final DosenBuatPekerjaanService _service = DosenBuatPekerjaanService();
  int _selectedIndex = 1;
  late Future<List<DosenPekerjaan>> _pekerjaanFuture;
  int userId = 0;

  @override
  void initState() {
    super.initState();
    _pekerjaanFuture =
        Future.value([]); // Inisialisasi awal untuk mencegah error
    _loadUserId(); // Memuat userId dan data pekerjaan
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('userId') ??
          0; // Mengambil user_id dari SharedPreferences
      _pekerjaanFuture = DosenBuatPekerjaanService().fetchPekerjaan(userId);
    });
  }

  Future<void> _updateStatusAutomatically(
      DosenPekerjaan pekerjaan, int anggota, int totalAnggota) async {
    final isFull = anggota == totalAnggota;

    if (isFull && pekerjaan.status == 'open') {
      try {
        await _service.updateStatus(pekerjaan.pekerjaanId, 'close');
        setState(() {
          pekerjaan.status = 'close';
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memperbarui status otomatis: $e')),
        );
      }
    }
  }

  // Fungsi untuk memeriksa pelamar pekerjaan
  Future<Map<String, dynamic>> _checkPendingApplicants(int pekerjaanId) async {
    try {
      final service = DosenBuatPekerjaanService();
      final response = await service.getPendingApplicants(pekerjaanId);
      return {'success': true, 'data': response};
    } catch (e) {
      return {
        'success': false,
        'error': 'Gagal memeriksa data pelamar.',
        'message': e.toString(),
      };
    }
  }

// Dialog informasi
  void _showInfoDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _toggleStatus(
      DosenPekerjaan pekerjaan, int anggota, int totalAnggota) async {
    final isFull = anggota == totalAnggota;

    if (isFull && pekerjaan.status == 'close') {
      await _showDialogKondisi(
        context,
        'Perubahan Status Dilarang',
        'Pekerjaan ini sudah penuh dan tidak bisa mengubah status ke Open. '
            'Jika Anda ingin mengubah status ke Open, tambahkan total anggota atau kurangi anggota yang ada.',
      );
      return;
    }

    try {
      await _service.updateStatus(pekerjaan.pekerjaanId, pekerjaan.status!);
      setState(() {
        pekerjaan.status = pekerjaan.status == 'open' ? 'close' : 'open';
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memperbarui status: $e')),
      );
    }
  }

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
        throw Exception(
            'Failed to fetch anggota sekarang for pekerjaan_id $pekerjaanId');
      }
    } catch (e) {
      print('Error fetching anggota sekarang: $e');
      return 0; // Default nilai jika terjadi error
    }
  }

  Future<void> _showConfirmationDialog(BuildContext context,
      DosenPekerjaan pekerjaan, int anggota, int totalAnggota) async {
    final isOpen = pekerjaan.status == 'open';
    final newStatus = isOpen ? 'close' : 'open';

    final isFull = anggota == totalAnggota;

    // Jika pekerjaan full dan status ingin diubah ke open
    if (isFull && newStatus == 'open') {
      await _showDialogKondisi(
        context,
        'Perubahan Status Dilarang',
        'Pekerjaan ini sudah penuh dan tidak bisa mengubah status ke Open. '
            'Jika Anda ingin mengubah status ke Open, tambahkan total anggota atau kurangi anggota yang ada.',
      );
      return;
    }

    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi'),
          content: Text(
              'Apakah Anda yakin ingin mengganti status pekerjaan ke $newStatus?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Tidak'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Ya'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      await _toggleStatus(pekerjaan, anggota, totalAnggota);
    }
  }

  Future<void> _showDialogKondisi(
      BuildContext context, String title, String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible:
          false, // Dialog tidak bisa ditutup dengan klik di luar
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style:
                GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          content: Text(
            message,
            style: GoogleFonts.poppins(fontSize: 14),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Okay'),
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
            ),
          ],
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

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DosenDashboard()),
        );
        break;
      case 1:
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PenerimaanDosen1()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Kembali ke halaman sebelumnya
          },
        ),
        title: Text(
          'Pekerjaan',
          style: GoogleFonts.poppins(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          Positioned(
            top: 10,
            left: 0,
            right: 0,
            bottom: 70, // Memberi jarak agar tombol tidak tertutup
            child: FutureBuilder<List<DosenPekerjaan>>(
              future: _pekerjaanFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: GoogleFonts.poppins(fontSize: 16),
                    ),
                  );
                } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                  return _buildEmptyState();
                } else if (snapshot.hasData) {
                  return _buildPekerjaanList(snapshot.data!);
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
          _buildAddButton(),
        ],
      ),
      bottomNavigationBar: BottomNavBarDosen(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 50.0, 20.0, 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/img/no_taks.png',
                    height: 150,
                    width: 150,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Tidak ada tugas yang dikerjakan',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPekerjaanList(List<DosenPekerjaan> pekerjaanList) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: pekerjaanList.asMap().entries.map((entry) {
          final index = entry.key + 1; // Nomor urut, dimulai dari 1
          final pekerjaan = entry.value;

          // Gunakan FutureBuilder untuk mengambil jumlah anggota sekarang
          return Column(
            children: [
              FutureBuilder<int>(
                future: fetchAnggotaSekarang(pekerjaan.pekerjaanId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      height: 100,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Container(
                      height: 100,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          'Error: ${snapshot.error}',
                          style: GoogleFonts.poppins(
                              fontSize: 12, color: Colors.white),
                        ),
                      ),
                    );
                  } else {
                    final anggotaSekarang = snapshot.data ?? 0;
                    return _buildPekerjaan(
                      pekerjaan.pekerjaanNama,
                      anggotaSekarang,
                      pekerjaan.jumlahAnggota,
                      index,
                      pekerjaan,
                    );
                  }
                },
              ),
              const SizedBox(height: 16),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAddButton() {
    return Positioned(
      bottom: 16,
      right: 16,
      child: Container(
        height: 40, // Tinggi tombol
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TambahPekerjaanPage()),
            );
          },
          icon: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          label: Text(
            'Tambah Pekerjaan',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPekerjaan(String title, int anggota, int totalAnggota,
      int pekerjaanIndex, DosenPekerjaan pekerjaan) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildNumberBox(pekerjaanIndex),
              const SizedBox(width: 8),
              Expanded(
                child: _buildPekerjaanDetails(
                    title, anggota, totalAnggota, pekerjaan),
              ),
              const SizedBox(width: 8),
              _buildActionButtons(pekerjaan, anggota),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNumberBox(int index) {
    return Container(
      width: 40,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.yellow,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          '$index',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildPekerjaanDetails(
      String title, int anggota, int totalAnggota, DosenPekerjaan pekerjaan) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPekerjaanInfo(pekerjaan, title, anggota, totalAnggota),
        const SizedBox(height: 8),
        _buildStatusAndConditionButtons(pekerjaan, anggota, totalAnggota),
        const SizedBox(height: 8),
        _buildDeadlineButtons(pekerjaan), // Mengirim data pekerjaan
      ],
    );
  }

  Widget _buildPekerjaanInfo(
      DosenPekerjaan pekerjaan, String title, int anggota, int totalAnggota) {
    return GestureDetector(
      onTap: () {
        // Arahkan ke halaman LihatDaftarMahasiswa
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LihatDaftarMahasiswa(
              pekerjaanId: pekerjaan.pekerjaanId ??
                  0, // Pastikan pekerjaanId didefinisikan
              pekerjaanNama: pekerjaan.pekerjaanNama ?? 'Nama Tidak Tersedia',
            ),
          ),
        );
      },
      child: Container(
        height: 100,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(fontSize: 12, color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.person, color: Colors.white, size: 16),
                const SizedBox(width: 4),
                Text(
                  '$anggota/$totalAnggota',
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPekerjaanInfoWithAnggota(
      DosenPekerjaan pekerjaan, pekerjaanId, String title, int totalAnggota) {
    return FutureBuilder<int>(
      future: fetchAnggotaSekarang(pekerjaanId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Sementara menunggu data
          return Container(
            height: 100,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          );
        } else if (snapshot.hasError) {
          // Jika terjadi error
          return Container(
            height: 100,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: GoogleFonts.poppins(fontSize: 12, color: Colors.white),
              ),
            ),
          );
        } else {
          // Jika data tersedia
          final anggota = snapshot.data ?? 0; // Nilai default jika null
          return _buildPekerjaanInfo(pekerjaan, title, anggota, totalAnggota);
        }
      },
    );
  }

  Widget _buildStatusAndConditionButtons(
      DosenPekerjaan pekerjaan, int anggota, int totalAnggota) {
    final isFull = anggota == totalAnggota;

    // Pastikan status pekerjaan otomatis diperbarui saat widget dimuat
    _updateStatusAutomatically(pekerjaan, anggota, totalAnggota);

    return Row(
      children: [
        // Tombol Status
        Expanded(
          child: GestureDetector(
            onTap: () async {
              await _showConfirmationDialog(
                  context, pekerjaan, anggota, totalAnggota);
            },
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: pekerjaan.status == 'open' ? Colors.green : Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  pekerjaan.status == 'open' ? 'Open' : 'Closed',
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Tombol Kondisi
        Expanded(
          child: GestureDetector(
            onTap: () async {
              if (isFull) {
                await _showDialogKondisi(
                  context,
                  'Kondisi Pekerjaan',
                  'Pekerjaan ini sudah penuh.',
                );
              } else {
                await _showDialogKondisi(
                  context,
                  'Kondisi Pekerjaan',
                  'Pekerjaan ini masih memerlukan anggota tambahan.',
                );
              }
            },
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isFull ? Colors.green : Colors.orange,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  isFull ? 'Full' : 'Belum Full',
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDeadlineButtons(DosenPekerjaan pekerjaan) {
    return Row(
      children: [
        _buildButton(
          color: Colors.blue,
          icon: Icons.start,
          label: 'Mulai Deadline',
          onPressed: () async {
            if (pekerjaan.akumulasiDeadline != null &&
                pekerjaan.akumulasiDeadline!.isNotEmpty) {
              // Jika akumulasiDeadline terisi (bukan null atau string kosong), tampilkan popup
              await _showDialog(
                context,
                'Pekerjaan Sudah Dimulai',
                'Pekerjaan ini sudah memiliki deadline yang dimulai.',
              );
            } else {
              // Jika belum terisi, arahkan ke MulaiDeadlinePage
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MulaiDeadlinePage(
                    pekerjaanId: pekerjaan.pekerjaanId,
                    pekerjaanNama: pekerjaan.pekerjaanNama,
                  ),
                ),
              );
            }
          },
        ),
        const SizedBox(width: 8),
        _buildButton(
          color: Colors.yellow[700]!,
          icon: Icons.edit,
          label: 'Edit Deadline',
          onPressed: () async {
            if (pekerjaan.akumulasiDeadline == null ||
                pekerjaan.akumulasiDeadline!.isEmpty) {
              // Jika akumulasiDeadline belum diisi atau kosong, tampilkan popup
              await _showDialog(
                context,
                'Pekerjaan Belum Dimulai',
                'Pekerjaan ini belum memiliki deadline yang dimulai.',
              );
            } else {
              // Jika sudah terisi, arahkan ke EditDeadlinePage
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditDeadlinePage(
                    pekerjaanId: pekerjaan.pekerjaanId ?? 0,
                    pekerjaanNama:
                        pekerjaan.pekerjaanNama ?? 'Nama Tidak Tersedia',
                  ),
                ),
              );
            }
          },
        ),
      ],
    );
  }

  Future<void> _showDialog(
      BuildContext context, String title, String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible:
          false, // Dialog tidak bisa ditutup dengan klik di luar
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title,
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          content: Text(message, style: GoogleFonts.poppins()),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildButton({
    required Color color,
    required IconData icon,
    required String label,
    VoidCallback? onPressed, // Tambahkan parameter untuk aksi
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onPressed, // Jalankan aksi saat tombol ditekan
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 16),
                const SizedBox(width: 5),
                Text(
                  label,
                  style: GoogleFonts.poppins(fontSize: 10, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(DosenPekerjaan pekerjaan, int anggota) {
    return Column(
      children: [
        _buildActionButton(
          icon: Icons.edit,
          label: 'Edit',
          color: Colors.yellow[700]!,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditPekerjaanPage(
                  pekerjaanId: pekerjaan.pekerjaanId ?? 0,
                  pekerjaanNama:
                      pekerjaan.pekerjaanNama ?? 'Nama Tidak Tersedia',
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        _buildActionButton(
          icon: Icons.info,
          label: 'Detail',
          color: Colors.blue,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ShowPekerjaanPage(
                  pekerjaanId: pekerjaan.pekerjaanId ?? 0,
                  pekerjaanNama:
                      pekerjaan.pekerjaanNama ?? 'Nama Tidak Tersedia',
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        _buildActionButton(
          icon: Icons.delete,
          label: 'Hapus',
          color: Colors.red,
          onPressed: () {
            _showDeleteConfirmation(pekerjaan, anggota);
          },
        ),
      ],
    );
  }

  void _showDeleteConfirmation(DosenPekerjaan pekerjaan, int anggota) async {
    try {
      final hasApplicants =
          await _checkPendingApplicants(pekerjaan.pekerjaanId!);

      if (anggota > 0) {
        _showInfoDialog(
          context,
          'Pekerjaan Tidak Bisa Dihapus',
          'Pekerjaan tidak bisa dihapus dikarenakan pada pekerjaan ini masih ada anggota.',
        );
        return;
      } else if (!hasApplicants['success']) {
        _showInfoDialog(
          context,
          'Pekerjaan Tidak Bisa Dihapus',
          'Pekerjaan tidak bisa dihapus dikarenakan pada pekerjaan ini anggota sudah mengupulkan progres pekerjaan',
        );
        return;
      } else if (hasApplicants['data'].isNotEmpty) {
        _showInfoDialog(
          context,
          'Pekerjaan Tidak Bisa Dihapus',
          'Pekerjaan tidak bisa dihapus dikarenakan terdapat pelamar pending.',
        );
        return;
      }

      // Jika memenuhi syarat untuk dihapus, tampilkan dialog konfirmasi
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Konfirmasi Hapus'),
            content: Text(
              "Apakah Anda yakin ingin menghapus pekerjaan '${pekerjaan.pekerjaanNama}'?",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Tutup dialog
                },
                child: const Text('Tidak'),
              ),
              TextButton(
                onPressed: () async {
                  try {
                    // Panggil service untuk menghapus pekerjaan
                    final service = DosenBuatPekerjaanService();
                    await service.hapusPekerjaan(pekerjaan.pekerjaanId!);

                    // Berikan notifikasi dan kembali ke halaman pekerjaan
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Pekerjaan berhasil dihapus')),
                    );
                    Navigator.of(context).pop(); // Tutup dialog
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) =>
                            PekerjaanDosenPage(), // Pastikan ini adalah halaman tujuan
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Gagal menghapus pekerjaan: $e')),
                    );
                  }
                },
                child: const Text('Ya'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      _showInfoDialog(
        context,
        'Error',
        'Gagal memeriksa data pekerjaan: $e',
      );
    }
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
    int? anggota,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 40,
        height: 60,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 16),
            Text(
              label,
              style: GoogleFonts.poppins(fontSize: 10, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
