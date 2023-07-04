import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _insuranceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Address'),
            ),
            TextField(
              controller: _insuranceController,
              decoration: InputDecoration(labelText: 'Insurance Information'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Save profile information logic here
                _showSaveConfirmationDialog();
              },
              child: Text('Save'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Change password logic here
                _showChangePasswordDialog();
              },
              child: Text('Change Password'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Manage notifications logic here
                _showNotificationSettings();
              },
              child: Text('Manage Notifications'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Customize app settings logic here
                _showAppSettings();
              },
              child: Text('App Settings'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Logout logic here
                _showLogoutConfirmationDialog();
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }

  void _showSaveConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Profile information saved.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change Password'),
          content: TextField(
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'New Password',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Change password logic here
                _showPasswordChangedDialog();
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showPasswordChangedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Password changed successfully.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showNotificationSettings() {
    // Implement notification settings UI
    // This can be a separate page or dialog
    // Use appropriate UI components and logic for managing notifications
  }

  void _showAppSettings() {
    // Implement app settings UI
    // This can be a separate page or dialog
    // Use appropriate UI components and logic for customizing app settings
  }

  void _showLogoutConfirmationDialog() {
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
                // Logout logic here
                _performLogout();
                Navigator.pop(context);
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void _performLogout() {
    // Implement logout logic here
    // Clear user session, navigate to login screen, etc.
  }
}
