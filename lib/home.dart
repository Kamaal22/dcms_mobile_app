import 'dart:convert';

import 'package:dcms_mobile_app/assets/component.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'index.dart';
import 'package:dcms_mobile_app/appointments.dart';
import 'package:dcms_mobile_app/appt_modal.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String patient_id = '';
  late List<Map<String, String>> upcomingAppointments = [];

  late bool isDarkMode = false;

  Future<String> getPatientId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int? storedPatientID = pref.getInt('patient_id');
    return storedPatientID.toString();
  }

  Future<void> fetchInitialData() async {
    patient_id = await getPatientId();
    isDarkMode;
    fetchUpcomingAppointments(); // Fetch data when the widget is initialized
  }

  Future<void> fetchUpcomingAppointments() async {
    final response = await http.post(
      Uri.parse(API_ENDPOINT("appointment/fetch_upcoming.php")),
      body: {'patient_id': patient_id.toString()},
    );

    if (response.statusCode == 200) {
      print(response.body);
      final data = json.decode(response.body) as Map<String, dynamic>;
      if (data['status'] == 'success') {
        setState(() {
          upcomingAppointments = List<Map<String, String>>.from(
              data['data'].map((item) => _parseAppointmentData(item)));
        });
      } else {
        // Handle error case
        print('Error: ${data['message']}');
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(data['message'])));
      }
    } else {
      final data = json.decode(response.body) as Map<String, dynamic>;
      print('Error fetching data: ${data['message']}');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(data['message'])));
    }
  }

  Map<String, String> _parseAppointmentData(Map<String, dynamic> item) {
    return {
      'appointment_id': item['appointment_id'].toString(),
      'type': item['type'] ?? '',
      'status': item['status'] ?? '',
      'date': item['date'] ?? '',
      'time': item['time'] ?? '',
      'patient_id': item['patient_id'].toString(),
      'employee_id': item['employee_id'].toString(),
      'note': item['note'] ?? '*****************',
    };
  }

  @override
  void initState() {
    super.initState();
    fetchInitialData();
  }

  String appointmentTimeToString(String time) {
    TimeOfDay appointmentTime;
    try {
      List<String> timeComponents = time.split(':');
      int hour = int.parse(timeComponents[0]);
      int minute = int.parse(timeComponents[1]);
      appointmentTime = TimeOfDay(hour: hour, minute: minute);
      return appointmentTime.format(context);
    } catch (e) {
      // Handle parsing error or set a default time if needed.
      return "Invalid Time";
    }
  }

  @override
  Widget build(BuildContext context) {
    // Theme-related variables
    final isDarkMode =
        Provider.of<ThemeProvider>(context, listen: true).isDarkMode;
    final backgroundColor = isDarkMode ? Colors.grey[800] : Colors.grey[200];
    final textColor = isDarkMode ? Colors.white : Colors.blue[700];
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
      body: RefreshIndicator(
        onRefresh: fetchInitialData,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Clinic Information
              SizedBox(height: 100),
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
                      title: Text('Phone: 622405 / 0615 592560',
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
              // Buttons for actions
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
                            child: Text('No upcoming appointments',
                                style: GoogleFonts.poppins()),
                          )
                        : ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                                backgroundColor: backgroundColor, elevation: 0),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: upcomingAppointments.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  leading: Container(
                                    height: 35,
                                    width: 35,
                                    decoration: BoxDecoration(
                                        color: elevatedButtonColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50))),
                                    child: Icon(Icons.calendar_month_rounded,
                                        color: elevTextColor),
                                  ),
                                  title: Row(
                                    children: [
                                      Text(
                                        DateFormat('EEE, dd-MMM-yy').format(
                                            DateTime.parse(
                                                upcomingAppointments[index]
                                                    ['date']!)),
                                        style: GoogleFonts.poppins(),
                                      ),
                                      Text(" at " +
                                          appointmentTimeToString(
                                              upcomingAppointments[index]
                                                  ['time']!))
                                    ],
                                  ),
                                  subtitle: Text(
                                    upcomingAppointments[index]['note']!,
                                    style: GoogleFonts.syne(),
                                  ),
                                  trailing: Icon(Icons.arrow_forward),
                                  onTap: () {
                                    print(
                                        'View appointment details: ${upcomingAppointments[index]}');
                                  },
                                );
                              },
                            ),
                          ),
                  ],
                ),
              ),
              SizedBox(height: 400)
            ],
          ),
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
