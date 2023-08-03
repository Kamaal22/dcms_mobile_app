import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[300],
        title: Text(
          'About Page',
          style: GoogleFonts.poppins(),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            _buildAppInformation(),
            SizedBox(height: 20),
            _buildThirdPartyLibraries(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppInformation() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.grey[200],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'App Information',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          _buildAppDetailRow('App Name', 'Emarites Clinic'),
          _buildAppDetailRow('Version', '1.0.0'),
          _buildAppDetailRow('Developer', 'Geckloo ICT Solutions'),
          _buildAppDetailRow('Contact Email', 'contact@emaritesclinic.com'),
          _buildAppDetailRow('Website', 'www.emaritesclinic.com'),
        ],
      ),
    );
  }

  Widget _buildAppDetailRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title + ':',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        SizedBox(width: 12),
        Text(value, style: GoogleFonts.poppins()),
      ],
    );
  }

  Widget _buildThirdPartyLibraries() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.grey[200],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Third-Party Libraries',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          _buildThirdPartyLibraryRow('Provider Package', '3.2.0'),
          _buildThirdPartyLibraryRow('Google Fonts Package', '2.1.0'),
          _buildThirdPartyLibraryRow('HTTP Package', '0.13.3'),
          _buildThirdPartyLibraryRow('Flutter Material Icons', '1.0.0'),
        ],
      ),
    );
  }

  Widget _buildThirdPartyLibraryRow(String title, String version) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title + ':',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        SizedBox(width: 12),
        Text(version, style: GoogleFonts.poppins()),
      ],
    );
  }
}
