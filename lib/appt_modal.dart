import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'appt_functions.dart';
// import 'assets/colors.dart';
import 'assets/component.dart';
import 'package:http/http.dart' as http;

Color kAppBarTitleColor = Colors.blueGrey[900]!;
Color kRefreshIndicatorColor = Colors.blueGrey;
Color kLabelTextColor = Colors.blueGrey;
Color kInputBorderRadiusColor = Colors.blueGrey;
Color kCalendarIconColor = Colors.blue[800]!;
Color kTimePickerIconColor = Colors.blue[800]!;
Color kSubmitButtonColor = Colors.blue[900]!;
bool maleSelected = false;
bool femaleSelected = false;

class AppointmentModel extends StatefulWidget {
  @override
  _AppointmentModelState createState() => _AppointmentModelState();
}

class _AppointmentModelState extends State<AppointmentModel> {
  final _formKey = GlobalKey<FormState>();

  // Form fields
  DateTime? date;
  TimeOfDay? time;
  TextEditingController note = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Make an appointment',
          style: GoogleFonts.nunito(
            color: Colors.blueGrey,
            fontSize: 30,
          ),
        ),
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 200,
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 100, left: 10, right: 10),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 10),
            children: [
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Choose date and time:",
                    style: GoogleFonts.nunito(
                      fontSize: 18,
                      color: Colors.blueGrey,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Date',
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the appointment date';
                    }
                    return null;
                  },
                  onTap: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2030),
                    ).then((selectedDate) {
                      if (selectedDate != null) {
                        setState(() {
                          date = selectedDate;
                        });
                      }
                    });
                  },
                  readOnly: true,
                  controller: TextEditingController(
                    text: date != null
                        ? DateFormat('yyyy-MM-dd').format(date!)
                        : '',
                  ),
                ),
                trailing: Ink(
                  color: Colors.blue[50],
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.calendar_today_rounded,
                    ),
                    color: kCalendarIconColor,
                    iconSize: 30,
                  ),
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Time',
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the appointment time';
                    }
                    return null;
                  },
                  onTap: () {
                    showCustomTimePicker(context).then((selectedTime) {
                      if (selectedTime != null) {
                        setState(() {
                          time = selectedTime;
                        });
                      }
                    });
                  },
                  readOnly: true,
                  controller: TextEditingController(
                    text: time != null ? time!.format(context) : '',
                  ),
                ),
                trailing: Ink(
                  color: Colors.blue[50],
                  child: IconButton(
                    onPressed: () {
                      showCustomTimePicker(context).then((selectedTime) {
                        if (selectedTime != null) {
                          setState(() {
                            time = selectedTime;
                          });
                        }
                      });
                    },
                    icon: Icon(
                      Icons.access_time_rounded,
                    ),
                    color: kTimePickerIconColor,
                    iconSize: 30,
                  ),
                ),
              ),
              TextFormField(
                controller: note,
                maxLines: 5,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  labelText: "Add note",
                  labelStyle: GoogleFonts.nunito(),
                  alignLabelWithHint: true,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        onPressed: submitForm,
        highlightElevation: 0.5,
        backgroundColor: Colors.blue[700],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Transform.rotate(
            angle: -45,
            child: Icon(
              Icons.send_rounded,
              size: 30,
              semanticLabel: "submit appointment",
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();

      // Create a new appointment object
      var appointment = {
        'type': 'Online',
        'status': 'Pending',
        'date': DateFormat('yyyy-MM-dd').format(date!),
        'time': time!.format(context),
        'patient_id': 1.toString(),
        'employee_id': null.toString(),
        'note': note.text.trim()
      };

      // Send the appointment data to the server
      try {
        var response = await http.post(
          Uri.parse('http://192.168.234.163/appt/submit_appt.php'),
          body: appointment,
        );

        if (response.statusCode == 200 && response.body.isNotEmpty) {
          var responseData = response.body;
          print(responseData);
          // Process the response data here
          if (responseData == 'success') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  style: GoogleFonts.nunito(),
                  'Appointment created successfully',
                ),
                backgroundColor: Colors.green,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  style: GoogleFonts.nunito(),
                  'Failed to create appointment!',
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                style: GoogleFonts.nunito(),
                'Failed to create appointment?',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error: $error',
              style: GoogleFonts.nunito(),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<String> getPatientIdFromSharedPreferences() async {
    // Replace this with your actual code to retrieve the patient ID from Shared Preferences
    // For example:
    final prefs = await SharedPreferences.getInstance();
    final patientId = prefs.getString('user_id');
    return patientId.toString();
  }
}
