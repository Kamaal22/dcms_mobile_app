// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:dcms_mobile_app/appointments.dart';
import 'package:dcms_mobile_app/appt_modal.dart';
import 'package:dcms_mobile_app/assets/colors.dart';
import 'package:dcms_mobile_app/dental_record.dart';
import 'package:dcms_mobile_app/profile.dart';
import 'package:dcms_mobile_app/home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    AppointmentModel(),
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
            icon: FaIcon(FontAwesomeIcons.house, size: 22),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            tooltip: "Apppoinments",
            icon: FaIcon(FontAwesomeIcons.calendar, size: 22),
            label: 'Apppoinments',
          ),
          BottomNavigationBarItem(
            tooltip: "Apppoinment",
            icon: FaIcon(FontAwesomeIcons.plus, size: 22),
            label: 'Add Apppoinment',
          ),
          BottomNavigationBarItem(
            tooltip: "Medical Record",
            icon: FaIcon(FontAwesomeIcons.fileMedical, size: 22),
            label: 'Medical records',
          ),
          BottomNavigationBarItem(
            tooltip: "Profile",
            icon: FaIcon(FontAwesomeIcons.circleUser, size: 22),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
