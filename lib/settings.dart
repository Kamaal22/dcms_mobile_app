import 'package:dcms_mobile_app/settings/about.dart';
import 'package:dcms_mobile_app/settings/change_pass.dart';
import 'package:dcms_mobile_app/settings/feedback.dart';
import 'package:dcms_mobile_app/settings/personal_info.dart';
import 'package:dcms_mobile_app/settings/recover_pass.dart';
import 'package:dcms_mobile_app/themes/darktheme.dart';
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
    final isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    final textColor = isDarkMode ? Colors.black : Colors.white;
    final iconColor = isDarkMode ? Colors.black : Colors.white;
    final containerColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        title: Text(
          'Settings',
          style: GoogleFonts.poppins(),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SizedBox(height: 20),

            // Profile Settings Section
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
            ),

            // Password Management Section
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
                  // Implement password recovery logic
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PasswordRecoveryPage(),
                    ),
                  );
                }),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: containerColor,
                  child: ListTile(
                    leading: Icon(
                      Icons.dark_mode_rounded,
                      color: iconColor,
                    ),
                    title: Text(
                      "Dark Mode",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600, color: textColor),
                    ),
                    trailing: Switch(
                      value: _isDarkMode,
                      onChanged: (value) {
                        setState(() {
                          _isDarkMode = value;
                        });
                        themeProvider.toggleTheme();
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
            // App Feedback Section
            _buildSettingsSection(
              context,
              Icons.feedback_rounded,
              'App Feedback',
              [
                _buildSettingsItem('Provide App Feedback', () {
                  // Implement app feedback form or email support logic
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FeedbackPage(),
                    ),
                  );
                }),
              ],
            ),

            // Logout Section
            _buildSettingsSection(
              context,
              Icons.logout_rounded,
              'Logout',
              [
                _buildSettingsItem('Logout', () {
                  _showLogoutConfirmationDialog(context);
                }, textColor: Colors.red),
              ],
            ),

            // About Page Section
            _buildSettingsSection(
              context,
              Icons.info_rounded,
              'About Page',
              [
                _buildSettingsItem('App Information', () {
                  // Implement app information display logic
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AboutPage(),
                    ),
                  );
                }),
                _buildSettingsItem('Third-Party Libraries', () {
                  // Implement third-party libraries acknowledgment logic
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(
    BuildContext context,
    IconData icon,
    String title,
    List<Widget> settingsItems,
  ) {
    final isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    final textColor = isDarkMode ? Colors.white : Colors.blueGrey;
    final iconColor = isDarkMode ? Colors.white : Colors.blueGrey;
    final containerColor = isDarkMode ? Colors.grey[900] : Colors.grey[200];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: containerColor,
          child: ListTile(
            leading: Icon(icon, color: iconColor),
            title: Text(
              title,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ),
        ),
        // Divider(),
        ...settingsItems,
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSettingsItem(String text, VoidCallback onPressed,
      {Color? textColor}) {
    final isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    final textColor = isDarkMode ? Colors.white : Colors.blueGrey;
    final iconColor = isDarkMode ? Colors.white : Colors.blueGrey;
    final containerColor = isDarkMode ? Colors.grey[900] : Colors.grey[200];
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: GoogleFonts.syne(
                  fontSize: 16,
                  color: textColor,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: iconColor,
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
