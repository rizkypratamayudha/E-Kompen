import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RiwayatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // Menggunakan Google Fonts Poppins secara global
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(left: 20.0), // Geser teks ke kanan
            child: Text('Riwayat'),
          ),
        ),
        body: RiwayatScreen(),
        
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Tab indicator di bagian atas
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TabButton(
              text: "Proses",
              isSelected: _pageController.hasClients && (_pageController.page == 0 || _pageController.page == null),
              onTap: () => _pageController.animateToPage(0,
                  duration: Duration(milliseconds: 300), curve: Curves.easeInOut),
            ),
            TabButton(
              text: "Telah Selesai",
              isSelected: _pageController.hasClients && _pageController.page == 1,
              onTap: () => _pageController.animateToPage(1,
                  duration: Duration(milliseconds: 300), curve: Curves.easeInOut),
            ),
            TabButton(
              text: "TTD Kaprodi",
              isSelected: _pageController.hasClients && _pageController.page == 2,
              onTap: () => _pageController.animateToPage(2,
                  duration: Duration(milliseconds: 300), curve: Curves.easeInOut),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Expanded(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {});
            },
            children: [
              _buildRiwayat('Memasukkan Nilai'),

              // Halaman 2: Telah Selesai
              _buildRiwayat('Pembuatan Nilai'),
              // Halaman 3: TTD Kaprodi
              Center(
                child: Text('Halaman TTD Kaprodi'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class TabButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const TabButton({
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.blue : Colors.black,
            ),
          ),
          SizedBox(height: 4),
          if (isSelected)
            Container(
              width: 30,
              height: 3,
              color: Colors.blue,
            ),
        ],
      ),
    );
  }
}

  Widget _buildRiwayat(String title) {
  return Align(
    alignment: Alignment.topCenter, // Menyelaraskan box ke atas tengah
    child: FractionallySizedBox(
      widthFactor: 0.9,
      child: Card(
        color: Colors.blue,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5), // Padding diseluruh sisi
          child: ListTile(
            title: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

