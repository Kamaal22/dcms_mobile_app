import 'package:dcms_mobile_app/assets/colors.dart';
import 'package:dcms_mobile_app/assets/component.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String firstname = ''; // Declare firstname variable
  String lastname = ''; // Declare lastname variable

  Future<void> getInfo() async {
    final prefs = await SharedPreferences.getInstance();

    String? storedFirstname = prefs.getString('first_name');
    String? storedLastname = prefs.getString('last_name');

    if (storedFirstname != null && storedLastname != null) {
      // Data is available in shared preferences
      setState(() {
        firstname = storedFirstname; // Assign value to firstname variable
        lastname = storedLastname; // Assign value to lastname variable
      });
      print('First Name: $firstname');
      print('Last Name: $lastname');
    } else {
      // Data is not available in shared preferences
      print('No data found in shared preferences.');
    }
  }

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        toolbarHeight: 200,
        title: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  textAlign: TextAlign.right,
                  'Welcome, $firstname $lastname', // Display the firstname and lastname
                  style: GoogleFonts.nunito(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.blue[700]),
                ),
              ],
            ),
            Divider()
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: MP_LTRB(10, 50, 10, 0),
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
                  AppointmentCard('', 'July 5, 2023', '10:00 AM', 'Mohamed',
                      'Afrax', 'Abdulaah', 'Cali'),
                  AppointmentCard('', 'July 5, 2023', '11:00 AM', 'Kim', 'Yong',
                      'Jama', 'Yasin'),
                  AppointmentCard('', 'July 5, 2023', '01:00 PM', 'Smith',
                      'John', 'Mary', 'Johnson'),
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
                    QuickAccessButton('Appointments', Icons.event_rounded, () {
                      // Add your logic for navigating to the appointments page
                    }),
                    QuickAccessButton('Add Appointment', Icons.add_rounded, () {
                      // Add your logic for navigating to the add appointment page
                    }),
                    QuickAccessButton(
                        'Dental Record', Icons.description_rounded, () {
                      // Add your logic for navigating to the dental record page
                    }),
                    QuickAccessButton('Profile', Icons.account_circle_rounded,
                        () {
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

  Widget AppointmentCard(
    String appointmentId,
    String date,
    String time,
    String patientFirstName,
    String patientLastName,
    String dentistFirstName,
    String dentistLastName,
  ) {
    return Card(
      elevation: 0,
      color: Colors.blueGrey[50],
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Text(
                //   'Appointment ID: $appointmentId',
                //   style: GoogleFonts.nunito(
                //     fontWeight: FontWeight.bold,
                //     color: Colors.blue[700],
                //   ),
                // ),
                Text(
                  'Date: $date',
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
                ),
                Text(
                  'Time: $time',
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    color: Colors.blue[900],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Patient: $patientFirstName $patientLastName',
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Dentist: $dentistFirstName $dentistLastName',
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
                ),
              ],
            )
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
      onPressed: onPressed as void Function()?,
      label: Text(title),
      icon: Icon(icon),
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(0),
        textStyle: MaterialStateProperty.all<TextStyle?>(GoogleFonts.nunito()),
        backgroundColor: MaterialStateProperty.all<Color?>(Colors.transparent),
        foregroundColor: MaterialStateProperty.all<Color?>(Colors.blueGrey),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry?>(null),
        fixedSize: MaterialStateProperty.all<Size?>(
          Size(MediaQuery.of(context).size.width, 30),
        ),
        side: MaterialStateProperty.all<BorderSide?>(
          BorderSide(width: 1, color: Colors.blueGrey),
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }
}
