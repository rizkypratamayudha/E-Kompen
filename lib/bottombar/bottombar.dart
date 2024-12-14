import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;
  final int notificationCount; // New variable for notification count

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    this.notificationCount = 0, // Default value is 0
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed, 
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
          backgroundColor: Colors.white, 
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment_add),
          label: 'Pekerjaan',
          backgroundColor: Colors.white, 
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: 'History',
          backgroundColor: Colors.white, 
        ),
        BottomNavigationBarItem(
          icon: Stack(
            children: [
              Icon(Icons.account_circle),
              if (notificationCount > 0) 
                Positioned(
                  right: -1, 
                  top: 0,    
                  child: Container(
                    padding: const EdgeInsets.all(2), 
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: BoxConstraints(
                      minWidth: 12,   
                      minHeight: 12,  
                    ),
                    child: Text(
                      '$notificationCount',
                      style: TextStyle(
                        fontSize: 8,  
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          label: 'Profile',
          backgroundColor: Colors.white,
        ),
      ],
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      selectedItemColor: Colors.blue, 
      unselectedItemColor: Colors.grey, 
    );
  }
}
