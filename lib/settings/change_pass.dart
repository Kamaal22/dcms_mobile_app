import 'package:dcms_mobile_app/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final elevatedButtonColor = isDarkMode ? Colors.black : Colors.blue[300];
    final containerColor = isDarkMode ? Colors.white : Colors.grey[200];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[300],
        title: Text(
          'Change Password',
          style: GoogleFonts.poppins(),
        ),
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Card(
            color: containerColor,
            // borderRadius: BorderRadius.circular(10),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _currentPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Current Password',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your current password';
                        }
                        // Add additional validation logic here if needed
                        return null;
                      },
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      controller: _newPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'New Password',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a new password';
                        }
                        // Add additional validation logic here if needed
                        return null;
                      },
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      controller: _confirmNewPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Confirm New Password',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please confirm your new password';
                        }
                        if (value != _newPasswordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color?>(
                            elevatedButtonColor),
                      ),
                      onPressed: _changePassword,
                      child: Text(
                        'Change Password',
                        style: GoogleFonts.syne(color: textColor),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _changePassword() {
    if (_formKey.currentState!.validate()) {
      // Perform password change logic here
      String currentPassword = _currentPasswordController.text;
      String newPassword = _newPasswordController.text;

      // Add your logic for password change API call or database update

      // Show a success message to the user
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Success'),
          content: Text('Password changed successfully.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
