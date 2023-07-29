import 'package:dcms_mobile_app/assets/colors.dart';
import 'package:dcms_mobile_app/assets/component.dart';
import 'package:dcms_mobile_app/themes/darktheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _isDarkMode = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                CircleAvatar(
                  radius: 100,
                  backgroundImage: AssetImage('assets/profile.jpg'),
                )
              ]),
              SizedBox(height: 50),
              Text(
                'Profile Content',
                style: GoogleFonts.nunito(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),

              // ///////////////////////////////////////////////////////////////////////////////////////////
              // ///////////////////////////////////////////////////////////////////////////////////////////
              // ///////////////////////////////////////////////////////////////////////////////////////////
              Container(
                decoration: radius(10, transparent, Colors.blueGrey),
                child: Column(children: [
                  ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PersonalInfoPage()),
                      );
                    },
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Personal Info',
                            style: GoogleFonts.nunito(fontSize: 16),
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios_rounded),
                      ],
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AboutAppPage()),
                      );
                    },
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'About App',
                            style: GoogleFonts.nunito(fontSize: 16),
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios_rounded),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  Divider(),
                  ListTile(
                    // tileColor: Colors.grey[900],
                    onTap: () {
                      _showLogoutConfirmationDialog(context);
                    },
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Logout',
                            style: GoogleFonts.nunito(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.red[700]),
                          ),
                        ),
                        Icon(
                          Icons.logout_rounded,
                          color: Colors.red[700],
                        ),
                      ],
                    ),
                  ),
                ]),
              ),

              ///////////////////////////////////////////////////////////////////////////////////////////////////
              ///////////////////////////////////////////////////////////////////////////////////////////////////
              ///////////////////////////////////////////////////////////////////////////////////////////////////
              ///////////////////////////////////////////////////////////////////////////////////////////////////
              SizedBox(height: 30),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  height: 60,
                  decoration: radius(10, transparent, Colors.blueGrey),
                  child: SwitchListTile(
                    title: Text("Dark Mode"),
                      value: _isDarkMode,
                      onChanged: (value) {
                        setState(() {
                          _isDarkMode = value;
                        });
                        themeProvider.toggleTheme();
                      })),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context); // Pop ProfilePage from the stack
                // Perform logout logic here
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}

class PersonalInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personal Info'),
      ),
      body: Center(
        child: Text('Personal Info Page'),
      ),
    );
  }
}

class AboutAppPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About App'),
      ),
      body: Center(
        child: Text('About App Page'),
      ),
    );
  }
}
