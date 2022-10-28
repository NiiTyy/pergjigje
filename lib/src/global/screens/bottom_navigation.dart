import 'package:flutter/material.dart';
import 'package:pergjigje/src/features/categories/screens/categories_screen.dart';
import 'package:pergjigje/src/features/search/screens/search_screen.dart';
import 'package:pergjigje/src/global/constants/colors.dart';

import '../../features/dashboard/screens/home_screen.dart';

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({Key? key}) : super(key: key);

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigationScreen> {
  int _selectedIndex = 1;
  final screens = [
    SearchScreen(),
    const HomeScreen(),
    const CategoriesScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 35,
        elevation: 0,
        selectedIconTheme: IconThemeData(
          color: AppColors.progresIndicatorColor,
        ),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Kërko',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Ballina',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Kategoritë',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xff1c5bc7),
        onTap: _onItemTapped,
      ),
    );
  }
}
