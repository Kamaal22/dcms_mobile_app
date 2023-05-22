// ignore_for_file: prefer_const_constructors

import 'package:dcms_mobile_app/settings.dart';
import 'package:flutter/material.dart';

import 'appointments.dart';
import 'dental_record.dart';
import 'homepage.dart';

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
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/dentalrecord': (context) => DentalRecord(),
        '/setting': (context) => Settings(),
        '/appointment': (context) => Appointment(),
        '/': (context) => HomePage(),
      },
    );
  }
}
