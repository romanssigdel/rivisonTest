import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rivison_again/view/home.dart';
import 'package:flutter_rivison_again/view/students_info.dart';
import 'package:flutter_rivison_again/utils/color%20_const.dart';
import 'package:flutter_rivison_again/view/user_account.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({super.key});

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  List<Widget> itemList = [
    HomePage(),
    UserAccount(),
  ];
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: itemList[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
          onTap: (value) {
            selectedIndex = value;
            setState(() {
              selectedIndex;
            });
          },
          currentIndex: selectedIndex,
          selectedItemColor: buttonBackgroundClr,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile")
          ]),
    );
  }
}
