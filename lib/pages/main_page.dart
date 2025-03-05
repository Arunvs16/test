import 'package:flutter/material.dart';
import 'package:test_app/components/my_bottom_nav_bar.dart';
import 'package:test_app/pages/category_page.dart';
import 'package:test_app/pages/home_page.dart';
import 'package:test_app/pages/profile_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  void navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [HomePage(), CategoryPage(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: MyBottomNavBar(
        currentIndex: _selectedIndex,
        onTabChange: navigateBottomBar,
      ),
      body: _pages[_selectedIndex],
    );
  }
}
