import 'package:dcms_mobile_app/appointments.dart';
import 'package:dcms_mobile_app/appt_modal.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'index.dart';
import 'login/login.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Sample data for upcoming appointments (Replace with real data)
  final List<Map<String, String>> upcomingAppointments = [
    {
      'date': 'August 10, 2023 at 10:00 AM',
      'title': 'Dental Cleaning',
    },
    {
      'date': 'August 15, 2023 at 2:30 PM',
      'title': 'Check-up',
    },
  ];

  late bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    isDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    final backgroundColor = isDarkMode ? Colors.grey[800] : Colors.grey[200];
    final textColor = isDarkMode ? Colors.white : Colors.blue[700];
    final inputColor = isDarkMode ? Colors.blue[800] : Colors.blue[100];
    final elevatedButtonColor = isDarkMode ? Colors.white : Colors.blue[800];
    final elevTextColor = isDarkMode ? Colors.grey[800] : Colors.white;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[100],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(2),
              margin: EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                  border: Border.all(width: 0.5, color: textColor!)),
              child: Container(
                padding: EdgeInsets.all(1),
                decoration: BoxDecoration(
                    border: Border.all(width: 0.5, color: textColor)),
                child: Text(
                  'Emarites ',
                  style: GoogleFonts.cinzelDecorative(color: textColor),
                ),
              ),
            ),
            Text(
              'Dental Clinic',
              style: GoogleFonts.poppins(color: textColor),
            ),
          ],
        ),
        actions: [
          // User Profile (Replace with real data)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/profile.jpg'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Logo/Header (Replace with actual logo or header)
            // Center(
            //   child: Image.asset(
            //     'assets/logo.png',
            //     height: 100,
            //   ),
            // ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              color: backgroundColor,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Clinic Information',
                        style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: textColor),
                      ),
                    ],
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.location_on),
                    title: Text('123 Madina Street, Mogadishu, Somalia',
                        style: GoogleFonts.poppins()),
                  ),
                  ListTile(
                    leading: Icon(Icons.phone),
                    title: Text('Phone: +252 6XX XXXXXX',
                        style: GoogleFonts.poppins()),
                  ),
                  ListTile(
                    leading: Icon(Icons.access_time),
                    title: Text('Working Hours: Sat-Thur, 8:00 AM - 6:00 PM',
                        style: GoogleFonts.poppins()),
                  ),
                  ListTile(
                    leading: Icon(Icons.medical_services),
                    title: Text(
                        'Services Offered: Dental Check-up, Cleaning, etc.',
                        style: GoogleFonts.poppins()),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize:
                        Size(MediaQuery.of(context).size.width * 0.32, 20),
                    elevation: 0,
                    backgroundColor: elevatedButtonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AppointmentModel()),
                    );
                  },
                  child: Text('Book Appointment',
                      style: GoogleFonts.syne(color: elevTextColor)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize:
                        Size(MediaQuery.of(context).size.width * 0.32, 20),
                    elevation: 0,
                    backgroundColor: elevatedButtonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AppointmentPage()),
                    );
                  },
                  child: Text('View Appointments',
                      style: GoogleFonts.syne(color: elevTextColor)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize:
                        Size(MediaQuery.of(context).size.width * 0.25, 20),
                    elevation: 0,
                    backgroundColor: elevatedButtonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    // Code to contact the clinic
                  },
                  child: Text('Contact Us',
                      style: GoogleFonts.syne(color: elevTextColor)),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Upcoming Appointments
            Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              color: backgroundColor,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Row(children: [
                    Text(
                      'Upcoming Appointments',
                      style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: textColor),
                    ),
                  ]),
                  SizedBox(height: 10),
                  upcomingAppointments.isEmpty
                      ? Center(
                          child: Text('No upcoming appointments'),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: upcomingAppointments.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.blue,
                                child: Icon(Icons.calendar_today,
                                    color: Colors.white),
                              ),
                              title: Text(upcomingAppointments[index]['date']!),
                              subtitle:
                                  Text(upcomingAppointments[index]['title']!),
                              trailing: Icon(Icons.arrow_forward),
                              onTap: () {
                                // Code to view appointment details
                                print(
                                    'View appointment details: ${upcomingAppointments[index]}');
                              },
                            );
                          },
                        ),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: elevatedButtonColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AppointmentModel()),
          );
        },
        child: Icon(
          Icons.add,
          color: elevTextColor,
        ),
      ),
    );
  }
}
