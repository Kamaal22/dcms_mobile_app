import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedbackPage extends StatefulWidget {
  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final TextEditingController _feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[300],
        title: Text(
          'App Feedback',
          style: GoogleFonts.poppins(),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'We would love to hear from you!',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Please provide your feedback or report any issues you encountered while using the app. Your suggestions are valuable to us and help us improve our services.',
              style: GoogleFonts.poppins(),
            ),
            SizedBox(height: 24),
            _buildFeedbackForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _feedbackController,
          maxLines: 5,
          decoration: InputDecoration(
            labelText: 'Feedback or Issue',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 12),
        ElevatedButton(
          onPressed: _sendFeedback,
          child: Text('Submit Feedback'),
        ),
      ],
    );
  }

  void _sendFeedback() async {
    final String feedback = _feedbackController.text;
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'contact@yourdentalclinic.com',
      queryParameters: {'subject': 'App Feedback'},
    );

    if (await canLaunchUrl(emailLaunchUri.toString() as Uri)) {
      await launchUrl(emailLaunchUri.toString() as Uri);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to open email app. Please try again later.'),
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
