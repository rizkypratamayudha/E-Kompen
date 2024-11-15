import 'dart:convert';
import 'dart:io';
import 'package:firstapp/Mahasiswa/upload_kompetensi.dart';
import 'package:firstapp/Mahasiswa/kompetensi.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../bottombar/bottombar.dart';
import 'riwayat.dart';
import 'pekerjaan.dart';
import '../mahasiswa.dart';
import '../widget/popup_logout.dart';
import '../config/config.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoading = false; // Add this line to define _isLoading
  bool _isPasswordSectionVisible = false;
  bool _isOldPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  int _selectedIndex = 3;
  String _nama = '';
  String _username = '';
  String _avatarUrl = '';  // URL avatar
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _profileImage;


  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nama = prefs.getString('nama') ?? 'User';
      _username = prefs.getString('username') ?? 'Username';
      _avatarUrl = prefs.getString('avatar') ?? '';  // Load avatar URL
    });
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) {
      return;
    }

    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
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
Future<void> _updatePassword() async {
  if (_newPasswordController.text != _confirmPasswordController.text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Password baru dan konfirmasi tidak cocok")),
    );
    return;
  }

  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    // Tampilkan indikator loading (opsional)
    setState(() {
      _isLoading = true; // misalnya ada variabel bool _isLoading
    });

    final response = await http.put(
      Uri.parse('${config.baseUrl}/updatePassword'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'current_password': _currentPasswordController.text,
        'password': _newPasswordController.text,
        'password_confirmation': _confirmPasswordController.text,
      }),
    );

    setState(() {
      _isLoading = false; // Sembunyikan loading setelah mendapat respons
    });

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Password berhasil diperbarui")),
      );
      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
      setState(() {
        _isPasswordSectionVisible = false;
      });
    } else {
      // Tangani error berdasarkan status code atau response body
      final errorData = jsonDecode(response.body);
      String errorMessage = errorData['error'] ?? "Gagal memperbarui password";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  } catch (e) {
    setState(() {
      _isLoading = false; // Sembunyikan loading jika terjadi error
    });
    // Tangani kesalahan jaringan atau kesalahan lain
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Terjadi kesalahan: $e")),
    );
  }
}

Future<void> _updateProfilePhoto() async {
    if (_profileImage == null) return;

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${config.baseUrl}/updatePhoto'),
    );

    request.headers['Authorization'] = 'Bearer $token';
    request.files.add(await http.MultipartFile.fromPath(
      'avatar', _profileImage!.path,
    ));

    final response = await request.send();

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Foto profil berhasil diperbarui")),
      );
      _loadUserData(); // Reload user data to show updated avatar
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal memperbarui foto profil")),
      );
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
      _updateProfilePhoto();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.blue[800],
                padding: const EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 30.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey,
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : (_avatarUrl.isNotEmpty
                                ? NetworkImage(_avatarUrl) as ImageProvider
                                : const AssetImage('assets/img/polinema.png')),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _nama,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          _username,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.exit_to_app,
                          size: 30, color: Colors.red),
                      onPressed: () {
                        PopupLogout.showLogoutDialog(context);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              InkWell(
                onTap: () {
                  setState(() {
                    _isPasswordSectionVisible = !_isPasswordSectionVisible;
                  });
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.vpn_key),
                          const SizedBox(width: 25),
                          Text('Ganti Password', style: GoogleFonts.poppins()),
                        ],
                      ),
                      Icon(_isPasswordSectionVisible
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ),
              if (_isPasswordSectionVisible)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: Column(
                    children: [
                      buildPasswordField(
                        label: 'Password Lama',
                        isPasswordVisible: _isOldPasswordVisible,
                        toggleVisibility: () {
                          setState(() {
                            _isOldPasswordVisible = !_isOldPasswordVisible;
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      buildPasswordField(
                        label: 'Password Baru',
                        isPasswordVisible: _isNewPasswordVisible,
                        toggleVisibility: () {
                          setState(() {
                            _isNewPasswordVisible = !_isNewPasswordVisible;
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      buildPasswordField(
                        label: 'Verifikasi Password Baru',
                        isPasswordVisible: _isConfirmPasswordVisible,
                        toggleVisibility: () {
                          setState(() {
                            _isConfirmPasswordVisible =
                                !_isConfirmPasswordVisible;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _updatePassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 22, 126, 211),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                        ),
                        child: Text('Okay',
                            style: GoogleFonts.poppins(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 10),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const UploadKompetensi()),
                  );
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.file_upload),
                      const SizedBox(width: 25),
                      Text('Upload Kompetensi',
                          style: GoogleFonts.poppins()),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              InkWell(
                
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.person_search),
                      const SizedBox(width: 25),
                      Text('Lihat Kompetensi', style: GoogleFonts.poppins()),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPasswordField({
    required String label,
    required bool isPasswordVisible,
    required VoidCallback toggleVisibility,
  }) {
    return TextField(
      controller: label == 'Password Lama'
          ? _currentPasswordController
          : label == 'Password Baru'
              ? _newPasswordController
              : _confirmPasswordController,
      obscureText: !isPasswordVisible,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: IconButton(
          icon: Icon(
            isPasswordVisible
                ? Icons.visibility
                : Icons.visibility_off,
          ),
          onPressed: toggleVisibility,
        ),
      ),
    );
  }
}
