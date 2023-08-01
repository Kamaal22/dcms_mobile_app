import 'dart:async';
import 'dart:convert';
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

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late String ipAddress;
  final String apiUrl = '/DCMS/app/mobile/login/login.php';
  bool isLoading = false;

  Future<void> login() async {
    setState(() {
      isLoading = true;
    });

    final response = await http.post(Uri.http(ipAddress, apiUrl), body: {
      'username': usernameController.text,
      'password': passwordController.text,
    });

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final status = jsonData['status'];
      final data = jsonData['data'];
      print(jsonData);

      if (status == 'success' && data != null) {
        // Save the response data in SharedPreferences
        await saveResponseInSharedPreferences(data);

        // Show the success animation
        await showSuccessAnimation();

        navigateToIndexPage();
      } else {
        showSnackBar('Invalid username or password.');

        // Retry login after 3 seconds
        Timer(Duration(seconds: 1), () {
          setState(() {
            isLoading = false;
          });
        });
      }
    } else {
      showSnackBar('An error occurred during login.');

      // Retry login after 3 seconds
      Timer(Duration(seconds: 1), () {
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  Future<void> showSuccessAnimation() async {
    final controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    controller.forward();

    await Future.delayed(Duration(milliseconds: 500));
    controller.dispose();
  }

  Future<void> saveResponseInSharedPreferences(
      Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('patient_id', data['patient_id']);
    prefs.setString('first_name', data['first_name']);
    prefs.setString('middle_name', data['middle_name']);
    prefs.setString('last_name', data['last_name']);
    prefs.setString('birth_date', data['birth_date']);
    prefs.setString('gender', data['gender']);
    prefs.setString('phone_number', data['phone_number']);
    prefs.setString('address', data['address']);
  }

  void navigateToIndexPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => IndexPage()),
    );
  }

  void showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void initState() {
    super.initState();
    ipAddress = '192.168.39.163'; // Set the initial IP address here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                      style: GoogleFonts.poppins(
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
                        "Emarites",
                        style: GoogleFonts.cinzel(
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
                style: GoogleFonts.poppins(fontSize: 24),
              ),
              SizedBox(height: 50),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    hintText: 'Enter your Denta username',
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    hintText: 'Enter your Denta Password',
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(MediaQuery.of(context).size.width, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  onPressed: isLoading ? null : login,
                  child: Center(
                    child: isLoading
                        ? CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.amber,
                            backgroundColor: Colors.amber[900],
                          ) // Show the loading circle while the request is ongoing
                        : Text(
                            "Sign In",
                            style: GoogleFonts.poppins(
                              fontSize: 28,
                              color: Colors.white,
                              // fontWeight: FontWeight.bold,
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
