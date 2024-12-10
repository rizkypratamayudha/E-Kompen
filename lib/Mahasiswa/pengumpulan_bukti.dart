import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firstapp/Mahasiswa/progress_mahasiswa.dart';
import 'package:firstapp/Mahasiswa/riwayat.dart';
import 'package:firstapp/config/config.dart';
import 'package:firstapp/controller/auth_service.dart';
import 'package:firstapp/controller/pengerjaan.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../bottombar/bottombar.dart';
import 'profile.dart';
import 'pekerjaan.dart';
import '../mahasiswa.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_downloader/src/downloader.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class PengumpulanBuktiPage extends StatefulWidget {
  final Pekerjaan pekerjaan;
  final Progres progres;
  const PengumpulanBuktiPage({
    super.key,
    required this.pekerjaan,
    required this.progres,
  });

  @override
  _PengumpulanBuktiPageState createState() => _PengumpulanBuktiPageState();
}

class _PengumpulanBuktiPageState extends State<PengumpulanBuktiPage> {
  int _selectedIndex = 2; // Sesuaikan dengan tab yang sedang aktif
  bool isPengumpulanExist = false; // To track if pengumpulan data exists

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
  void initState() {
    super.initState();

    if (widget.progres.pengumpulan.isNotEmpty) {
      isPengumpulanExist = true;
    }
  }

  Future<void> _storeLinkBukti(int progresId, String link) async {
    try {
      final token =
          await AuthService().getToken(); // Get token for authentication
      final userId = await AuthService().getUserId();
      final response = await http.post(
        Uri.parse('${config.baseUrl}/mahasiswa/link'),
        headers: {
          'Authorization': 'Bearer $token', // Add the token for authentication
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'progres_id': progresId,
          'link': link,
          'user_id': userId,
          'status': 'pending'
        }),
      );

      if (response.statusCode == 201) {
        var data = jsonDecode(response.body);
        if (data['status'] == true) {
          print(data['message']); // Success message

          // Optionally, navigate to another page or show a success dialog
          if (mounted) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Sukses'),
                content: Text(data['message']),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RiwayatPage(),
                        ),
                      );
                    },
                    child: Text('OK'),
                  ),
                ],
              ),
            );
          }
        } else {
          print(data['message']); // Failure message
          if (mounted) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Gagal'),
                content: Text(data['message']),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('OK'),
                  ),
                ],
              ),
            );
          }
        }
      } else {
        print('Error: ${response.statusCode}');
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Error'),
              content: Text('Terjadi kesalahan. Coba lagi nanti.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('OK'),
                ),
              ],
            ),
          );
        }
      }
    } catch (e) {
      print('Error: $e');
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Terjadi kesalahan: $e'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  Future<void> _storeImageBukti(int progresId, File imageFile) async {
    try {
      final token = await AuthService().getToken();
      final userId = await AuthService().getUserId();
      final uri = Uri.parse('${config.baseUrl}/mahasiswa/gambar');
      final request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Bearer $token'
        ..fields['progres_id'] = progresId.toString()
        ..fields['user_id'] = userId.toString()
        ..files.add(await http.MultipartFile.fromPath('image', imageFile.path));

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final data = jsonDecode(responseBody);

      if (response.statusCode == 201) {
        // Success case: show success dialog
        print(data['message']);
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Sukses'),
              content: Text(data['message']),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RiwayatPage(),
                      ),
                    );
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          );
        }
      } else {
        // Error case: show error dialog
        print(data['message']);
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Gagal'),
              content: Text(data['message']),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('OK'),
                ),
              ],
            ),
          );
        }
      }
    } catch (e) {
      // Exception handling: show error dialog
      print('Error: $e');
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Terjadi kesalahan: $e'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  Future<void> _hapusPengumpulan(int progresId) async {
    try {
      final token = await AuthService().getToken();
      final response = await http.delete(
        Uri.parse('${config.baseUrl}/mahasiswa/$progresId/hapus'),
        headers: {
          'Authorization':
              'Bearer $token', // Pastikan token autentikasi ditambahkan
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == true) {
          print(data['message']); // Data berhasil dihapus

          // Tampilkan dialog sukses
          if (mounted) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Berhasil'),
                content: Text(data['message']),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RiwayatPage()),
                      );
                    },
                    child: Text('OK'),
                  ),
                ],
              ),
            );
          }
        } else {
          print(data['message']); // Gagal menghapus data
          if (mounted) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Gagal'),
                content: Text(data['message']),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Tutup dialog
                    },
                    child: Text('OK'),
                  ),
                ],
              ),
            );
          }
        }
      } else {
        print('Gagal menghapus data. Status code: ${response.statusCode}');
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Error'),
              content: Text(
                  'Gagal menghapus data. Status code: ${response.statusCode}'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Tutup dialog
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          );
        }
      }
    } catch (e) {
      print('Terjadi error: $e');
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Terjadi error: $e'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Tutup dialog
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  Future<void> _storeFile(int progresId, File imageFile) async {
    try {
      // Assuming you have an AuthService for token and user ID
      final token = await AuthService().getToken();
      final userId = await AuthService().getUserId();

      final uri =
          Uri.parse('${config.baseUrl}/mahasiswa/file'); // Use your backend URL
      final request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Bearer $token'
        ..fields['progres_id'] = progresId.toString()
        ..fields['user_id'] = userId.toString()
        ..files.add(await http.MultipartFile.fromPath('file', imageFile.path,
            contentType: DioMediaType('application', 'octet-stream')));

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final data = jsonDecode(responseBody);

      if (response.statusCode == 201) {
        // Success case: show success dialog
        print(data['message']);
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Sukses'),
              content: Text(data['message']),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            RiwayatPage(), // Replace with your page
                      ),
                    );
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          );
        }
      } else {
        // Error case: show error dialog
        print(data['message']);
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Gagal'),
              content: Text(data['message']),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('OK'),
                ),
              ],
            ),
          );
        }
      }
    } catch (e) {
      // Exception handling: show error dialog
      print('Error: $e');
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Terjadi kesalahan: $e'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  void _showJenisBuktiDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Pilih Jenis Bukti Pengumpulan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Link'),
              onTap: () {
                Navigator.pop(context);
                _addLinkBukti(); // Fungsi untuk menambahkan link
              },
            ),
            ListTile(
              title: Text('Gambar'),
              onTap: () {
                Navigator.pop(context);
                _addImageBukti(); // Fungsi untuk menambahkan gambar
              },
            ),
            ListTile(
              title: Text('File'),
              onTap: () {
                Navigator.pop(context);
                _addFileBukti(); // Fungsi untuk menambahkan file
              },
            ),
          ],
        ),
      ),
    );
  }

  void _addLinkBukti() async {
    TextEditingController linkController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Masukkan Link Bukti Pengumpulan'),
        content: TextField(
          controller: linkController,
          decoration: InputDecoration(hintText: "Masukkan URL link"),
          keyboardType: TextInputType.url,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              String link = linkController.text;
              // Simpan atau proses link sesuai kebutuhan
              print('Link Bukti: $link');
              _storeLinkBukti(widget.progres.progresId, link);
            },
            child: Text('Simpan'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal'),
          ),
        ],
      ),
    );
  }

  void _addImageBukti() async {
    // Function to pick an image from gallery
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      String filePath = pickedFile.path;
      print('Gambar Bukti: $filePath');

      // Convert the picked image into a File object
      File imageFile = File(filePath);

      // Now, use _storeImageBukti to upload the image to the server
      await _storeImageBukti(widget.progres.progresId, imageFile);
    }
  }

  Future<void> _addFileBukti() async {
    // Fungsi untuk memilih file
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      String filePath = result.files.single.path!;
      print('File Bukti: $filePath');

      // Convert the picked file to a File object
      File file = File(filePath);

      // Call the function to upload the file
      await _storeFile(widget.progres.progresId, file);
    }
  }

  Future<void> _downloadFile(String fileUrl) async {
    try {
      if (!FlutterDownloader.initialized) {
        print("Downloader belum diinisialisasi!");
        return;
      }

      final taskId = await FlutterDownloader.enqueue(
        url: 'http://localhost/kompenjti/public/storage/$fileUrl',
        savedDir: '/storage/emulated/0/Download', // Lokasi penyimpanan file
        showNotification: true,
        openFileFromNotification: true,
      );
      print("Download dimulai: $taskId");
    } catch (e) {
      print("Error saat mengunduh file: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    String buktiPengumpulanUrl = '';
    String namaOriginal = '';

    if (isPengumpulanExist) {
      // Assuming the first pengumpulan is the relevant one
      var pengumpulan = widget.progres.pengumpulan[0];
      buktiPengumpulanUrl = pengumpulan.buktiPengumpulan ?? '';
      namaOriginal = pengumpulan.namaoriginal ?? '';
    }

    // Check if the deadline has passed
    bool isDeadlinePassed = false;
    DateTime? deadline;
    String formattedDeadline = '';
    try {
      // Convert string deadline to DateTime
      deadline = DateTime.parse(widget.progres.deadline.toString());
      isDeadlinePassed = DateTime.now().isAfter(deadline);
      formattedDeadline = DateFormat('dd MMM yyyy HH:mm').format(deadline);
    } catch (e) {
      // If the string cannot be parsed to DateTime, assume it's not passed
      isDeadlinePassed = false;
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProgressMahasiswaPage(
                  pekerjaan: widget.pekerjaan,
                ),
              ),
            );
          },
        ),
        title: Text(
          'Progress 1',
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
                      buildInfoRow(
                          'Jenis Tugas:', widget.pekerjaan.jenisPekerjaan),
                      buildInfoRow('Tugas:', widget.pekerjaan.pekerjaanNama),
                      buildInfoRow(
                          'Judul Progres:', widget.progres.judulProgres),
                      buildInfoRow(
                          'Jumlah Jam:', widget.progres.jamKompen.toString()),
                      buildInfoRow('Batas Pengerjaan:',
                          formattedDeadline), // Display formatted deadline
                      buildInfoRow(
                        'Nilai',
                        widget.progres.pengumpulan.isEmpty
                            ? '-'
                            : widget.progres.pengumpulan[0].status == 'pending'
                                ? 'Belum Dinilai'
                                : widget.progres.pengumpulan[0].status ==
                                        'accept'
                                    ? 'Telah Dinilai ${widget.progres.jamKompen}'
                                    : widget.progres.pengumpulan[0].status ==
                                            'decline'
                                        ? 'Telah Dinilai 0'
                                        : '-',
                      ),
                      const SizedBox(height: 16),
                      // Foto Bukti
                      Text(
                        'Bukti Pengumpulan: ',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white,
                              blurRadius: 10,
                              offset: Offset(0, 4), // Shadow position
                            ),
                          ],
                          color: Colors.grey[200],
                        ),
                        child: (buktiPengumpulanUrl.startsWith('https'))
                            ? InkWell(
                                onTap: () {
                                  if (Uri.tryParse(buktiPengumpulanUrl)
                                          ?.hasAbsolutePath ??
                                      false) {
                                    // Open the link in a browser
                                    launch(buktiPengumpulanUrl);
                                  }
                                },
                                child: Text(
                                  'Lihat Bukti Pengumpulan',
                                  style: TextStyle(color: Colors.blue),
                                ),
                              )
                            : (buktiPengumpulanUrl
                                    .startsWith('pengumpulan_gambar'))
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      'http://localhost/kompenjti/public/storage/$buktiPengumpulanUrl',
                                      fit: BoxFit.contain,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        } else {
                                          return Center(
                                            child: CircularProgressIndicator(
                                              value: loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      (loadingProgress
                                                              .expectedTotalBytes ??
                                                          1)
                                                  : null,
                                            ),
                                          );
                                        }
                                      },
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Icon(
                                          Icons.error,
                                          color: Colors.red,
                                        );
                                      },
                                    ),
                                  )
                                : (buktiPengumpulanUrl
                                        .startsWith('pengumpulan_file'))
                                    ? InkWell(
                                        onTap: () {
                                          _downloadFile(buktiPengumpulanUrl);
                                        },
                                        child: Text(
                                          'Download Bukti Pengumpulan',
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                      )
                                    : Icon(
                                        Icons.image,
                                        size: 50,
                                        color: Colors.grey[400],
                                      ),
                      ),
                      const SizedBox(height: 16),
                      // Tombol Tambah/Edit
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: Colors.blue,
                            ),
                            onPressed: isDeadlinePassed ||
                                    (widget.progres.pengumpulan.isNotEmpty &&
                                        widget.progres.pengumpulan[0].status ==
                                            'accept')
                                ? null // Disable the button if deadline is passed or pengumpulan is accepted
                                : () {
                                    // Handle button press
                                    if (isPengumpulanExist) {
                                      _hapusPengumpulan(widget.progres
                                          .pengumpulan[0].pengumpulanId);
                                    } else {
                                      _showJenisBuktiDialog();
                                    }
                                  },
                            child: Text(
                              isPengumpulanExist ? 'Batal' : '+ Tambah',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Display the original file name or URL if available
                      if (namaOriginal.isNotEmpty)
                        Text(
                          'Nama File: $namaOriginal',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      else if (buktiPengumpulanUrl.isNotEmpty)
                        Text(
                          'Bukti Pengumpulan: $buktiPengumpulanUrl',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
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
      bottomNavigationBar: BottomNavBar(
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
}
