import 'dart:convert';

import 'package:dcms_mobile_app/assets/component.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';
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
    String? storedPatientID = pref.getString('patient_id');
    return storedPatientID.toString();
  }

  Future<void> fetchUpcomingAppointments() async {
    final isConnected = await checkNetConn();

    if (!isConnected) {
      // snackbar(context, Colors.red[50], Colors.red[800],
      //     "No Internet Connection...", 2);
      print("No Internet Connection...");
      return;
    }

    final response = await http.post(
      Uri.parse(API_ENDPOINT("appointment/fetch_upcoming.php")),
      body: {'patient_id': patient_id.toString()},
    ).timeout(Duration(seconds: 10));

    if (response.statusCode == 200) {
      // print(response.body);
      final data = json.decode(response.body) as Map<String, dynamic>;
      if (data['status'] == 'success') {
        setState(() {
          upcomingAppointments = List<Map<String, String>>.from(
              data['data'].map((item) => _parseAppointmentData(item)));
        });
      } else {
        // Handle error case
        print('Error: ${data['data']}');
        snackbar(
            context, Colors.red[50], Colors.red[800], data['data'] ?? "", 2);
      }
    } else {
      final data = json.decode(response.body) as Map<String, dynamic>;
      print('Error fetching data: ${data['data']}');
      snackbar(context, Colors.red[50], Colors.red[800], data['message'], 2);
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
      'dentist': item['dentist'].toString(),
      'patient': item['patient'].toString(),
      'note': item['note'] ?? " ",
    };
  }

  Future<void> fetchInitialData() async {
    patient_id = await getPatientId();
    isDarkMode;
    Future.delayed(Duration(seconds: 10), () {
      setState(() {
        print("Fetching upcoming appointments...");
        fetchUpcomingAppointments();
      });
    });
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

  void _launchPhoneApp() async {
    final phoneNumber = '0615592560'; // Replace with your clinic's phone number
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrlString(phoneUri.toString())) {
      await launchUrlString(phoneUri.toString());
    } else {
      snackbar(
          context, Colors.red[50], Colors.red[800], "Something went wrong!", 2);
      print("Coudn't launch phone app");
    }
  }

  void _launchEmailApp() async {
    final emailAddress = 'Kamaaludiin792@gmail.com';
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: emailAddress,
      queryParameters: {'subject': 'Contact Inquiry'},
    );
    if (await canLaunchUrlString(emailUri.toString())) {
      await launchUrlString(emailUri.toString());
    } else {
      snackbar(
          context, Colors.red[50], Colors.red[800], "Something went wrong!", 2);
      print("Coudn't launch email app");
    }
  }

  void _showContactDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Contact Us'),
          content: Text('Choose how you want to contact us:'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _launchPhoneApp();
              },
              child: Text('Phone'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _launchEmailApp();
              },
              child: Text('Email'),
            ),
          ],
        );
      },
    );
  }

  void _editAppointment(Map<String, String> appointment) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditAppointmentPage(appointment: appointment),
      ),
    );
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
    final scaffoldDarkTheme = isDarkMode ? Colors.grey[900] : Colors.grey[50];

// fetch the appointments after every five seconds
    Future.delayed(Duration(seconds: 10), () {
      setState(() {
        print("Fetching upcoming appointments...");
        fetchUpcomingAppointments();
      });
    });

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
          )),
      backgroundColor: scaffoldDarkTheme,
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
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize:
                          Size(MediaQuery.of(context).size.width * 0.45, 50),
                      elevation: 0,
                      backgroundColor: elevatedButtonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            topLeft: Radius.circular(10)),
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
                        style: GoogleFonts.syne(
                            color: elevTextColor, fontSize: 18)),
                  ),
                  SizedBox(width: 1),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize:
                          Size(MediaQuery.of(context).size.width * 0.45, 50),
                      elevation: 0,
                      backgroundColor: elevatedButtonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(10),
                            topRight: Radius.circular(10)),
                      ),
                    ),
                    onPressed: () {
                      _showContactDialog();
                    },
                    child: Text('Contact Us',
                        style: GoogleFonts.syne(
                            color: elevTextColor, fontSize: 18)),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Upcoming Appointments
              Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
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
                        : ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.symmetric(vertical: 2),
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
                                  upcomingAppointments[index]['patient']! +
                                      "\n\n" +
                                      upcomingAppointments[index]['note']!,
                                  style: GoogleFonts.syne(),
                                ),
                                trailing: Icon(Icons.arrow_forward),
                                onTap: () {
                                  print(
                                      'View appointment details: ${upcomingAppointments[index]}');
                                  _editAppointment(upcomingAppointments[index]);
                                },
                              );
                            },
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

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///
class EditAppointmentPage extends StatefulWidget {
  final Map<String, String> appointment;

  EditAppointmentPage({required this.appointment});

  @override
  _EditAppointmentPageState createState() => _EditAppointmentPageState();
}

class _EditAppointmentPageState extends State<EditAppointmentPage> {
  late TextEditingController noteController;
  late DateTime selectedDate;
  late TimeOfDay selectedTime;
  late String? type = widget.appointment['type'];
  @override
  void initState() {
    super.initState();
    noteController =
        TextEditingController(text: widget.appointment['note'] ?? '');

    // Initialize date and time values from the existing appointment
    selectedDate = DateTime.parse(widget.appointment['date']!);
    List<String> timeComponents = widget.appointment['time']!.split(':');
    selectedTime = TimeOfDay(
      hour: int.parse(timeComponents[0]),
      minute: int.parse(timeComponents[1]),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    final isDarkMode = themeProvider.isDarkMode;
    final scaffoldDarkTheme = isDarkMode ? Colors.grey[900] : Colors.grey[50];

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Appointment'),
      ),
      backgroundColor: scaffoldDarkTheme,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Appointment Details:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Date: ${DateFormat('EEE, dd-MMM-yy').format(selectedDate)}'),
            Text('Time: ${selectedTime.format(context)}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _selectDate,
              child: Text('Select Date'),
            ),
            ElevatedButton(
              onPressed: _selectTime,
              child: Text('Select Time'),
            ),
            SizedBox(height: 20),
            Text(
              'Edit Note:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              controller: noteController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Add a note...',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _saveChanges();
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveChanges() {
    // Update the appointment with the edited values
    widget.appointment['date'] = selectedDate.toString();
    widget.appointment['time'] = selectedTime.format(context);
    widget.appointment['note'] = noteController.text;

    // Perform any logic to save the changes, such as making API calls or updating local data

    // Navigate back to the previous page
    Navigator.pop(context);
  }
}
