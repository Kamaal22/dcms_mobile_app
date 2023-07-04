// ignore_for_file: prefer_const_constructors, unused_import

// import 'package:dcms_mobile_app/settings.dart';
import 'package:dcms_mobile_app/assets/colors.dart';
import 'package:dcms_mobile_app/login/login.dart';
import 'package:dcms_mobile_app/one.dart';
import 'package:dcms_mobile_app/test.dart';
import 'package:flutter/material.dart';

import 'appointments.dart';

// import 'appointments.dart';
// import 'dental_record.dart';
// import 'homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DCMS Mobile App',
      theme: lightTheme,
      home: Index(),
      // initialRoute: '/',
      // routes: {
      //   '/': (context) => HomePage(),
      //   '/dentalrecord': (context) => DentalRecord(),
      //   '/setting': (context) => Settings(),
      //   '/appointment': (context) => Appointment(),
      //   '/': (context) => HomePage(),
      // },
    );
  }
}
