import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';

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
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home_filled),
          label: context.loc.t('footer.home'),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.search),
          label: context.loc.t('footer.search'),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.calendar_month),
          label: context.loc.t('footer.appointments'),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.person_outline),
          label: context.loc.t('footer.profile'),
        ),
      ],
    );
  }
}
