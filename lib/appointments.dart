import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppointmentPage extends StatelessWidget {
  final List<Appointment> appointments = [
    Appointment(
      date: 'July 5, 2023',
      time: '10:00 AM',
      dentist: 'Dr. Smith',
      notes: 'Please arrive 10 minutes early.',
      status: 'arrived', // Add status value here
    ),
    Appointment(
      date: 'July 10, 2023',
      time: '2:30 PM',
      dentist: 'Dr. Johnson',
      notes: 'Bring your insurance card.',
      status: 'pending', // Add status value here
    ),
    Appointment(
      date: 'July 10, 2023',
      time: '2:30 PM',
      dentist: 'Dr. Johnson',
      notes: 'Bring your insurance card.',
      status: 'approved', // Add status value here
    ),
    Appointment(
      date: 'July 10, 2023',
      time: '2:30 PM',
      dentist: 'Dr. Johnson',
      notes: 'Bring your insurance card.',
      status: 'cancelled', // Add status value here
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
          return buildAppointmentCard(context, appointments[index]);
        },
      ),
    );
  }

  Widget buildAppointmentCard(BuildContext context, Appointment appointment) {
    Color statusColor;
    String statusText;

    switch (appointment.status) {
      case 'arrived':
        statusColor = Colors.blue[800]!;
        statusText = 'In room';
        break;
      case 'pending':
        statusColor = Colors.blueGrey;
        statusText = 'Pending';
        break;
      case 'approved':
        statusColor = Colors.green[800]!;
        statusText = 'Approved';
        break;
      case 'cancelled':
        statusColor = Colors.red[800]!;
        statusText = 'Cancelled';
        break;
      default:
        statusColor = Colors.grey[100]!;
        statusText = '';
    }

    return Card(
      elevation: 1,
      child: ListTile(
        title: Text(
          appointment.date,
          style: GoogleFonts.nunito(
            color: Colors.grey[800],
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Time: ${appointment.time}',
              style: GoogleFonts.nunito(
                color: Colors.blueGrey,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text('Dentist: ${appointment.dentist}'),
            if (appointment.notes.isNotEmpty)
              Text(
                'Notes: ${appointment.notes}',
                style: GoogleFonts.nunito(
                  color: Colors.grey[800],
                  fontStyle: FontStyle.italic,
                ),
              ),
            Row(
              children: [
                Text(
                  'Status: ',
                  style: GoogleFonts.nunito(
                    color: Colors.grey[800],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 20,
                  width: MediaQuery.of(context).size.width * 0.15,
                  color: statusColor,
                  child: Text(
                    statusText,
                    style: GoogleFonts.nunito(
                      color: Colors.grey[100],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          elevation: 2,
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                child: Text(
                  'View',
                  style: GoogleFonts.nunito(
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                value: 'view',
              ),
              PopupMenuItem(
                child: Text(
                  'Edit',
                  style: GoogleFonts.nunito(
                    color: Colors.lightBlue[500],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                value: 'edit',
              ),
              PopupMenuItem(
                child: Text(
                  'Cancel',
                  style: GoogleFonts.nunito(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                value: 'cancel',
              ),
            ];
          },
          onSelected: (value) {
            if (value == 'view') {
              // Add your logic for viewing the appointment
            } else if (value == 'edit') {
              // Add your logic for editing the appointment
              cancelAppointment(context, appointment);
            } else if (value == 'cancel') {
              // Add your logic for canceling the appointment
              cancelAppointment(context, appointment);
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
  final String status;

  Appointment({
    required this.date,
    required this.time,
    required this.dentist,
    this.notes = '',
    this.status = '',
  });
}

void cancelAppointment(BuildContext context, Appointment appointment) {
  showDialog(
    useSafeArea: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        titleTextStyle: GoogleFonts.nunito(
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey,
          fontSize: 20,
        ),
        contentTextStyle: GoogleFonts.nunito(color: Colors.blueGrey),
        elevation: 0,
        scrollable: true,
        title: Text('Confirm Cancellation'),
        content: Text('Are you sure you want to cancel the appointment?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'No',
              style: GoogleFonts.nunito(),
            ),
          ),
          TextButton(
            onPressed: () {
              // Cancel appointment logic here
              Navigator.pop(context);
            },
            child: Text(
              'Yes',
              style: GoogleFonts.nunito(color: Colors.red[300]),
            ),
          ),
        ],
      );
    },
  );
}
