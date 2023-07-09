import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'appt_functions.dart';
import 'assets/colors.dart';
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
  String? firstName;
  String? middleName;
  String? lastName;
  int? patientId;
  int? employeeId;
  List<String> services = [];

  bool _isLoading = false;

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });

    // Fetch employee data from the API
    await fetchEmployeesFromApi();

    // Fetch service data from the API
    await fetchServicesFromApi();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Make an appointment',
            style: GoogleFonts.nunito(color: kAppBarTitleColor)),
        // backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: RefreshIndicator(
        backgroundColor: Colors.blueGrey[50],
        strokeWidth: 2,
        color: kRefreshIndicatorColor,
        onRefresh: _refreshData,
        child: Padding(
          padding: EdgeInsets.only(top: 100, left: 10, right: 10),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 10),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Enter personal info:",
                        style: GoogleFonts.nunito(
                            fontSize: 18, color: Colors.blueGrey))
                  ],
                ),
                SizedBox(height: 10),
                Row(children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'First Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(0)),
                          borderSide: BorderSide(
                            color: kInputBorderRadiusColor,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the first name';
                        } else if (value.contains(RegExp(r'[0-9]'))) {
                          return 'Please don\'t add numbers';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        firstName = value;
                      },
                      style: GoogleFonts.nunito(),
                      keyboardType: TextInputType.name,
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Middle Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(0)),
                          borderSide: BorderSide(
                            color: kInputBorderRadiusColor,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the middle name';
                        } else if (value.contains(RegExp(r'[0-9]'))) {
                          return 'Please don\'t add numbers';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        middleName = value;
                      },
                      style: GoogleFonts.nunito(),
                      keyboardType: TextInputType.name,
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Last Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(0)),
                          borderSide: BorderSide(
                            color: kInputBorderRadiusColor,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the last name';
                        } else if (value.contains(RegExp(r'[0-9]'))) {
                          return 'Please don\'t add numbers';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        lastName = value;
                      },
                      style: GoogleFonts.nunito(),
                      keyboardType: TextInputType.name,
                    ),
                  )
                ]),
                SizedBox(height: 10),
                Container(
                  decoration: radius(0, transparent, blueGrey),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Text("Choose Gender:",
                          style: GoogleFonts.nunito(fontSize: 16)),
                      Checkbox(
                        value: maleSelected,
                        onChanged: (bool? newValue) {
                          setState(() {
                            maleSelected = newValue ?? false;
                            if (maleSelected) {
                              femaleSelected = false;
                            }
                          });
                        },
                      ),
                      Text("Male", style: GoogleFonts.nunito()),
                      Checkbox(
                        value: femaleSelected,
                        onChanged: (bool? newValue) {
                          setState(() {
                            femaleSelected = newValue ?? false;
                            if (femaleSelected) {
                              maleSelected = false;
                            }
                          });
                        },
                      ),
                      Text("Female", style: GoogleFonts.nunito()),
                    ],
                  ),
                ),
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Choose date and time:",
                        style: GoogleFonts.nunito(
                            fontSize: 18, color: Colors.blueGrey))
                  ],
                ),

                SizedBox(height: 10),
                // //////////////////////////////////////////////////////////////////////////////////////////////////
                // //////////////////////////////////////////////////////////////////////////////////////////////////
                // //////////////////////////////////////////////////////////////////////////////////////////////////
                // //////////////////////////////////////////////////////////////////////////////////////////////////
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Date',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(0)),
                        borderSide: BorderSide(
                          color: kInputBorderRadiusColor,
                        ),
                      ),
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
                            // Handle the selected date
                            // For example, you can store it in a variable or update a text field
                            date = selectedDate;
                          });
                        }
                      });
                    },
                    style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
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
                      icon: Icon(Icons.calendar_today_rounded),
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
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(0)),
                        borderSide: BorderSide(
                          color: kInputBorderRadiusColor,
                        ),
                      ),
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
                            // Handle the selected time
                            // For example, you can store it in a variable or update a text field
                            time = selectedTime;
                          });
                        }
                      });
                    },
                    readOnly: true,
                    style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
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
                              // Handle the selected time
                              // For example, you can store it in a variable or update a text field
                              time = selectedTime;
                            });
                          }
                        });
                      },
                      icon: Icon(Icons.access_time_rounded),
                      color: kTimePickerIconColor,
                      iconSize: 30,
                    ),
                  ),
                ),
                TextFormField(
                  maxLines: 5,
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      labelText: "Add note",
                      labelStyle: GoogleFonts.nunito(),
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(0)))),
                )
              ],
            ),
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
        'patient_id': patientId.toString(),
        'employee_id': employeeId.toString(),
        'services': services.join(','),
        'first_name': firstName!,
        'middle_name': middleName!,
        'last_name': lastName!,
      };

      // Send the appointment data to the server
      try {
        var response = await http.post(
          Uri.parse('http://192.168.129.163/appt/submit_appt.php'),
          body: appointment,
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Appointment created successfully',
              ),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Failed to create appointment',
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
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
