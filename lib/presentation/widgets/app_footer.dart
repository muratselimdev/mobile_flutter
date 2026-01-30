import 'package:flutter/material.dart';

class AppFooter extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppFooter({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF16A34A),
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_filled),
          label: 'One Clinic',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Ara'),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month),
          label: 'Randevular',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Profil',
        ),
      ],
    );
  }
}
