import 'package:dcms_mobile_app/appointments.dart';
import 'package:dcms_mobile_app/appt_modal.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text('Dental Clinic Management System'),
        actions: [
          // User Profile (Replace with real data)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/profile_pic.jpg'),
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
            Center(
              child: Image.asset(
                'assets/logo.png',
                height: 100,
              ),
            ),
            SizedBox(height: 20),
            // Clinic Information
            Text(
              'Clinic Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ListTile(
              leading: Icon(Icons.location_on),
              title: Text('123 Main Street, City, Country'),
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('Phone: +123 456 7890'),
            ),
            ListTile(
              leading: Icon(Icons.access_time),
              title: Text('Working Hours: Mon-Fri, 9:00 AM - 6:00 PM'),
            ),
            ListTile(
              leading: Icon(Icons.medical_services),
              title: Text('Services Offered: Dental Check-up, Cleaning, etc.'),
            ),
            SizedBox(height: 20),
            // Home Page Content (News, Promotions, Quick Links, etc.)
            // You can customize this section based on your requirements

            // Quick Actions (Book Appointment, View Appointments, Contact Us, etc.)
            Wrap(
              spacing: 10,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Code to handle appointment booking
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AppointmentPage()),
                    );
                  },
                  child: Text('Book Appointment'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Code to view appointments
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AppointmentPage()),
                    );
                  },
                  child: Text('View Appointments'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Code to contact the clinic
                  },
                  child: Text('Contact Us'),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Upcoming Appointments
            Text(
              'Upcoming Appointments',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
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
                          child:
                              Icon(Icons.calendar_today, color: Colors.white),
                        ),
                        title: Text(upcomingAppointments[index]['date']!),
                        subtitle: Text(upcomingAppointments[index]['title']!),
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Code to handle quick action (e.g., navigate to appointment booking)
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AppointmentModel()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
