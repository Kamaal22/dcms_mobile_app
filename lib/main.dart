// ignore_for_file: prefer_const_constructors, unused_import

import 'package:dcms_mobile_app/assets/colors.dart';
import 'package:dcms_mobile_app/one.dart';
import 'package:dcms_mobile_app/themes/darktheme.dart';
import 'package:dcms_mobile_app/themes/lighttheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DCMS Mobile App',
      themeMode: ThemeMode.system, // Use system theme mode
      theme: lightTheme, // Light theme
      darkTheme: darkTheme, // Dark theme
      home: Index(),
    );
  }
}
