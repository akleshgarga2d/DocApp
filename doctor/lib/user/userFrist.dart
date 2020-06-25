import 'dart:io';

import 'package:doctor/user/bottombarViews/patientScreen.dart';
import 'package:doctor/user/bottombarViews/userHome.dart';
import 'package:doctor/user/bottombarViews/userRequestScreen.dart';
import 'package:flutter/material.dart';
import 'package:doctor/style/colors.dart' as CustomColors;

class UserMainScreen extends StatefulWidget {
  @override
  _UserMainScreenState createState() => _UserMainScreenState();
}

class _UserMainScreenState extends State<UserMainScreen> {
  final List<Widget> bootmbarPages = [
    UserHomeScreen(
      key: PageStorageKey('Page1'),
    ),
    PatientScreen(
      key: PageStorageKey('Page2'),
    ),
    UserRequestScreen(
      key: PageStorageKey('Page4'),
    ),
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  int _selectedIndex = 0;

  Widget _bottomNavigationBar(int selectedIndex) => BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: CustomColors.Colors.white,
        selectedItemColor: CustomColors.Colors.primaryColor,
        unselectedItemColor: Colors.black45,
        selectedFontSize: 12.0,
        unselectedFontSize: 12.0,
        elevation: 16.0,
        iconSize: 25.0,
        onTap: (int index) => setState(() => _selectedIndex = index),
        currentIndex: selectedIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Home')),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_add), title: Text('Patients')),
          BottomNavigationBarItem(
              icon: Icon(Icons.refresh), title: Text('Requests')),
        ],
      );
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        exit(0);
        return true;
      },
      child: Scaffold(
        appBar: null,
        bottomNavigationBar: _bottomNavigationBar(_selectedIndex),
        body: IndexedStack(
          index: _selectedIndex,
          children: bootmbarPages,
        ),
      ),
    );
  }
}
