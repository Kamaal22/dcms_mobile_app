// ignore_for_file: prefer_const_constructors

import 'package:dcms_mobile_app/assets/component.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'assets/colors.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

bool isSwitched = false;

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              'Profile',
              style: GoogleFonts.nunito(
                  fontSize: 25, fontWeight: FontWeight.bold, color: white),
            ),
          ),
          elevation: 0,
          backgroundColor: primary,
        ),
        body: Column(
          children: [
            SizedBox(height: 100),
            Center(
              child: Container(
                decoration: radius(100, white38, primary),
                width: 200,
                height: 200,
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: (() {}),
              child: Container(
                width: 100,
                height: 30,
                decoration: radius(7, white30, primary),
                child: Center(
                  child: Text(
                    "Edit Profile",
                    style: GoogleFonts.nunito(
                        fontSize: 18, fontWeight: bold, color: primary),
                  ),
                ),
              ),
            ),
            SizedBox(height: 50),
            Container(
              width: 400,
              height: 50,
              decoration: radius(7, white30, primary),
              padding: EdgeInsets.symmetric(horizontal: 20),
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: spaceBetween,
                children: [
                  Text(
                    "Dark Mode",
                    style: GoogleFonts.nunito(
                        fontSize: 18, fontWeight: bold, color: primary),
                  ),
                  Switch(
                    inactiveThumbColor: grey,
                    inactiveTrackColor: grey200,
                    activeColor: primary,
                    value: isSwitched,
                    onChanged: (value) {
                      setState(() {
                        isSwitched = value;
                      });
                    },
                  )
                ],
              ),
            )
          ],
        ));
  }
}
