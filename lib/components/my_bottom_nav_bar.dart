import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MyBottomNavBar extends StatelessWidget {
  final void Function(int)? onTabChange;
  const MyBottomNavBar({super.key, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: GNav(
        onTabChange: (value) => onTabChange!(value),
        tabs: [
          GButton(icon: Icons.home, text: 'Home'),
          GButton(icon: Icons.food_bank_outlined, text: 'Category'),
          GButton(icon: Icons.person, text: 'Account'),
        ],
        tabBorderRadius: 16,
      ),
    );
  }
}
