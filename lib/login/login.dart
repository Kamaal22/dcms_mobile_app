import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  late String ipAddress;
  final String apiUrl = '/DCMS/app/mobile/login/login.php';

  Future<void> login() async {
    final response = await http.post(Uri.http(ipAddress, apiUrl), body: {
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
        prefs.setInt('user_id', data['user_id']);
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
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    ipAddress = '192.168.120.163'; // Set the initial IP address here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
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
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.lightBlueAccent[200],
                      ),
                      child: Text(
                        "Denta",
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Best Dental in Somalia",
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 50),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.grey[200],
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 20),
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
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.grey[200],
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 20),
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
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 0,
                  ),
                  onPressed: login,
                  child: Center(
                    child: Text(
                      "Sign In",
                      style: TextStyle(
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
