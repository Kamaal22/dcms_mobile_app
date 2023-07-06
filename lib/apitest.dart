// ignore_for_file: prefer_const_declarations, library_private_types_in_public_api, prefer_const_constructors, use_build_context_synchronously, prefer_interpolation_to_compose_strings, avoid_print

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> loginUser() async {
    final String apiUrl = 'http://192.168.101.163/apitest.php';
    final response = await http.post(Uri.parse(apiUrl), body: {
      'email': emailController.text,
      'password': passwordController.text,
    });

    final res = json.decode(response.body);
    if (res != null) {
      if (response.statusCode == 200) {
        final message = res['message'] ?? "";
        final data = res['data'];

        if (message == 'success' && data != null) {
          print("SUCCESS:" + response.body);

          final userid = data['user_id'];
          final useremail = data['email'];
          final userpass = data['password'];
          final token = data['token'];

          // Store the authentication token securely
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('userid', userid);
          await prefs.setString('useremail', useremail);
          await prefs.setString('userpass', userpass);
          await prefs.setString('authToken', token);

          // Navigate to the authenticated user's screen

          dialog(context, Text(res['message']), [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            )
          ]);
        } else {
          print("Authentication failed");
          print("ERROR:" + response.body);
          final error = "Invalid username or password";

          // Display an error message
          dialog(
              context,
              Text(
                error,
                style: GoogleFonts.nunito(),
              ),
              [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                )
              ]);
        }
      } else {
        print("Server error");
      }
    } else {
      print("Data is null");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 15),
                labelText: 'Email',
                labelStyle: GoogleFonts.nunito(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 15),
                labelText: 'Password',
                labelStyle: GoogleFonts.nunito(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                fixedSize: Size(MediaQuery.of(context).size.width, 28),
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.deepPurple, width: 0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: loginUser,
              child: Text(
                'Login',
                style: GoogleFonts.nunito(
                    fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

dialog(BuildContext context, Widget title, List<Widget> actions) {
  return showDialog(
    context: context,
    builder: (ctx) => CupertinoAlertDialog(
        title: title,
        // content: Text(token ?? "null"),
        actions: actions),
  );
}
