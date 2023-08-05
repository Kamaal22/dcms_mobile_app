import 'package:dcms_mobile_app/settings/about.dart';
import 'package:dcms_mobile_app/settings/change_pass.dart';
import 'package:dcms_mobile_app/settings/feedback.dart';
import 'package:dcms_mobile_app/settings/personal_info.dart';
import 'package:dcms_mobile_app/settings/recover_pass.dart';
import 'package:dcms_mobile_app/themes/darktheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _isDarkMode = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkMode = themeProvider.isDarkMode;

    // Define colors based on the theme mode
    final iHeadColor = isDarkMode ? Colors.white : Colors.blue[800];
    final backgroundColor = isDarkMode ? Colors.grey[800] : Colors.grey[100];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text(
          'Settings',
          style: GoogleFonts.poppins(color: iHeadColor),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSettingsSection(
                context,
                Icons.account_circle_rounded,
                'Profile Settings',
                [
                  _buildSettingsItem('View and Update Personal Info', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileSettingsPage(),
                      ),
                    );
                  }),
                  _buildSettingsItem('Change Profile Picture', () {
                    // Implement change profile picture logic
                  }),
                ],
                iHeadColor!,
                backgroundColor!,
              ),
              _buildSettingsSection(
                context,
                Icons.lock_rounded,
                'Password Management',
                [
                  _buildSettingsItem('Change Password', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChangePasswordPage(),
                      ),
                    );
                  }),
                  _buildSettingsItem('Password Recovery', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PasswordRecoveryPage(),
                      ),
                    );
                  }),
                ],
                iHeadColor,
                backgroundColor,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: ListTile(
                      leading: Icon(
                        Icons.dark_mode_rounded,
                        color: iHeadColor,
                      ),
                      title: Text(
                        "Dark Mode",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600, color: iHeadColor),
                      ),
                      trailing: CupertinoSwitch(
                        value: _isDarkMode,
                        trackColor: Colors.grey[400],
                        onChanged: (value) {
                          setState(() {
                            _isDarkMode = value;
                          });
                          themeProvider.toggleTheme();
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Handle App Feedback button press
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FeedbackPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(MediaQuery.of(context).size.width, 50),
                      elevation: 0,
                      backgroundColor: backgroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.feedback_rounded,
                          color: iHeadColor,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'App Feedback',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            color: iHeadColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Handle About button press
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AboutPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(MediaQuery.of(context).size.width, 50),
                      elevation: 0,
                      backgroundColor: backgroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_rounded,
                          color: iHeadColor,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'About',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            color: iHeadColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Handle Logout button press
                      _showLogoutConfirmationDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(MediaQuery.of(context).size.width, 50),
                      elevation: 0,
                      backgroundColor: backgroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.logout_rounded,
                          color: Colors.red,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Logout',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 200),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsSection(
    BuildContext context,
    IconData icon,
    String title,
    List<Widget> settingsItems,
    Color iHeadColor,
    Color backgroundColor,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: backgroundColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10))),
            child: ListTile(
              leading: Icon(icon, color: iHeadColor),
              title: Text(
                title,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: iHeadColor,
                ),
              ),
            ),
          ),
          ...settingsItems,
          // SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(String text, VoidCallback onPressed,
      {Color? iHeadColor}) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: GoogleFonts.syne(
                  fontSize: 16,
                  color: iHeadColor,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: iHeadColor,
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            'Are you sure you want to logout?',
            style: GoogleFonts.poppins(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'No',
                style: GoogleFonts.syne(fontSize: 20, color: Colors.blue),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Perform logout logic here
              },
              child: Text(
                'Yes',
                style: GoogleFonts.syne(fontSize: 20, color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
