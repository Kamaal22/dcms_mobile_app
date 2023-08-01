// ignore_for_file: prefer_const_constructors, unused_import

import 'package:dcms_mobile_app/assets/colors.dart';
import 'package:dcms_mobile_app/one.dart';
import 'package:dcms_mobile_app/themes/darktheme.dart';
import 'package:dcms_mobile_app/themes/lighttheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode:
              themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: Index(),
        );
      },
    );
  }
}
