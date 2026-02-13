import 'package:flutter/material.dart';
import '../widgets/app_footer.dart';
import 'one_clinic_home_page.dart';
import 'one_clinic_profile_page.dart';
import '../localization/app_localizations.dart';

class MainTabPage extends StatefulWidget {
  final int initialIndex;

  const MainTabPage({super.key, this.initialIndex = 0});

  @override
  State<MainTabPage> createState() => _MainTabPageState();
}

class _MainTabPageState extends State<MainTabPage> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _changeTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      OneClinicHomePage(onTabChange: _changeTab),
      const _PlaceholderPage(titleKey: 'footer.search', icon: Icons.search),
      const _PlaceholderPage(
        titleKey: 'footer.appointments',
        icon: Icons.calendar_month,
      ),
      const OneClinicProfilePage(),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: AppFooter(
        currentIndex: _currentIndex,
        onTap: _changeTab,
      ),
    );
  }
}

class _PlaceholderPage extends StatelessWidget {
  final String titleKey;
  final IconData icon;

  const _PlaceholderPage({required this.titleKey, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.loc.t(titleKey),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: Colors.grey.withValues(alpha: 0.3)),
            const SizedBox(height: 16),
            Text(
              context.loc.t(titleKey),
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.withValues(alpha: 0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
