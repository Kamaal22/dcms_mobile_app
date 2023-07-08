import 'dart:convert';
import 'dart:io';
import 'package:dcms_mobile_app/assets/colors.dart';
import 'package:dcms_mobile_app/assets/component.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:path/path.dart' as path;

import '../index.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final String apiUrl =
      'http://192.168.170.163/DCMS/app/mobile/login/login.php';

  Future<void> login() async {
    final response = await http.post(Uri.parse(apiUrl), body: {
      'username': usernameController.text,
      'password': passwordController.text,
    });
    final prefs = await SharedPreferences.getInstance();

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final message = jsonData['message'];
      final data = jsonData['data'];
      print(jsonData);
      if (message == 'success' && data != null) {
        prefs.setString('user_id', data['user_id']);
        prefs.setString('username', data['username']);
        prefs.setString('password', data['password']);
        prefs.setString('firstname', data['firstname'] ?? "");
        prefs.setString('lastname', data['lastname'] ?? "");

        navigateToIndexPage();
      } else {
        showAlertDialog('Login Error', 'Invalid username or password.');
      }
    } else {
      showAlertDialog('Login Error', 'An error occurred during login.');
    }
  }

  void navigateToIndexPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => IndexPage()),
    );
  }

  void showAlertDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) {
        return Theme(
          data: ThemeData(
            dialogBackgroundColor: Colors.lightBlue[900],
          ),
          child: CupertinoAlertDialog(
            title: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Text(content),
            actions: [
              CupertinoDialogAction(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'OK',
                  style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey300,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Welcome to ",
                    style: GoogleFonts.nunito(
                        fontSize: 35, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding: MP_all(4),
                    decoration: radius(4, lightBlueAccent200, transparent),
                    child: Text(
                      "Denta",
                      style: GoogleFonts.nunito(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: white),
                    ),
                  ),
                ],
              )),
              SizedBox(height: 20),
              Text(
                "Best Dental in Somalia",
                style: GoogleFonts.nunito(fontSize: 24),
              ),
              SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: radius(14, grey200, white),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter your Denta username',
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: radius(14, grey200, white),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter your Denta Password',
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25.0, vertical: 5.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          20.0), // Set the border radius here
                    ),
                    elevation: 0.0, // Set the elevation here
                  ),
                  onPressed: login,
                  child: Center(
                    child: Text(
                      "Sign In",
                      style: GoogleFonts.nunito(
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
