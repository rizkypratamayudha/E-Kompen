
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bottombar/bottombar.dart';
import 'profile.dart';
import 'riwayat.dart';
import '../mahasiswa.dart';
import '../widget/popup_pekerjaan_mhs.dart';
import '../widget/tag.dart';
import '../widget/tag_kompetensi.dart';

class PekerjaanPage extends StatefulWidget {
  const PekerjaanPage({super.key});

  @override
  _PekerjaanPageState createState() => _PekerjaanPageState();
}

class _PekerjaanPageState extends State<PekerjaanPage> {
  int _selectedIndex = 1;

  Route _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0); // Slide dari kanan ke kiri
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
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

    if (index == 1) {
      return;
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => RiwayatPage()),
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
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 50.0, 20.0, 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pekerjaan',
                style: GoogleFonts.poppins(
                    fontSize: 22, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 20),
              _buildseacrh(),
              const SizedBox(
                height: 20,
              ),
              _buildPekerjaan('Pembuatan Web', '2/5'),
              _buildPekerjaan('Memasukkan Nilai', '0/2'),
              _buildPekerjaan('Pembelian AC', '2/5'),
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

  Widget _buildPekerjaan(String title, String anggota) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w300,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.person,
              color: Colors.white,
            ),
            const SizedBox(width: 5),
            Text(
              anggota,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ],
        ),
        onTap: () {
          // Tampilkan popup ketika item diklik
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const PopUpPekerjaan(); // Memanggil popup yang sudah dibuat
            },
          );
        },
      ),
    );
  }

  void _showlist() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      builder: (context) {
        return Container(
          constraints: BoxConstraints(
            minWidth:
                MediaQuery.of(context).size.width, // 50% dari tinggi layar
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Jenis Tugas',
                style: GoogleFonts.poppins(),
              ),
              const SizedBox(height: 16),
              Tag(),
              const SizedBox(height: 16),
              Text(
                'List Kompetensi',
                style: GoogleFonts.poppins(),
              ),
              const SizedBox(height:16 ,),
              TagKompetensi(),
              const SizedBox(height : 16),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => PekerjaanPage())
                    //   );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    ),
                    
                  ),
                  child: Text('Simpan', style: GoogleFonts.poppins(color: Colors.white),),
                )
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildseacrh() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: TextFormField(
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.search,
            ),
            hintText: 'Cari Pekerjaan',
            hintStyle: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.black38,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.transparent,
          ),
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.black,
          ),
          onChanged: (value) {
            
            print('Judul pekerjaan: $value');
          },
        ),
      ),
      SizedBox(width: 10,),
      Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(3),
        child: IconButton(
          onPressed: () => _showlist(),
          icon: const Icon(
            Icons.filter_list_rounded,
            color: Colors.black, // Warna ikon
          ),
        ),
      ),
    ],
  );
}


}
