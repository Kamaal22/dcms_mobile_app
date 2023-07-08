import 'package:dcms_mobile_app/assets/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'assets/component.dart';

class AppointmentModel extends StatefulWidget {
  @override
  _AppointmentModelState createState() => _AppointmentModelState();
}

class _AppointmentModelState extends State<AppointmentModel> {
  String pid = "";
  String pfname = "";
  String plname = "";

  getUserdata() async {
    // Make API call to retrieve user data
    SharedPreferences prefs = await SharedPreferences.getInstance();
    pid = prefs.getString('user_id')!;
    pfname = prefs.getString('firstname')!;
    plname = prefs.getString('lastname')!;
  }

  final _formKey = GlobalKey<FormState>();
  final List<String> dentists = ['Dr. Smith', 'Dr. Johnson', 'Dr. Brown'];
  String? selectedDentist; // Changed to nullable type
  DateTime? selectedDateTime;
  TextEditingController _additionalNotesController = TextEditingController();
  TextEditingController _patientNameController = TextEditingController();
  TextEditingController _typeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUserdata();
  }

  @override
  void dispose() {
    _additionalNotesController.dispose();
    _patientNameController.dispose();
    _typeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text('Add Appointment'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Container(
              color: Colors.red[50],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Patient ID: $pid",
                    style: GoogleFonts.nunito(),
                  ),
                  TextFormField(
                    readOnly: true,
                    controller: _patientNameController,
                    decoration: InputDecoration(
                        hintText: '$pfname $plname',
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter patient name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          readOnly: true,
                          onTap: _selectDateTime,
                          decoration: InputDecoration(
                              hintText: 'Preferred Date and Time ' +
                                  (selectedDateTime != null
                                      ? selectedDateTime.toString()
                                      : ''),
                              hintTextDirection: TextDirection.ltr,
                              hintStyle: GoogleFonts.nunito(),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              suffixIcon: Icon(Icons.event_rounded),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10)),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select preferred date and time';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  DropdownButtonFormField<String>(
                    alignment: Alignment.bottomCenter,
                    elevation: 0,
                    hint: Text('Select Dentist'),
                    isExpanded: false,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    dropdownColor: deepPurple300,
                    focusColor: deepPurple50,
                    style: GoogleFonts.nunito(),
                    isDense: false,
                    value: selectedDentist,
                    onChanged: (value) {
                      setState(() {
                        selectedDentist = value;
                      });
                    },
                    items: dentists.map((dentist) {
                      return DropdownMenuItem<String>(
                        value: dentist,
                        child: Text(dentist),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                        hintText: 'Select Dentist',
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a dentist';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    textAlign: TextAlign.left,
                    controller: _typeController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.medical_services_rounded),
                      contentPadding: EdgeInsets.symmetric(horizontal: 4),
                    ),
                    maxLines: 3,
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    textAlign: TextAlign.start,
                    controller: _additionalNotesController,
                    decoration: InputDecoration(
                      hintText: 'Additional Notes',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      // suffixIcon: Icon(Icons.note_alt_rounded),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                    maxLines: 3,
                  ),
                  SizedBox(height: 32.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: blue800,
                        elevation: 0.0,
                        textStyle: GoogleFonts.nunito()),
                    onPressed: _submitForm,
                    child: Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _selectDateTime() async {
    final DateTime? pickedDateTime = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDateTime != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          selectedDateTime = DateTime(
            pickedDateTime.year,
            pickedDateTime.month,
            pickedDateTime.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() == true) {
      // Process the form data and schedule the appointment
      String patientName = _patientNameController.text;
      String additionalNotes = _additionalNotesController.text;
      String type = _typeController.text;
      String appointmentStatus = 'Scheduled'; // Set the default status
      String date = selectedDateTime!.toIso8601String().split('T')[0];
      String time =
          selectedDateTime!.toIso8601String().split('T')[1].substring(0, 5);

      // Make API call to save the appointment
      saveAppointment(
          patientName, additionalNotes, type, appointmentStatus, date, time);
    }
  }

  void saveAppointment(String patientName, String additionalNotes, String type,
      String status, String date, String time) async {
    // API endpoint URL
    final String apiUrl =
        'https://your-api-endpoint-url.com/save-appointment.php';

    // Create the request body
    Map<String, dynamic> requestBody = {
      'patient_name': patientName,
      'additional_notes': additionalNotes,
      'type': type,
      'status': status,
      'date': date,
      'time': time,
    };

    try {
      // Send the POST request to the API endpoint
      http.Response response =
          await http.post(Uri.parse(apiUrl), body: requestBody);

      if (response.statusCode == 200) {
        // Successful response
        var responseData = json.decode(response.body);
        print(responseData);
        // Handle the response data
        // Add your code here to handle the response according to your API
      } else {
        // Error occurred
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      // Exception occurred
      print('Exception: $error');
    }
  }
}
