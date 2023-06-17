// import 'dart:convert';

// import 'package:dcms_mobile_app/Model/mysql.dart';
// import 'package:dcms_mobile_app/assets/component.dart';
import 'package:dcms_mobile_app/appt_modal.dart';
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
  List<Appointment> appointments = [];

  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username');
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
        )
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
        title: Text(
          'Appointment Page',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          Appointment appointment = appointments[index];
          return AppointmentItem(
            name: 'Abdi',
            startTime: DateFormat('hh:mm a').format(
              DateTime.parse(appointment.startDate),
            ),
            startDate: DateFormat('dd-MM-yyyy').format(
              DateTime.parse(appointment.startDate),
            ),
            endDate: DateFormat('dd-MM-yyyy').format(
              DateTime.parse(appointment.endDate),
            ),
            serviceName: 'Tooth Extraction',
            dentistName: 'Mohamed Ali',
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0.0,
        backgroundColor: primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.0),
        ),
        onPressed: () {
          // Handle the floating action button press
          toPage(context, AppointmentModel());
        },
        child: icon(Icons.add_rounded, white, 50),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.green,
                ),
                child: Text(
                  startDate,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue,
                ),
                child: Text(
                  startTime,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.red,
                ),
                child: Text(
                  endDate,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.0),
          Text(
            'Appointer: $name',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          Text(
            'Service: $serviceName',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          Text(
            'Dentist: $dentistName',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
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
