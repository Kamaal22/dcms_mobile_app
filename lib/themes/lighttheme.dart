import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightTheme = ThemeData(
  //////////////////////////////////////////////////////////////////////////////////////  SnackBar Theme
  snackBarTheme: SnackBarThemeData(
    backgroundColor: Colors.blueGrey[800],
    contentTextStyle: GoogleFonts.nunito(color: Colors.white),
    actionTextColor: Colors.blue[900],
  ),
  //////////////////////////////////////////////////////////////////////////////////////  Icon Theme
  iconTheme: IconThemeData(
    color: Colors.blue[900],
  ),
  //////////////////////////////////////////////////////////////////////////////////////  Divider Theme
  dividerTheme: DividerThemeData(
    color: Colors.blueGrey[900],
    thickness: 1.0,
    space: 16.0,
  ),
  //////////////////////////////////////////////////////////////////////////////////////  BottomNavigationBar Theme
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.blueGrey[50],
    selectedItemColor: Colors.blue[900],
    unselectedItemColor: Colors.blueGrey[400],
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    titleTextStyle: GoogleFonts.nunito(
      color: Colors.blue[900],
      fontWeight: FontWeight.bold,
    ),
  ),
  scaffoldBackgroundColor: Colors.blueGrey[50],
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      elevation: MaterialStateProperty.all(0),
      textStyle: MaterialStateProperty.all<TextStyle?>(GoogleFonts.nunito()),
      backgroundColor: MaterialStateProperty.all<Color?>(Colors.transparent),
      foregroundColor: MaterialStateProperty.all<Color?>(Colors.blue[900]),
      padding: MaterialStateProperty.all<EdgeInsetsGeometry?>(
        EdgeInsets.symmetric(horizontal: 10),
      ),
      side: MaterialStateProperty.all<BorderSide?>(
        BorderSide(width: 1, color: Colors.blue[900]!),
      ),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      alignment: Alignment.center,
    ),
  ),
  dialogTheme: DialogTheme(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    backgroundColor: Colors.blueGrey[50],
    shadowColor: Colors.blue[900],
    contentTextStyle: GoogleFonts.nunito(color: Colors.blue[900]),
    elevation: 0.5,
    titleTextStyle: GoogleFonts.nunito(),
  ),
  datePickerTheme: DatePickerThemeData(
    headerHelpStyle: GoogleFonts.nunito(),
    weekdayStyle: GoogleFonts.nunito(),
    dayStyle: TextStyle(fontFamily: GoogleFonts.nunito().fontFamily),
    todayBorder: BorderSide(width: 1.5),
    yearStyle: TextStyle(fontFamily: GoogleFonts.nunito().fontFamily),
    headerBackgroundColor: Colors.blue[100],
  ),
  textTheme: TextTheme(
    displayLarge: GoogleFonts.nunito(
      color: Colors.blue[900],
      fontWeight: FontWeight.normal,
    ),
    displayMedium: GoogleFonts.nunito(
      color: Colors.blue[900],
      fontWeight: FontWeight.normal,
    ),
    displaySmall: GoogleFonts.nunito(
      color: Colors.blue[900],
      fontWeight: FontWeight.normal,
    ),
    headlineLarge: GoogleFonts.nunito(
      color: Colors.blue[900],
      fontWeight: FontWeight.normal,
    ),
    headlineMedium: GoogleFonts.nunito(
      color: Colors.blue[900],
      fontWeight: FontWeight.normal,
    ),
    headlineSmall: GoogleFonts.nunito(
      color: Colors.blue[900],
      fontWeight: FontWeight.normal,
    ),
    titleLarge: GoogleFonts.nunito(
      color: Colors.blue[900],
      fontWeight: FontWeight.normal,
    ),
    titleMedium: GoogleFonts.nunito(
      color: Colors.blue[900],
      fontWeight: FontWeight.normal,
    ),
    titleSmall: GoogleFonts.nunito(
      color: Colors.blue[900],
      fontWeight: FontWeight.normal,
    ),
    bodyLarge: GoogleFonts.nunito(
      color: Colors.blue[900],
      fontWeight: FontWeight.normal,
    ),
    bodyMedium: GoogleFonts.nunito(
      color: Colors.blue[900],
      fontWeight: FontWeight.normal,
    ),
    bodySmall: GoogleFonts.nunito(
      color: Colors.blue[900],
      fontWeight: FontWeight.normal,
    ),
    labelLarge: GoogleFonts.nunito(
      color: Colors.blue[900],
      fontWeight: FontWeight.normal,
    ),
    labelMedium: GoogleFonts.nunito(
      color: Colors.blue[900],
      fontWeight: FontWeight.normal,
    ),
    labelSmall: GoogleFonts.nunito(
      color: Colors.blue[900],
      fontWeight: FontWeight.normal,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.blue[50],
    alignLabelWithHint: true,
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blueGrey[700]!),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blue[900]!, width: 0.5),
    ),
    labelStyle: GoogleFonts.nunito(
      fontWeight: FontWeight.normal,
      color: Colors.blue[900],
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
  ),
  checkboxTheme: CheckboxThemeData(
    checkColor: MaterialStateProperty.all(Colors.blue[900]),
    fillColor: MaterialStateProperty.all(Colors.blueGrey[50]),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(5)),
    ),
  ),
  listTileTheme: ListTileThemeData(
    iconColor: Colors.blueGrey[900],
    tileColor: Colors.transparent,
    titleTextStyle: GoogleFonts.nunito(
      fontWeight: FontWeight.bold,
      color: Colors.blue[900],
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 10),
  ),
);
