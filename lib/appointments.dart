import 'package:flutter/material.dart';

class AppointmentPage extends StatelessWidget {
  final List<Appointment> appointments = [
    Appointment(
      date: 'July 5, 2023',
      time: '10:00 AM',
      dentist: 'Dr. Smith',
      notes: 'Please arrive 10 minutes early.',
    ),
    Appointment(
      date: 'July 10, 2023',
      time: '2:30 PM',
      dentist: 'Dr. Johnson',
      notes: 'Bring your insurance card.',
    ),
    // Add more appointments as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointments'),
      ),
      body: ListView.builder(
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          return buildAppointmentCard(appointments[index]);
        },
      ),
    );
  }

  Widget buildAppointmentCard(Appointment appointment) {
    return Card(
      elevation: 2,
      child: ListTile(
        title: Text(appointment.date),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Time: ${appointment.time}'),
            Text('Dentist: ${appointment.dentist}'),
            appointment.notes.isNotEmpty
                ? Text('Notes: ${appointment.notes}')
                : SizedBox.shrink(),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                child: Text('View'),
                value: 'view',
              ),
              PopupMenuItem(
                child: Text('Edit'),
                value: 'edit',
              ),
              PopupMenuItem(
                child: Text('Cancel'),
                value: 'cancel',
              ),
            ];
          },
          onSelected: (value) {
            if (value == 'view') {
              // Add your logic for viewing the appointment
            } else if (value == 'edit') {
              // Add your logic for editing the appointment
            } else if (value == 'cancel') {
              // Add your logic for canceling the appointment
            }
          },
        ),
      ),
    );
  }
}

class Appointment {
  final String date;
  final String time;
  final String dentist;
  final String notes;

  Appointment({
    required this.date,
    required this.time,
    required this.dentist,
    this.notes = '',
  });
}
