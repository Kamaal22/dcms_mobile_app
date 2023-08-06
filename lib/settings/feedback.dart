import 'package:dcms_mobile_app/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class FeedbackPage extends StatefulWidget {
  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final TextEditingController _feedbackController = TextEditingController();
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
    final textColor = isDarkMode ? Colors.white : Colors.blue[700];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text(
          'App Feedback',
          style: GoogleFonts.poppins(color: iHeadColor),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: iHeadColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey[900] : Colors.grey[200],
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          width: MediaQuery.of(context).size.width,
          height: 500,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 100),
              Text(
                'We would love to hear from you!',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: iHeadColor,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Please provide your feedback or report any issues you encountered while using the app. Your suggestions are valuable to us and help us improve our services.',
                style: GoogleFonts.poppins(color: textColor),
              ),
              SizedBox(height: 24),
              _buildFeedbackForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeedbackForm() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkMode = themeProvider.isDarkMode;
    final backgroundColor = isDarkMode ? Colors.grey[800] : Colors.blue[800];
    final textColor = isDarkMode ? Colors.white : Colors.blue[800];
    SnackBar messageSnackBar(Color? backgroundColor, Color? textColor,
        String message, int duration) {
      return SnackBar(
        duration: Duration(seconds: duration),
        backgroundColor: backgroundColor,
        content: Text(message,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500, fontSize: 20, color: textColor)),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _feedbackController,
          maxLines: 5,
          style: GoogleFonts.poppins(color: textColor),
          decoration: InputDecoration(
            labelText: 'Feedback or Issue',
            labelStyle: GoogleFonts.nunito(color: textColor, fontSize: 18),
            focusColor: backgroundColor,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(width: 2, color: textColor!),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(width: 1, color: textColor),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                Icons.clear,
                color: backgroundColor,
              ),
              onPressed: () {
                _feedbackController.clear();
              },
            ),
          ),
        ),
        SizedBox(height: 12),
        ElevatedButton(
          onPressed: () {
            // Validate the feedback before sending
            String feedback = _feedbackController.text.trim();
            if (feedback.length >= 10) {
              _sendFeedback(feedback);
            } else if (feedback.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar((messageSnackBar(
                  Colors.red[50],
                  Colors.red[800],
                  "Please enter your feedback!",
                  2)));
            } else {
              ScaffoldMessenger.of(context).showSnackBar((messageSnackBar(
                  Colors.red[50],
                  Colors.red[800],
                  'Feedback must be at least 10 characters.',
                  2)));
            }
          },
          style: ElevatedButton.styleFrom(
            fixedSize: Size(MediaQuery.of(context).size.width, 50),
            elevation: 0,
            backgroundColor: backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child:
              Text('Submit Feedback', style: GoogleFonts.poppins(fontSize: 22)),
        ),
      ],
    );
  }

  void _sendFeedback(String feedback) async {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkMode = themeProvider.isDarkMode;

    SnackBar messageSnackBar(Color? backgroundColor, Color? textColor,
        String message, int duration) {
      return SnackBar(
        duration: Duration(seconds: duration),
        backgroundColor: backgroundColor,
        content: Text(message,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500, fontSize: 18, color: textColor)),
      );
    }

    try {
      final response = await http.post(
        Uri.parse('http://192.168.110.163/DCMS/app/mobile/test.php'),
        body: {'feedback': feedback},
      );

      if (response.statusCode == 200) {
        _feedbackController.clear();
        ScaffoldMessenger.of(context).showSnackBar((messageSnackBar(
            Colors.green[50],
            Colors.green[800],
            'Feedback submitted successfully! Thank you!',
            2)));
      } else {
        throw Exception('Failed to submit feedback.');
      }
    } catch (e) {
      print(e.toString());
      showDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text('Error'),
          content: Text('" ' + e.toString() + ' "'),
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
