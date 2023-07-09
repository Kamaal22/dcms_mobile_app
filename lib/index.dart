// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:dcms_mobile_app/appointments.dart';
import 'package:dcms_mobile_app/appt_modal.dart';
import 'package:dcms_mobile_app/assets/colors.dart';
import 'package:dcms_mobile_app/assets/component.dart';
import 'package:dcms_mobile_app/dental_record.dart';
import 'package:dcms_mobile_app/profile.dart';
import 'package:dcms_mobile_app/home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'login/login.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
// Color variables
  final Color gradientStartColor = Color.fromRGBO(236, 239, 241, 1);
  final Color gradientEndColor = Color.fromRGBO(207, 216, 220, 1);
  final Color? selectedIconColor = Colors.blue[700];
  final Color? unselectedIconColor = Colors.blue[300];
  final Color? selectedIconBackgroundColor = Colors.blue[50];

  void checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    final username = prefs.getString('username');
    final password = prefs.getString('password');

    if (userId != null && username != null && password != null) {
      // Data is available in shared preferences
      print('User ID: $userId');
      print('Username: $username');
      print('Password: $password');
      // navigateToPage(IndexPage());
    } else {
      // Data is not available in shared preferences
      print('No data found in shared preferences.');
      toPage(context, LoginPage());
    }
  }

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

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
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
      bottomNavigationBar: Container(
        color: Colors.transparent,
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          selectedItemColor: selectedIconColor,
          unselectedItemColor: unselectedIconColor,
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
              icon: _currentIndex == 0
                  ? Ink(
                      height: 40,
                      width: 40,
                      decoration: ShapeDecoration(
                        color: selectedIconBackgroundColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      child: Center(
                        child: FaIcon(
                          FontAwesomeIcons.house,
                          size: 22,
                          color: selectedIconColor,
                        ),
                      ),
                    )
                  : FaIcon(
                      FontAwesomeIcons.house,
                      size: 22,
                    ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              tooltip: "Appointments",
              icon: _currentIndex == 1
                  ? Ink(
                      height: 40,
                      width: 40,
                      decoration: ShapeDecoration(
                        color: selectedIconBackgroundColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      child: Center(
                        child: FaIcon(
                          FontAwesomeIcons.calendar,
                          size: 22,
                          color: selectedIconColor,
                        ),
                      ),
                    )
                  : FaIcon(
                      FontAwesomeIcons.calendar,
                      size: 22,
                    ),
              label: 'Appointments',
            ),
            BottomNavigationBarItem(
              tooltip: "Appointment",
              icon: _currentIndex == 2
                  ? Ink(
                      height: 40,
                      width: 40,
                      decoration: ShapeDecoration(
                        color: selectedIconBackgroundColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      child: Center(
                        child: FaIcon(
                          FontAwesomeIcons.plus,
                          size: 22,
                          color: selectedIconColor,
                        ),
                      ),
                    )
                  : FaIcon(
                      FontAwesomeIcons.plus,
                      size: 22,
                    ),
              label: 'Add Appointment',
            ),
            BottomNavigationBarItem(
              tooltip: "Medical Record",
              icon: _currentIndex == 3
                  ? Ink(
                      height: 40,
                      width: 40,
                      decoration: ShapeDecoration(
                        color: selectedIconBackgroundColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      child: Center(
                        child: FaIcon(
                          FontAwesomeIcons.fileMedical,
                          size: 22,
                          color: selectedIconColor,
                        ),
                      ),
                    )
                  : FaIcon(
                      FontAwesomeIcons.fileMedical,
                      size: 22,
                    ),
              label: 'Medical records',
            ),
            BottomNavigationBarItem(
              tooltip: "Profile",
              icon: _currentIndex == 4
                  ? Ink(
                      height: 40,
                      width: 40,
                      decoration: ShapeDecoration(
                        color: selectedIconBackgroundColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      child: Center(
                        child: FaIcon(
                          FontAwesomeIcons.circleUser,
                          size: 22,
                          color: selectedIconColor,
                        ),
                      ),
                    )
                  : FaIcon(
                      FontAwesomeIcons.circleUser,
                      size: 22,
                    ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
