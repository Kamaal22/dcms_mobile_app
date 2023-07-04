import 'dart:convert';
import 'dart:io';
import 'package:dcms_mobile_app/assets/colors.dart';
import 'package:dcms_mobile_app/assets/component.dart';
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
  final String apiUrl = 'http://192.168.1.5/DCMS/app/mobile/login/login.php';

  @override
  void initState() {
    super.initState();
    checkAuth();
  }

  void checkAuth() async {
    final userData = await DatabaseManager.getUserData();
    if (userData != null) {
      navigateToIndexPage();
    }
  }

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

      if (message == 'success' && data != null) {
        prefs.setString('user_id', data['user_id']);
        prefs.setString('username', data['username']);
        prefs.setString('password', data['password']);

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
      builder: (context) => AlertDialog(
        title:
            Text(title, style: GoogleFonts.nunito(fontWeight: FontWeight.bold)),
        content: Text(content, style: GoogleFonts.nunito()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK',
                style: GoogleFonts.nunito(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
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

class DatabaseManager {
  static const String dbName = 'your_database.db';
  static const String tableName = 'user';
  static const String columnUserId = 'user_id';
  static const String columnUsername = 'username';
  static const String columnPassword = 'password';

  static Future<Database> openDatabase() async {
    final dbPath = path.join(await Directory.systemTemp.path, dbName);
    final db = sqlite3.open(dbPath);

    db.execute('''
      CREATE TABLE IF NOT EXISTS $tableName (
        $columnUserId TEXT PRIMARY KEY,
        $columnUsername TEXT,
        $columnPassword TEXT
      )
    ''');

    return db;
  }

  static Future<void> saveUserData(
      String userId, String username, String password) async {
    final db = await openDatabase();
    db.execute('''
      INSERT OR REPLACE INTO $tableName ($columnUserId, $columnUsername, $columnPassword)
      VALUES ('$userId', '$username', '$password')
    ''');
  }

  static Future<Map<String, dynamic>?> getUserData() async {
    final db = await openDatabase();
    final result = db.select('SELECT * FROM $tableName');
    final data = result.isNotEmpty ? result.first : null;
    return data;
  }
}
