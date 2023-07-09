// ignore_for_file: prefer_const_constructors, unused_import

import 'package:dcms_mobile_app/assets/colors.dart';
import 'package:dcms_mobile_app/one.dart';
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
      theme: ThemeData(
          appBarTheme:
              AppBarTheme(backgroundColor: Colors.transparent)), // Light theme
      darkTheme: ThemeData(
          appBarTheme: AppBarTheme(backgroundColor: Colors.blueGrey[100]),
          scaffoldBackgroundColor: Colors.blueGrey[800],
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
            elevation: MaterialStateProperty.all(0),
            textStyle:
                MaterialStateProperty.all<TextStyle?>(GoogleFonts.nunito()),
            backgroundColor:
                MaterialStateProperty.all<Color?>(Colors.transparent),
            foregroundColor:
                MaterialStateProperty.all<Color?>(Colors.blueGrey[50]),
            padding: MaterialStateProperty.all<EdgeInsetsGeometry?>(
                EdgeInsets.symmetric(horizontal: 10)),
            side: MaterialStateProperty.all<BorderSide?>(
              BorderSide(width: 1, color: Colors.blueGrey),
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            alignment: Alignment.center,
          )),
          dialogTheme: DialogTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              backgroundColor: Colors.blueGrey[700],
              shadowColor: Colors.blueGrey[50],
              contentTextStyle: GoogleFonts.nunito(),
              elevation: 0.5,
              titleTextStyle: GoogleFonts.nunito()),
          datePickerTheme: DatePickerThemeData(
            headerHelpStyle: GoogleFonts.nunito(),
            weekdayStyle: GoogleFonts.nunito(),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            dayStyle: TextStyle(fontFamily: GoogleFonts.nunito().fontFamily),
            dayBackgroundColor: MaterialStateProperty.all(Colors.blueGrey[50]),
            todayBorder: BorderSide(width: 1.5),
            dayForegroundColor: MaterialStateProperty.all(Colors.blueGrey),
            yearStyle: TextStyle(fontFamily: GoogleFonts.nunito().fontFamily),
            todayBackgroundColor: MaterialStateProperty.all(Colors.green[100]),
            todayForegroundColor: MaterialStateProperty.all(Colors.green[800]),
            headerBackgroundColor: Colors.blueGrey[100],
          ),
          textTheme: TextTheme()), // Dark theme
      home: Index(),
    );
  }
}
