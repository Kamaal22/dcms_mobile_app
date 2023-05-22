// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class Appointment extends StatefulWidget {
  const Appointment({super.key});

  @override
  State<Appointment> createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Appointment')),
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
