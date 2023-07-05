import 'package:dcms_mobile_app/assets/colors.dart';
import 'package:dcms_mobile_app/assets/component.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primary,
        title: Text(
          'Welcome, Abdi Abdirasak',
          style: GoogleFonts.nunito(fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      body: SingleChildScrollView(padding: MP_LTRB(10, 50, 10, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            // SizedBox(height: 40),
            // Upcoming Appointments Card /////////////////////////////////////////////////////////////////////////////
            Container(
              // height: MediaQuery.of(context).size.height * 0.25,
              width: MediaQuery.of(context).size.width,
              // color: red200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Upcoming Appointments:',
                          style: GoogleFonts.nunito(
                              fontSize: 20,
                              color: blueGrey,
                              fontWeight: FontWeight.w800),
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: 60,
                          padding: MP_all(2),
                          decoration: radius(5, lightBlue300, transparent),
                          height: 20,
                          // color: blue50,
                          child: Text("Show All",
                              style: GoogleFonts.nunito(
                                  color: blueGrey,
                                  fontWeight: FontWeight.bold)),
                        )
                      ]),
                  SizedBox(height: 8),
                  AppointmentCard('July 5, 2023', '10:00 AM', 'Dr. Smith'),
                  AppointmentCard('July 10, 2023', '2:30 PM', 'Dr. Johnson'),
                  AppointmentCard('July 15, 2023', '1:30 PM', 'Drs. Mary'),
                ],
              ),
            ),
      
            // Recent Activity Card /////////////////////////////////////////////////////////////////////////////
            // SizedBox(height: 20),
            Container(
              // height: MediaQuery.of(context).size.height * 0.25,
              width: MediaQuery.of(context).size.width,
              // color: red100,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Recent Activity:',
                            style: GoogleFonts.nunito(
                                fontSize: 20,
                                color: blueGrey,
                                fontWeight: FontWeight.w800),
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: 60,
                            padding: MP_all(2),
                            decoration: radius(5, lightGreen300, transparent),
                            height: 20,
                            // color: blue50,
                            child: Text("Show All",
                                style: GoogleFonts.nunito(
                                    color: blueGrey,
                                    fontWeight: FontWeight.bold)),
                          )
                        ]),
                    SizedBox(height: 8),
                    ActivityCard('June 30, 2023', 'Payment received: \$50'),
                    ActivityCard('June 29, 2023', 'Appointment rescheduled'),
                    ActivityCard('June 29, 2023', 'Appointment rescheduled'),
                  ]),
            ),
            // SizedBox(height: 20),
      
            // Quick Access Card /////////////////////////////////////////////////////////////////////////////
            Container(
              // height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width,
              // color: transparent,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick Access:',
                      style: GoogleFonts.nunito(
                          fontSize: 20,
                          color: blueGrey,
                          fontWeight: FontWeight.w800),
                    ),
                    SizedBox(height: 8),
                    QuickAccessButton('Appointments', Icons.event, () {
                      // Add your logic for navigating to the appointments page
                    }),
                    QuickAccessButton('Add Appointment', Icons.add, () {
                      // Add your logic for navigating to the add appointment page
                    }),
                    QuickAccessButton('Dental Record', Icons.description, () {
                      // Add your logic for navigating to the dental record page
                    }),
                    QuickAccessButton('Profile', Icons.person, () {
                      // Add your logic for navigating to the profile page
                    }),
                  ]),
            ),
          ],
          ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        ),
      ),
    );
  }

  Widget AppointmentCard(String date, String time, String dentist) {
    return Card(
      elevation: 0,
      color: lightBlue200,
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Date: $date',
                  style: GoogleFonts.nunito(
                      fontWeight: FontWeight.bold, color: blue700),
                ),
                Text('Time: $time',
                    style: GoogleFonts.nunito(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                        color: blue900)),
                Text('Dentist: $dentist',
                    style: GoogleFonts.nunito(
                        fontWeight: FontWeight.bold, color: blue700)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget ActivityCard(String date, String activity) {
    return Card(
      color: lightGreen200,
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(
                'Date: $date',
                style: GoogleFonts.nunito(
                    fontWeight: FontWeight.bold, color: green900),
              ),
              Text(activity, style: GoogleFonts.nunito(color: green900)),
            ]),
          ],
        ),
      ),
    );
  }

  Widget QuickAccessButton(String title, IconData icon, Function onPressed) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(icon),
      label: Text(title),
    );
  }
}
