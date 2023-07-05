import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'index.dart';
import 'login/login.dart';

class Index extends StatefulWidget {
  Index({Key? key}) : super(key: key);

  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {
  @override
  void initState() {
    super.initState();
    // Timer to show the splash screen for 2 seconds.
    Timer(Duration(seconds: 2), () {
      checkLoginStatus();
    });
  }

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
      navigateToPage(IndexPage());
    } else {
      // Data is not available in shared preferences
      print('No data found in shared preferences.');
      navigateToPage(LoginPage());
    }
  }

  void navigateToPage(Widget page) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/ic_launcher.png'),
      ),
    );
  }
}
