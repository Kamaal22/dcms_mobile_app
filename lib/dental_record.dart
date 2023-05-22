// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class DentalRecord extends StatefulWidget {
  const DentalRecord({super.key});

  @override
  State<DentalRecord> createState() => _DentalRecordState();
}

class _DentalRecordState extends State<DentalRecord> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Dental Record')),
        body: Center(
          child: MaterialButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Click'),
          ),
        ));
  }
}
