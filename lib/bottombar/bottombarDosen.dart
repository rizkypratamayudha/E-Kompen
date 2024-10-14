// bottom_navbar.dart
import 'package:flutter/material.dart';

class BottomNavBarDosen extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const BottomNavBarDosen({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed, // Gunakan shifting untuk efek pergerakan ikon
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
          backgroundColor: Colors.white, // Warna background untuk item Home
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment_add),
          label: 'Tugas',
          backgroundColor: Colors.white, // Warna background untuk item Tugas
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.edit_document),
          label: 'Penerimaan',
          backgroundColor: Colors.white, // Warna background untuk item History
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: 'Profile',
          backgroundColor: Colors.white, // Warna background untuk item Profile
        ),
      ],
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      selectedItemColor: Colors.blue, // Warna ikon yang dipilih
      unselectedItemColor: Colors.grey, // Warna ikon yang tidak dipilih
    );
  }
}
