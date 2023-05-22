// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Settings')),
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
