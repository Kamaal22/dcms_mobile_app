import 'package:dcms_mobile_app/assets/colors.dart';
import 'package:dcms_mobile_app/assets/component.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? username;

  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username');
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: spaceBetween,
            children: [
              Text("Welcome, $username",
                  style: GoogleFonts.nunito(
                      fontSize: 30, fontWeight: bold, color: white)),
              Container(
                  width: 40,
                  height: 40,
                  decoration: radius(15, white, white24),
                  child: icon(Icons.notifications_none_rounded, primary, 30))
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 150,
          ),
          Row(
            mainAxisAlignment: spaceAround,
            children: [
              Container(
                decoration: radius(10, white30, primary),
                width: 180,
                height: 180,
                child: Center(
                    child: icon(Icons.photo_library_outlined, primary, 100)),
              ),
              Container(
                decoration: radius(10, white30, primary),
                width: 180,
                height: 180,
                child: Center(child: icon(Icons.android_rounded, primary, 100)),
              )
            ],
          ),
          SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: center,
            children: [
              Container(
                decoration: radius(10, white30, primary),
                width: 380,
                height: 50,
                padding: EdgeInsets.only(left: 20),
                child: Row(
                  mainAxisAlignment: spaceBetween,
                  children: [
                    Text("Appointments",
                        style: GoogleFonts.nunito(
                            fontWeight: bold, fontSize: 18, color: primary)),
                    Container(
                        height: 50,
                        width: 50,
                        decoration: radiusLTRB(0, 0, 8, 8, primary),
                        child: icon(Icons.arrow_forward_ios_rounded, white, 30))
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: center,
            children: [
              Container(
                decoration: radius(10, white30, primary),
                width: 380,
                height: 50,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: spaceBetween,
                  children: [
                    Text("Dental Records",
                        style: GoogleFonts.nunito(
                            fontWeight: bold, fontSize: 18, color: primary)),
                    icon(Icons.arrow_forward_ios_rounded, primary, 30)
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: center,
            children: [
              Container(
                decoration: radius(10, white30, primary),
                width: 380,
                height: 50,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: spaceBetween,
                  children: [
                    Text("Profile",
                        style: GoogleFonts.nunito(
                            fontWeight: bold, fontSize: 18, color: primary)),
                    icon(Icons.arrow_forward_ios_rounded, primary, 30)
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
