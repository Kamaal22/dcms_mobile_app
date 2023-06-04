import 'dart:convert';

import 'package:dcms_mobile_app/assets/colors.dart';
import 'package:dcms_mobile_app/assets/component.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../index.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkAuth();
  }

  void checkAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    final username = prefs.getString('username');
    final password = prefs.getString('password');

    if (userId != null && username != null && password != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => IndexPage()),
      );
    }
  }

  Future<void> login() async {
    final url =
        Uri.parse('http://192.168.1.10/DCMS/app/mobile/login/login.php');
    try {
      final response = await http.post(url, body: {
        'username': usernameController.text,
        'password': passwordController.text,
      });

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final message = jsonData['message'];
        final data = jsonData['data'];

        if (message == 'success' && data != null) {
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('user_id', data['user_id']);
          prefs.setString('username', data['username']);
          prefs.setString('password', data['password']);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => IndexPage()),
          );
        } else {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Login Error',
                  style: GoogleFonts.nunito(fontWeight: bold)),
              content: Text('Invalid username or password.',
                  style: GoogleFonts.nunito()),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child:
                      Text('OK', style: GoogleFonts.nunito(fontWeight: bold)),
                ),
              ],
            ),
          );
        }
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Login Error'),
            content: Text('An error occurred during login.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      // Handle the exception
      print('Error occurred during login: $e');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Login Error'),
          content: Text('An error occurred during login.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
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
              Row(
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
              ),
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
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  padding: MP_all(20),
                  decoration: radius(12, primary, transparent),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: login,
                      child: Text(
                        "Sign In",
                        style: GoogleFonts.nunito(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
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
