// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:dcms_mobile_app/appointments.dart';
import 'package:dcms_mobile_app/assets/colors.dart';
import 'package:dcms_mobile_app/dental_record.dart';
import 'package:dcms_mobile_app/profile.dart';
import 'package:dcms_mobile_app/home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  void readDataFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    final userId = prefs.getString('user_id');
    final username = prefs.getString('username');
    final password = prefs.getString('password');

    if (userId != null && username != null && password != null) {
      // Data is available in shared preferences
      print('User ID: $userId');
      print('Username: $username');
      print('Password: $password');
    } else {
      // Data is not available in shared preferences
      print('No data found in shared preferences.');
    }
  }

  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    AppointmentPage(),
    DentalRecord(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(children: _pages, index: _currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: white,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        selectedItemColor: primary,
        unselectedItemColor: grey400,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            tooltip: "Home",
            icon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            tooltip: "Apppoinment",
            icon: Icon(Icons.date_range),
            label: 'Apppoinment',
          ),
          BottomNavigationBarItem(
            tooltip: "Medical Record",
            icon: Icon(Icons.receipt_long_rounded),
            label: 'Medical records',
          ),
          BottomNavigationBarItem(
            tooltip: "Profile",
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
