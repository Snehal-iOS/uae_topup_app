import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../beneficiary/presentation/screens/manage_beneficiaries_screen.dart';
import '../../user/presentation/screens/profile_screen.dart';
import 'home_screen.dart';

class MainBottomNavigationBarScreen extends StatefulWidget {
  const MainBottomNavigationBarScreen({super.key});

  @override
  State<MainBottomNavigationBarScreen> createState() => _MainBottomNavigationBarScreenState();
}

class _MainBottomNavigationBarScreenState extends State<MainBottomNavigationBarScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(onNavigateToManageBeneficiaries: () => setState(() => _currentIndex = 1)),
      const ManageBeneficiariesScreen(),
      const ProfileScreen(),
    ];
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: AppStrings.navHome,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: AppStrings.navManageBeneficiaries,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: AppStrings.navProfile,
          ),
        ],
      ),
    );
  }
}
