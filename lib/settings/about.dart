import 'package:dcms_mobile_app/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AboutPage extends StatefulWidget {
  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
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

    final iHeadColor = isDarkMode ? Colors.white : Colors.blue[800];
    final textColor = isDarkMode ? Colors.white : Colors.blue;
    final backgroundColor = isDarkMode ? Colors.grey[800] : Colors.grey[100];
    final scaffoldDarkTheme = isDarkMode ? Colors.grey[900] : Colors.grey[50];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text(
          'About',
          style: GoogleFonts.poppins(color: iHeadColor),
        ),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: iHeadColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: scaffoldDarkTheme,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: backgroundColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'App Information',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: iHeadColor,
                      ),
                    ),
                    SizedBox(height: 12),
                    _buildRow('App Name', 'Emarites Clinic', textColor),
                    _buildRow('Version', '1.0.0', textColor),
                    _buildRow('Developer', 'Geckloo ICT Solutions', textColor),
                    _buildRow('Contact Email', 'contact@emaritesclinic.com',
                        textColor),
                    _buildRow('Website', 'www.emaritesclinic.com', textColor),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: backgroundColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Third-Party Libraries',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: iHeadColor,
                      ),
                    ),
                    SizedBox(height: 12),
                    _buildRow('Provider Package', '3.2.0', textColor),
                    _buildRow('Google Fonts Package', '2.1.0', textColor),
                    _buildRow('HTTP Package', '0.13.3', textColor),
                    _buildRow('Flutter Material Icons', '1.0.0', textColor),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String title, String value, Color textColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title + ':',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        SizedBox(width: 12),
        Text(value, style: GoogleFonts.poppins(color: textColor)),
      ],
    );
  }
}
