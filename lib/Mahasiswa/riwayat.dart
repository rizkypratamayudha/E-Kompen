import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bottombar/bottombar.dart'; // Import BottomNavBar
import 'profile.dart';
import 'pekerjaan.dart';
import '../mahasiswa.dart';

class RiwayatPage extends StatefulWidget {
  @override
  _RiwayatPageState createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
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
Widget build(BuildContext context) {
  return MaterialApp(
    debugShowCheckedModeBanner: false, // Menyembunyikan banner "Debug"
    theme: ThemeData(
      textTheme: GoogleFonts.poppinsTextTheme(
        Theme.of(context).textTheme,
      ),
    ),
    home: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // Warna putih untuk background app bar
        title: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 60.0, 20.0, 40.0),
          child: Text('Riwayat',
          style: GoogleFonts.poppins(fontSize: 22),
          ),
        ),
      ),
      backgroundColor: Colors.white, // Menambahkan warna putih untuk background body
      body: RiwayatScreen(),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    ),
  );
}

}

class RiwayatScreen extends StatefulWidget {
  @override
  _RiwayatScreenState createState() => _RiwayatScreenState();
}
class _RiwayatScreenState extends State<RiwayatScreen> {
  PageController _pageController = PageController(initialPage: 0);
  int _selectedIndex = 0;

  // Contoh data
  List<String> prosesItems = ['Memasukkan Nilai'];
  List<String> selesaiItems = ['Pembuatan Web'];
  List<Map<String, dynamic>> ttdKaprodiItems = [
    {'title': 'Pembuatan Mobile', 'isApproved': true},
    {'title': 'Pembelian AC', 'isApproved': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20),
    child:  Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TabButton(
                icon: Icons.access_time, // Ikon jam untuk 'Proses'
                text: "Proses",
                isSelected: _selectedIndex == 0,
                onTap: () {
                  setState(() {
                    _selectedIndex = 0;
                  });
                  _pageController.animateToPage(0,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut);
                },
              ),
            ),
            Expanded(
              child: TabButton(
                icon: Icons.check_circle_outline, // Ikon ceklis untuk 'Telah Selesai'
                text: "Telah Selesai",
                isSelected: _selectedIndex == 1,
                onTap: () {
                  setState(() {
                    _selectedIndex = 1;
                  });
                  _pageController.animateToPage(1,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut);
                },
              ),
            ),
            Expanded(
              child: TabButton(
                icon: Icons.edit, // Ikon tanda tangan untuk 'TTD Kaprodi'
                text: "TTD Kaprodi",
                isSelected: _selectedIndex == 2,
                onTap: () {
                  setState(() {
                    _selectedIndex = 2;
                  });
                  _pageController.animateToPage(2,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Expanded(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            children: [
              _buildRiwayatList(context, prosesItems), // Menampilkan semua item di kategori Proses
              _buildRiwayatList(context, selesaiItems), // Menampilkan semua item di kategori Telah Selesai
              _buildTTDKaprodiList(context, ttdKaprodiItems), // Menampilkan semua item di kategori TTD Kaprodi
            ],
          ),
        ),
      ],
    )
    );
  }

  // Fungsi untuk membangun daftar riwayat untuk tiap kategori
  Widget _buildRiwayatList(BuildContext context, List<String> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return _buildRiwayat(context, items[index]);
      },
    );
  }

  // Fungsi untuk membangun satu item riwayat
  Widget _buildRiwayat(BuildContext context, String title) {
    return Align(
      alignment: Alignment.topCenter,
      child: FractionallySizedBox(
        widthFactor: 0.9,
        child: Card(
          color: Colors.blue,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: ListTile(
              title: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              onTap: () {
                if (title == 'Memasukkan Nilai') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PengumpulanBuktiPage()),
                  );
                } else if (title == 'Pembuatan Web') {
                  _showWebPopup(context);
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  // Fungsi untuk membangun daftar TTD Kaprodi untuk tiap kategori
  Widget _buildTTDKaprodiList(BuildContext context, List<Map<String, dynamic>> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        String title = items[index]['title'];
        bool isApproved = items[index]['isApproved'];
        return _buildTTDKaprodi(context, title, isApproved);
      },
    );
  }

  // Fungsi untuk membangun satu item TTD Kaprodi
  Widget _buildTTDKaprodi(BuildContext context, String title, bool isApproved) {
    return Align(
      alignment: Alignment.topCenter,
      child: FractionallySizedBox(
        widthFactor: 0.9,
        child: Card(
          color: Colors.blue,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: ListTile(
              title: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              trailing: Icon(
                Icons.circle,
                color: isApproved ? Colors.green : Colors.white, // Hijau jika disetujui, putih jika tidak
                size: 16, // Ukuran lingkaran
              ),
              onTap: () {
                if (title == 'Pembuatan Mobile') {
                  _showMobilePopup(context);
                } 
              },
            ),
          ),
        ),
      ),
    );
  }
}


class TabButton extends StatelessWidget {
  final IconData icon; // Tambahkan parameter ikon
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const TabButton({
    required this.icon, // Parameter ikon harus disertakan
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
            color: isSelected ? Colors.blue : Colors.transparent,
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(10)),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Colors.white
                  : Colors.black, // Ubah warna ikon sesuai kondisi isSelected
            ),
            SizedBox(width: 6), // Jarak antara ikon dan teks
            Text(
              text,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PengumpulanBuktiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pengumpulan Bukti Pekerjaan',
          style: GoogleFonts.poppins(fontSize: 20, color: Colors.black),
        ),
        backgroundColor: Colors.white, // Warna AppBar putih
        elevation: 0, // Menghilangkan bayangan AppBar
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black), // Tombol back dengan ikon hitam
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: Colors.white, // Warna background body putih
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tugas : Memasukkan Nilai',
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.black),
            ),
            SizedBox(height: 10),
            Text(
              'Batas pengerjaan : 2024-10-30',
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.black),
            ),
            SizedBox(height: 10),
            Text(
              'Jumlah jam : 100 jam',
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.black),
            ),
            SizedBox(height: 20),
            Text(
              'Foto bukti :',
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.black),
            ),
            SizedBox(height: 10),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[100], // Warna latar belakang abu muda
                borderRadius: BorderRadius.circular(10), // Menambahkan border radius
              ),
              child: Center(
                child: Icon(Icons.image, size: 50, color: Colors.grey),
              ),
            ),
            SizedBox(height: 200),
            SizedBox(
              width: double.infinity, // Lebar tombol memenuhi layar
              child: ElevatedButton(
                onPressed: () {
                  // Tambahkan logika untuk mengunggah bukti atau mengambil foto
                },
                child: Text(
                  '+ Tambah / buat',
                  style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Warna tombol biru
                  padding: EdgeInsets.symmetric(vertical: 16),
                  textStyle: GoogleFonts.poppins(fontSize: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Border radius 10
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _showWebPopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Container(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nama Dosen : Taufiq S.Tr S.I.B', style: GoogleFonts.poppins(fontSize: 14)),
              SizedBox(height: 8),
              Text('Nomor Dosen : 083166441802', style: GoogleFonts.poppins(fontSize: 14)),
              SizedBox(height: 8),
              Text('Jumlah Jam : 100 Jam', style: GoogleFonts.poppins(fontSize: 14)),
              SizedBox(height: 8),
              Text('Persyaratan : Bisa Coding', style: GoogleFonts.poppins(fontSize: 14)),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(8),
                color: Colors.grey[200],
                child: Text(
                  'Deskripsi Pekerjaan :\n\nMembantu web Sederhana untuk Pelaporan Jumlah Komputer yang Tidak layak pakai Yang terdiri dari 5 Mahasiswa',
                  style: GoogleFonts.poppins(fontSize: 12),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Tutup dialog
                  },
                  child: Text('Request TTD Kaprodi', style: GoogleFonts.poppins(fontSize: 14, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

void _showMobilePopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Container(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nama Dosen : Taufiq S.Tr S.I.B', style: GoogleFonts.poppins(fontSize: 14)),
              SizedBox(height: 8),
              Text('Nomor Dosen : 083166441802', style: GoogleFonts.poppins(fontSize: 14)),
              SizedBox(height: 8),
              Text('Jumlah Jam : 100 Jam', style: GoogleFonts.poppins(fontSize: 14)),
              SizedBox(height: 8),
              Text('Persyaratan : Bisa Coding', style: GoogleFonts.poppins(fontSize: 14)),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(8),
                color: Colors.grey[200],
                child: Text(
                  'Deskripsi Pekerjaan :\n\nMembantu Mobile Sederhana untuk Pelaporan Jumlah Komputer yang Tidak layak pakai Yang terdiri dari 5 Mahasiswa',
                  style: GoogleFonts.poppins(fontSize: 12),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Tutup dialog
                  },
                  child: Text('Cetak Bukti Surat', style: GoogleFonts.poppins(fontSize: 14, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}



