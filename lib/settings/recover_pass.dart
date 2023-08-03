import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PasswordRecoveryPage extends StatefulWidget {
  @override
  State<PasswordRecoveryPage> createState() => _PasswordRecoveryPageState();
}

class _PasswordRecoveryPageState extends State<PasswordRecoveryPage> {
  final TextEditingController _emailController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[300],
        title: Text(
          'Password Recovery',
          style: GoogleFonts.poppins(),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email';
                  }
                  // Add additional email validation logic here if needed
                  return null;
                },
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _sendPasswordResetLink,
                child: Text('Send Password Reset Link'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _sendPasswordResetLink() {
    if (_formKey.currentState!.validate()) {
      // Perform password recovery logic here
      String email = _emailController.text;

      // Add your logic for sending the password reset link to the user's email

      // Show a success message to the user
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Success'),
          content: Text('A password reset link has been sent to your email.'),
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
