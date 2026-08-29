import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/constants/app_colors.dart';
import '../../data/services/app_update_service.dart';
import '../widgets/force_update_dialog.dart';
import 'home_screen.dart';
import 'search_screen.dart';
import 'downloads_screen.dart';
import 'profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    SearchScreen(),
    DownloadsScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _checkAppUpdate();
  }

  Future<void> _checkAppUpdate() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final updateInfo = await AppUpdateService.checkForUpdates();
      if (updateInfo != null && updateInfo.hasUpdate && mounted) {
        ForceUpdateDialog.show(context, updateInfo);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.home),
            activeIcon: Icon(LucideIcons.home, color: AppColors.textPrimary),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.search),
            activeIcon: Icon(LucideIcons.search, color: AppColors.textPrimary),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.download),
            activeIcon: Icon(LucideIcons.download, color: AppColors.textPrimary),
            label: 'Downloads',
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.user),
            activeIcon: Icon(LucideIcons.user, color: AppColors.textPrimary),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
