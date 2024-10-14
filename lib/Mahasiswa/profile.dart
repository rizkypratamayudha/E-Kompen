import 'package:firstapp/Mahasiswa/upload_kompetensi.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bottombar/bottombar.dart'; 
import 'riwayat.dart';
import 'pekerjaan.dart';
import '../mahasiswa.dart';
import '../widget/popup_logout.dart'; 

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isPasswordSectionVisible = false;
  bool _isOldPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  int _selectedIndex = 3;

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
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.person, size: 40),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'M. Isroqi Gelby',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '2241760020',
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
                        // Panggil PopupLogout OOP ketika ikon logout ditekan
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
                        onPressed: () {
                        },
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
                SizedBox(height: 10,),
                InkWell(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UploadKompetensi()
                      )
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 15),
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.edit_document,
                        ),
                        SizedBox(width: 25,),
                        Text(
                          'Upload Kompetensi',
                            style: GoogleFonts.poppins(),
                        )
                      ],
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      backgroundColor: Colors.white,
    );
  }

  Widget buildPasswordField({
    required String label,
    required bool isPasswordVisible,
    required VoidCallback toggleVisibility,
  }) {
    return TextField(
      obscureText: !isPasswordVisible,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: IconButton(
          icon: Icon(
            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: toggleVisibility,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
