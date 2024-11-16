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
import 'kompetensi.dart';
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
  String _avatarUrl = '';
  String _nama = 'Your Name';
  String _username = 'Username';

  // Bottom Navigation Bar
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate based on the selected index
    switch (index) {
      case 0:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const MahasiswaDashboard()));
        break;
      case 1:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const PekerjaanPage()));
        break;
      case 2:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const RiwayatPage()));
        break;
      case 3:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const ProfilePage()));
        break;
    }
  }

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
      _loadUserData();
    }
  }

  // Load user data
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
                        Text(_nama, style: GoogleFonts.poppins(fontSize: 18, color: Colors.white)),
                        Text(_username,
                            style: GoogleFonts.poppins(fontSize: 16, color: Colors.white)),
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
              buildSection('Ganti Password', Icons.vpn_key, () {
                setState(() {
                  _isPasswordSectionVisible = !_isPasswordSectionVisible;
                });
              }),
              if (_isPasswordSectionVisible)
                buildPasswordForm(),
              buildSection('Daftar Kompetensi Mahasiswa', Icons.person_search, () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const KompetensiMahasiswaPage()));
              }),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  // Helper methods
  Widget buildSection(String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 25),
            Text(title, style: GoogleFonts.poppins()),
          ],
        ),
      ),
    );
  }

  Widget buildPasswordForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Column(
        children: [
          buildPasswordField('Password Lama', _currentPasswordController),
          buildPasswordField('Password Baru', _newPasswordController),
          buildPasswordField('Verifikasi Password Baru', _confirmPasswordController),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _updatePassword,
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 22, 126, 211)),
            child: Text('Okay', style: GoogleFonts.poppins(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget buildPasswordField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}

class ProfileService {
  Future<String> updatePassword(String oldPassword, String newPassword, String confirmPassword) async {
    await Future.delayed(const Duration(seconds: 1));
    return 'Password berhasil diperbarui';
  }

  Future<String> updateProfilePhoto(String photoPath) async {
    await Future.delayed(const Duration(seconds: 1));
    return 'Foto profil berhasil diperbarui';
  }
}
