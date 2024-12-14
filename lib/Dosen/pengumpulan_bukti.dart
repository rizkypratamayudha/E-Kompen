import 'package:dio/dio.dart';
import 'package:firstapp/Dosen/penerimaan_dosen1.dart';
import 'package:firstapp/Dosen/progress_dosen.dart';
import 'package:firstapp/Mahasiswa/progress_mahasiswa.dart';
import 'package:firstapp/controller/getnilai.dart';
import 'package:firstapp/dosen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../bottombar/bottombarDosen.dart';
import 'profile.dart';
import 'pekerjaan.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class PengumpulanBuktiDosenPage extends StatefulWidget {
  final String nama;
  final String id;
  final String tanggal;
  final String tugas;
  final String jenisTugas;
  final String judulProgres;
  final int jumlahjam;
  final String bukti_pengumpulan;
  final String nama_original;
  final String tanggaldikumpulkan;

  const PengumpulanBuktiDosenPage(
      {super.key,
      required this.nama,
      required this.id,
      required this.tanggal,
      required this.tugas,
      required this.jenisTugas,
      required this.judulProgres,
      required this.jumlahjam,
      required this.bukti_pengumpulan,
      required this.nama_original,
      required this.tanggaldikumpulkan});

  @override
  _PengumpulanBuktiDosenPageState createState() =>
      _PengumpulanBuktiDosenPageState();
}

class _PengumpulanBuktiDosenPageState extends State<PengumpulanBuktiDosenPage> {
  int _selectedIndex = 2; // Sesuaikan dengan tab yang sedang aktif

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
        MaterialPageRoute(builder: (context) => PekerjaanDosenPage()),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()),
      );
    } else if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DosenDashboard()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    DateTime? deadline;
    String formatdeadline = '';

    deadline = DateTime.parse(widget.tanggal);
    formatdeadline = DateFormat('dd MMM yyyy HH:mm').format(deadline);

    DateTime?dikumpulkan;
    String dikumpulkantgl = '';

    dikumpulkan = DateTime.parse(widget.tanggaldikumpulkan);
    dikumpulkantgl = DateFormat('dd MMM yyyy HH:mm').format(dikumpulkan);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PenerimaanDosen1()),
            );
          },
        ),
        title: Text(
          widget.nama,
          style: GoogleFonts.poppins(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildInfoRow('Jenis Tugas:', widget.jenisTugas),
                      buildInfoRow('Tugas:', widget.tugas),
                      buildInfoRow('Nama Progres:', widget.judulProgres),
                      buildInfoRow('Jumlah Jam:', widget.jumlahjam.toString()),
                      buildInfoRow('Batas Pengerjaan:', formatdeadline),
                      buildInfoRow('Diserahkan pada:', dikumpulkantgl),
                      const SizedBox(height: 16),
                      // Foto Bukti
                      Text(
                        'Bukti Pengumpulan :',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Conditional rendering of bukti_pengumpulan
                      buildBuktiPengumpulan(widget.bukti_pengumpulan),
                      const SizedBox(height: 16),
                      if (widget.nama_original.isNotEmpty)
                        Text(
                          'Nama File: ${widget.nama_original}',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                    ]
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBarDosen(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      backgroundColor: Colors.white,
    );
  }

  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
            ),
          ),
          const Divider(
            color: Colors.black,
          ),
        ],
      ),
    );
  }

  // Function to handle the display of bukti_pengumpulan
  Widget buildBuktiPengumpulan(String buktiPengumpulanUrl) {
    if (buktiPengumpulanUrl.startsWith('https')) {
      // If it's a URL, show clickable text
      return InkWell(
        onTap: () {
          // Open the URL if it's a valid https URL
          if (Uri.tryParse(buktiPengumpulanUrl)?.hasAbsolutePath ?? false) {
            launch(buktiPengumpulanUrl); // Open in browser
          }
        },
        child: Text(
          'Lihat Bukti Pengumpulan',
          style: TextStyle(color: Colors.blue),
        ),
      );
    } else if (buktiPengumpulanUrl.startsWith('pengumpulan_gambar')) {
      // If it's an image URL
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          'http://192.168.100.225/kompenjti/public/storage/$buktiPengumpulanUrl',
          fit: BoxFit.contain,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            } else {
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          (loadingProgress.expectedTotalBytes ?? 1)
                      : null,
                ),
              );
            }
          },
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.error,
              color: Colors.red,
            );
          },
        ),
      );
    } else if (buktiPengumpulanUrl.startsWith('pengumpulan_file')) {
      // If it's a file, show download option
      return InkWell(
        onTap: () {
          // Handle file download here
          _downloadFile(buktiPengumpulanUrl);
        },
        child: Text(
          'Download Bukti Pengumpulan',
          style: TextStyle(color: Colors.blue),
        ),
      );
    } else {
      // Default icon if no matching condition
      return Icon(
        Icons.image,
        size: 50,
        color: Colors.grey[400],
      );
    }
  }

void _downloadFile(String fileUrl) async {
  // Request storage permission
  PermissionStatus status = await Permission.storage.request();

  if (status.isGranted) {
    try {
      // Tentukan base URL untuk file yang akan diunduh
      String baseUrl = 'http://192.168.100.225/kompenjti/public/storage/';

      // Cek apakah fileUrl relatif atau URL lengkap
      if (!fileUrl.startsWith('http')) {
        fileUrl = baseUrl + fileUrl; // Tambahkan base URL jika fileUrl relatif
      }

      // Dapatkan nama file dari `nama_original` atau gunakan `bukti_pengumpulan` sebagai fallback
      String fileName = widget.nama_original.isNotEmpty
          ? widget.nama_original
          : fileUrl.split('/').last; // Ambil nama file dari URL jika `nama_original` kosong

      // Dapatkan direktori Downloads
      Directory? downloadsDirectory;
      if (Platform.isAndroid) {
        downloadsDirectory = Directory('/storage/emulated/0/Download');
      } else if (Platform.isIOS) {
        downloadsDirectory = await getApplicationDocumentsDirectory(); // Gunakan Documents di iOS
      }

      // Tentukan path file yang akan disimpan
      String filePath = '${downloadsDirectory!.path}/$fileName';

      // Buat instance Dio untuk mengunduh file
      Dio dio = Dio();

      // Mulai proses pengunduhan
      await dio.download(
        fileUrl,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            print("Mengunduh: ${(received / total * 100).toStringAsFixed(0)}%");
          }
        },
      );

      // Tampilkan pesan sukses setelah file berhasil diunduh
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("File berhasil diunduh ke folder Downloads")),
      );
      print("File berhasil disimpan di: $filePath");
    } catch (e) {
      // Tangani jika terjadi error selama pengunduhan
      print("Pengunduhan gagal: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal mengunduh file")),
      );
    }
  } else {
    // Inform the user that permission was denied
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Permission to access storage is denied")),
    );
  }
}


}
