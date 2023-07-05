import 'package:dcms_mobile_app/assets/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'assets/component.dart';

class AppointmentModel extends StatefulWidget {
  @override
  _AppointmentModelState createState() => _AppointmentModelState();
}

class _AppointmentModelState extends State<AppointmentModel> {
  final _formKey = GlobalKey<FormState>();
  final List<String> dentists = ['Dr. Smith', 'Dr. Johnson', 'Dr. Brown'];
  String? selectedDentist; // Changed to nullable type
  DateTime? selectedDateTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Appointment'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                      hintText: 'Patient Name',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
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
                            hintText: 'Preferred Date and Time',
                            hintTextDirection: TextDirection.ltr,
                            hintStyle: GoogleFonts.nunito(),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            suffixIcon: Icon(Icons.calendar_today),
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
                          borderRadius: BorderRadius.all(Radius.circular(10))),
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
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.medical_services_rounded),
                    contentPadding: EdgeInsets.symmetric(horizontal: 4),
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 16.0),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Additional Notes',
                    border: OutlineInputBorder(),
                    // suffixIcon: Icon(Icons.note_alt_rounded),
                    contentPadding: EdgeInsets.zero,
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
      // Add your logic here for handling the form submission
    }
  }
}
