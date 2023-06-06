// import 'dart:convert';

// import 'package:dcms_mobile_app/Model/mysql.dart';
// import 'package:dcms_mobile_app/assets/component.dart';
import 'package:dcms_mobile_app/assets/colors.dart';
import 'package:dcms_mobile_app/assets/component.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'assets/colors.dart';
import 'package:intl/intl.dart';

class AppointmentPage extends StatefulWidget {
  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  String? username;
  List<Appointment> appointments =
      []; // Assuming you have a list of Appointment objects

  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username');
      // Simulating the data retrieval from the database
      appointments = [
        Appointment(
          appointmentId: 1,
          type: 'Walk-in',
          status: 'Pending',
          startDate: '2023-05-30 07:25:00',
          endDate: '2023-05-31 23:29:00',
          patientId: 1,
          employeeId: 6,
          serviceId: 1,
        ),
        Appointment(
          appointmentId: 3,
          type: 'Walk-in',
          status: 'Arrived',
          startDate: '2023-05-29 07:34:00',
          endDate: '2023-05-31 23:38:00',
          patientId: 1,
          employeeId: 6,
          serviceId: 1,
        ),
      ];
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Appointment Page',
            style: GoogleFonts.nunito(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          Appointment appointment = appointments[index];
          return AppointmentItem(
            name: 'Abdi', // Pass the appropriate patient name here
            startTime: DateFormat('hh:mm a').format(
              DateTime.parse(appointment.startDate),
            ),
            startDate: DateFormat('dd-MM-yyyy').format(
              DateTime.parse(appointment.startDate),
            ),
            endDate: DateFormat('dd-MM-yyyy').format(
              DateTime.parse(appointment.endDate),
            ),
            serviceName:
                'Tooth Extraction', // Pass the appropriate service name here
            dentistName:
                'Mohamed Ali', // Pass the appropriate dentist name here
          );
        },
      ),
    );
  }
}

class AppointmentItem extends StatelessWidget {
  final String name;
  final String startTime;
  final String startDate;
  final String endDate;
  final String serviceName;
  final String dentistName;

  const AppointmentItem({
    required this.name,
    required this.startTime,
    required this.startDate,
    required this.endDate,
    required this.serviceName,
    required this.dentistName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
      padding: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: spaceBetween,
                      children: [
                        Container(
                          padding: MP_all(2),
                          decoration: radius(10, green, transparent),
                          child: Text(
                            '$startDate',
                            style: GoogleFonts.nunito(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: white,
                            ),
                          ),
                        ),
                        Container(
                          padding: MP_all(2),
                          decoration: radius(10, blue, transparent),
                          child: Text(
                            startTime,
                            style: GoogleFonts.nunito(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: white,
                            ),
                          ),
                        ),
                        Container(
                          padding: MP_all(2),
                          decoration: radius(10, red, transparent),
                          child: Text(
                            '$endDate',
                            style: GoogleFonts.nunito(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      children: [
                        Text(
                          'Appointer: ',
                          style: GoogleFonts.nunito(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          ' $name',
                          style: GoogleFonts.nunito(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Service: ',
                          style: GoogleFonts.nunito(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          ' $serviceName',
                          style: GoogleFonts.nunito(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Dentist:',
                          style: GoogleFonts.nunito(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          ' $dentistName',
                          style: GoogleFonts.nunito(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Appointment {
  final int appointmentId;
  final String type;
  final String status;
  final String startDate;
  final String endDate;
  final int patientId;
  final int employeeId;
  final int serviceId;

  Appointment({
    required this.appointmentId,
    required this.type,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.patientId,
    required this.employeeId,
    required this.serviceId,
  });
}
