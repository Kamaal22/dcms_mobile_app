import 'dart:convert';

import 'package:dcms_mobile_app/assets/component.dart';
import 'package:dcms_mobile_app/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ChangePasswordPage extends StatefulWidget {
  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // SnackBar messageSnackBar(
  //     Color? backgroundColor, Color? textColor, String message, int duration) {
  //   return SnackBar(
  //     duration: Duration(seconds: duration),
  //     backgroundColor: backgroundColor,
  //     content: Text(message,
  //         textAlign: TextAlign.center,
  //         style: GoogleFonts.poppins(
  //             fontWeight: FontWeight.w500, fontSize: 16, color: textColor)),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        Provider.of<ThemeProvider>(context, listen: true).isDarkMode;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final elevatedButtonColor =
        isDarkMode ? Colors.grey[900] : Colors.blue[800];
    final containerColor = isDarkMode ? Colors.grey[800] : Colors.grey[100];
    // final inputColor = isDarkMode ? Colors.blue[800] : Colors.blue[100];
    final backgroundColor = isDarkMode ? Colors.grey[800] : Colors.blue[800];
    final iHeadColor = isDarkMode ? Colors.white : Colors.blue[800];
    final scaffoldDarkTheme = isDarkMode ? Colors.grey[900] : Colors.grey[50];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: containerColor,
        title: Text(
          'Change Password',
          style: GoogleFonts.poppins(color: iHeadColor),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: iHeadColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
      ),
      backgroundColor: scaffoldDarkTheme,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Container(
            decoration: BoxDecoration(
                color: containerColor, borderRadius: BorderRadius.circular(10)),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      style: GoogleFonts.poppins(color: iHeadColor),
                      controller: _currentPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          labelText: 'Current Password',
                          labelStyle: GoogleFonts.poppins(
                              color: iHeadColor, fontSize: 18),
                          focusColor: backgroundColor,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide:
                                BorderSide(width: 2, color: iHeadColor!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(width: 1, color: iHeadColor),
                          )),
                      validator: (value) {
                        if (value!.isEmpty) {
                          snackbar(context, Colors.red[50], Colors.red[800],
                              "Please enter your current password", 2);
                          // return 'Please enter your current password';
                        }
                        // Add additional validation logic here if needed
                        return null;
                      },
                    ),
                    SizedBox(height: 30),
                    TextFormField(
                      style: GoogleFonts.poppins(color: iHeadColor),
                      controller: _newPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          labelText: 'New Password',
                          labelStyle: GoogleFonts.poppins(
                              color: iHeadColor, fontSize: 18),
                          // focusColor: backgroundColor,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(width: 2, color: iHeadColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(width: 1, color: iHeadColor),
                          )),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a new password';
                        }
                        // Add additional validation logic here if needed
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      style: GoogleFonts.poppins(color: iHeadColor),
                      controller: _confirmNewPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        labelText: 'Confirm New Password',
                        labelStyle: GoogleFonts.poppins(
                            color: iHeadColor, fontSize: 18),
                        focusColor: backgroundColor,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(width: 2, color: iHeadColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(width: 1, color: iHeadColor),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          snackbar(context, Colors.red[50], Colors.red[800],
                              "Please confirm your new password", 2);
                        }
                        if (value != _newPasswordController.text) {
                          snackbar(context, Colors.red[50], Colors.red[800],
                              "New passwords don't match", 2);
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: elevatedButtonColor,
                          elevation: 0,
                          fixedSize: Size(200, 50),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)))),
                      onPressed: _changePassword,
                      child: Text(
                        'Change Password',
                        style: GoogleFonts.poppins(
                            color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _changePassword() async {
    if (_formKey.currentState!.validate()) {
      // Perform password change logic here
      String currentPassword = _currentPasswordController.text;
      String newPassword = _newPasswordController.text;
      String confirmPassword = _confirmNewPasswordController.text;

      try {
        final response = await http.post(
          Uri.parse(API_ENDPOINT("patient/changePass.php")),
          body: {
            'current_pass': currentPassword.trim().toString(),
            'new_pass': newPassword.trim().toString()
          },
        );

        if (response.statusCode == 200) {
          print(response.body);
          var jsonData = jsonDecode(response.body);

          if (jsonData['status'] == 'success') {
            print(jsonData['status']);
            CupertinoAlertDialog(
              title: Text('Success'),
              content: Text('Password changed successfully.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            );
          } else if (jsonData['status'] == 'errorPass') {
            snackbar(context, Colors.red[50], Colors.red[800],
                "Incorrect Current Password ", 2);
          } else if (jsonData['status'] == 'error') {
            snackbar(context, Colors.red[50], Colors.red[800],
                "Error: " + jsonData, 2);
          }
        } else {
          print(response.body);
          snackbar(context, Colors.red[50], Colors.red[800],
              "Error: " + response.body.toString(), 2);
        }
      } catch (e) {
        print(e.toString());
        snackbar(context, Colors.red[50], Colors.red[800],
            "Error: " + e.toString(), 2);
      }
    }
  }
}
