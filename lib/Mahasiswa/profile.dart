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
import '../Model/profileModel.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoading = false;
  bool _isPasswordSectionVisible = false;
  bool _isOldPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  File? _profileImage;
  String _avatarUrl = ''; // Add your default avatar URL here if necessary
  String _nama = 'Your Name'; // Example: Replace with actual user data
  String _username = 'Username'; // Example: Replace with actual user data

  // Pick image from gallery
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  // Update Password
  Future<void> _updatePassword() async {
    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password baru dan konfirmasi tidak cocok")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final result = await ProfileService().updatePassword(
      _currentPasswordController.text,
      _newPasswordController.text,
      _confirmPasswordController.text,
    );

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));

    if (result == 'Password berhasil diperbarui') {
      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
      setState(() {
        _isPasswordSectionVisible = false;
      });
    }
  }

  // Update Profile Photo
  Future<void> _updateProfilePhoto() async {
    if (_profileImage == null) return;

    setState(() {
      _isLoading = true;
    });

    final result = await ProfileService().updateProfilePhoto(_profileImage!.path);

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));

    if (result == 'Foto profil berhasil diperbarui') {
      _loadUserData(); // Reload user data after photo update
    }
  }

  // Load user data (for the avatar, name, and username)
  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _avatarUrl = prefs.getString('avatarUrl') ?? '';
      _nama = prefs.getString('nama') ?? 'Your Name';
      _username = prefs.getString('username') ?? 'Username';
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
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
                      icon: const Icon(Icons.exit_to_app, size: 30, color: Colors.red),
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
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
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
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
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
                            _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _updatePassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 22, 126, 211),
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        ),
                        child: Text('Okay', style: GoogleFonts.poppins(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 10),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UploadKompetensi()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.file_upload),
                      const SizedBox(width: 25),
                      Text('Upload Kompetensi', style: GoogleFonts.poppins()),
                    ],
                  ),
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
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
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

  // Helper function for password input field
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
            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: toggleVisibility,
        ),
        border: const OutlineInputBorder(),
      ),
    );
  }
}

class ProfileService {
  Future<String> updatePassword(
      String oldPassword, String newPassword, String confirmPassword) async {
    // Implement your password update logic here (e.g., API call)
    await Future.delayed(const Duration(seconds: 1));
    return 'Password berhasil diperbarui';
  }

  Future<String> updateProfilePhoto(String photoPath) async {
    // Implement your photo update logic here (e.g., API call)
    await Future.delayed(const Duration(seconds: 1));
    return 'Foto profil berhasil diperbarui';
  }
}