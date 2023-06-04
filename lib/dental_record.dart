// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'assets/colors.dart';

class DentalRecord extends StatefulWidget {
  const DentalRecord({super.key});

  @override
  State<DentalRecord> createState() => _DentalRecordState();
}

class _DentalRecordState extends State<DentalRecord> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              'Dental Records',
              style: GoogleFonts.nunito(
                  fontSize: 25, fontWeight: FontWeight.bold, color: white),
            ),
          ),
          elevation: 0,
          backgroundColor: primary,
        ),
        body: Center());
  }
}
