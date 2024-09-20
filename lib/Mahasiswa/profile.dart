import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isPasswordSectionVisible = false;
  bool _isOldPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView( // Wrap everything with SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.blue[800], // Blue background
                padding: const EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 30.0),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 30, // Ukuran avatar sesuai permintaan
                      backgroundColor: Colors.grey, // Warna background abu-abu
                      child: Icon(Icons.person, size: 40), // Ikon orang
                    ),
                    const SizedBox(width: 10), // Jarak antara avatar dan teks
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'M. Isroqi Gelby',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: Colors.white, // White text on blue background
                          ),
                        ),
                        Text(
                          '2241760020',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.white, // White text for the ID
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.exit_to_app,
                          size: 30, color: Colors.red), // Larger logout icon
                      onPressed: () {
                        // Tambahkan fungsi logout di sini
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60), // Jarak sebelum bagian Ganti Password
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isPasswordSectionVisible = !_isPasswordSectionVisible;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                  margin: const EdgeInsets.symmetric(horizontal: 10), // Margin to adjust positioning
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
                          const SizedBox(width: 30),
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
                        onPressed: () {
                          // Tambahkan fungsi simpan password di sini
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 22, 126, 211),
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        ),
                        child: Text('Okay', style: GoogleFonts.poppins(color: Colors.white)),
                      ),
                    ],
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
