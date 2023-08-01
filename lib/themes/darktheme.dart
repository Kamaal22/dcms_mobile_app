import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

ThemeData darkTheme = ThemeData(
  appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      titleTextStyle: GoogleFonts.nunito(
          color: Colors.blueGrey[50], fontWeight: FontWeight.bold)),
  scaffoldBackgroundColor: Colors.grey[900],
  //////////////////////////////////////////////////////////////////////////////////////  Elevated Button Theme

  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
    elevation: MaterialStateProperty.all(0),
    textStyle: MaterialStateProperty.all<TextStyle?>(GoogleFonts.nunito()),
    backgroundColor: MaterialStateProperty.all<Color?>(Colors.transparent),
    foregroundColor: MaterialStateProperty.all<Color?>(Colors.blueGrey[50]),
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
  //////////////////////////////////////////////////////////////////////////////////////  Dialog Theme

  dialogTheme: DialogTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: Colors.grey.shade700,
      shadowColor: Colors.blueGrey[50],
      contentTextStyle: GoogleFonts.nunito(color: Colors.blueGrey),
      elevation: 0.5,
      titleTextStyle: GoogleFonts.nunito()),

  //////////////////////////////////////////////////////////////////////////////////////  Date Picker Theme
  datePickerTheme: DatePickerThemeData(
    headerHelpStyle: GoogleFonts.nunito(),
    weekdayStyle: GoogleFonts.nunito(),
    dayStyle: TextStyle(fontFamily: GoogleFonts.nunito().fontFamily),
    todayBorder: BorderSide(width: 1.5),
    yearStyle: TextStyle(fontFamily: GoogleFonts.nunito().fontFamily),
    headerBackgroundColor: Colors.blueGrey[100],
  ),
  //////////////////////////////////////////////////////////////////////////////////////  Text Theme

  textTheme: TextTheme(
    displayLarge: GoogleFonts.nunito(
        color: Colors.blueGrey[50], fontWeight: FontWeight.normal),
    displayMedium: GoogleFonts.nunito(
        color: Colors.blueGrey[50], fontWeight: FontWeight.normal),
    displaySmall: GoogleFonts.nunito(
        color: Colors.blueGrey[50], fontWeight: FontWeight.normal),
    headlineLarge: GoogleFonts.nunito(
        color: Colors.blueGrey[50], fontWeight: FontWeight.normal),
    headlineMedium: GoogleFonts.nunito(
        color: Colors.blueGrey[50], fontWeight: FontWeight.normal),
    headlineSmall: GoogleFonts.nunito(
        color: Colors.blueGrey[50], fontWeight: FontWeight.normal),
    titleLarge: GoogleFonts.nunito(
        color: Colors.blueGrey[50], fontWeight: FontWeight.normal),
    titleMedium: GoogleFonts.nunito(
        color: Colors.blueGrey[50], fontWeight: FontWeight.normal),
    titleSmall: GoogleFonts.nunito(
        color: Colors.blueGrey[50], fontWeight: FontWeight.normal),
    bodyLarge: GoogleFonts.nunito(
        color: Colors.blueGrey[50], fontWeight: FontWeight.normal),
    bodyMedium: GoogleFonts.nunito(
        color: Colors.blueGrey[50], fontWeight: FontWeight.normal),
    bodySmall: GoogleFonts.nunito(
        color: Colors.blueGrey[50], fontWeight: FontWeight.normal),
    labelLarge: GoogleFonts.nunito(
        color: Colors.blueGrey[50], fontWeight: FontWeight.normal),
    labelMedium: GoogleFonts.nunito(
        color: Colors.blueGrey[50], fontWeight: FontWeight.normal),
    labelSmall: GoogleFonts.nunito(
        color: Colors.blueGrey[50], fontWeight: FontWeight.normal),
  ),
  //////////////////////////////////////////////////////////////////////////////////////  Input Theme

  inputDecorationTheme: InputDecorationTheme(
      filled: true,
      // fillColor: Colors.blue[50],
      alignLabelWithHint: true,
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueGrey.shade700)),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueAccent, width: 0.5)),
      labelStyle: GoogleFonts.nunito(
          fontWeight: FontWeight.normal, color: Colors.white),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)))),
  //////////////////////////////////////////////////////////////////////////////////////  Check Box Theme

  checkboxTheme: CheckboxThemeData(
      checkColor: MaterialStateProperty.all(Colors.white),
      fillColor: MaterialStateProperty.all(Colors.blueGrey[900]),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)))),
  //////////////////////////////////////////////////////////////////////////////////////  List Tile Theme

  listTileTheme: ListTileThemeData(
      iconColor: Colors.blueGrey[900],
      tileColor: Colors.transparent,
      titleTextStyle: GoogleFonts.nunito(
          fontWeight: FontWeight.bold, color: Colors.blueGrey[100]),
      contentPadding: EdgeInsets.symmetric(horizontal: 10)),
);

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  final String _themeKey = 'isDarkMode';

  ThemeProvider() {
    _loadTheme();
  }

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _saveTheme();
    notifyListeners();
  }

  Future<void> _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(_themeKey) ?? false;
    notifyListeners();
  }

  Future<void> _saveTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, _isDarkMode);
  }
}
