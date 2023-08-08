import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';

import 'appointments.dart';
import 'assets/component.dart';
import 'index.dart';

import 'package:google_fonts/google_fonts.dart';

class AppointmentEditPage extends StatefulWidget {
  final String appointmentId;
  final int patientId;
  final String appointmentDate;
  final String appointmentTime;
  final String appointmentType;
  final String appointmentNote;

  AppointmentEditPage({
    required this.appointmentId,
    required this.patientId,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.appointmentType,
    required this.appointmentNote,
  });

  @override
  State<AppointmentEditPage> createState() => _AppointmentEditPageState();
}

class _AppointmentEditPageState extends State<AppointmentEditPage> {
  DateTime? date;
  TimeOfDay? time;
  String appointmentType = '';
  bool _validate = false;

  final noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    appointmentType = widget.appointmentType;

    date = DateFormat('yyyy-MM-dd').parse(widget.appointmentDate);
    time = TimeOfDay.fromDateTime(
        DateFormat('HH:mm').parse(widget.appointmentTime));
    noteController.text = widget.appointmentNote;
    appointmentType = widget.appointmentType;
  }

  Future<void> submitForm() async {
    if (_validate) {
      return;
    }

    var formattedDate = DateFormat('yyyy-MM-dd').format(date!);
    var formattedTime = time!.format(context);
    var type = widget.appointmentType;
    var appointment_id = widget.appointmentId;
    var patient_id = widget.patientId;

    var requestBody = {
      "appointment_id": appointment_id.toString(),
      'type': type,
      'status': 'Pending',
      'date': formattedDate,
      'time': formattedTime,
      'patient_id': patient_id.toString(),
      'note': noteController.text.trim().toString(),
    };

    print('Request Body: $requestBody'); // Debugging

    var response = await http.post(
      Uri.parse(API_ENDPOINT("appointment/update_appt.php")),
      body: requestBody,
    );

    try {
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        var responseData = json.decode(response.body);
        var status = responseData['status'];
        print('Response Body: ${response.body}');
        print('Response Data: $responseData');
        if (status == 'success') {
          showSnackBarWithMessage(
              'Appointment updated successfully', Colors.green);
          setState(() {
            date = DateTime.now();
            time = TimeOfDay.now();
            noteController.clear();
          });
          Navigator.pop(context);
        } else if (status == 'errorT') {
          showSnackBarWithMessage(
              'Time has already been appointed. Select another time!',
              Colors.red);
        } else {
          showSnackBarWithMessage(
              'Failed to update appointment!' + responseData.toString(),
              Colors.red);
        }
      } else {
        var responseData = json.decode(response.body);
        showSnackBarWithMessage(
            'Failed to update appointment: ' + responseData.toString(),
            Colors.red);
      }
    } catch (error) {
      print('Response Body: ${response.body}'); // Debugging
      showSnackBarWithMessage('Error: $error', Colors.red);
    }
  }

  void showSnackBarWithMessage(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: backgroundColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    final isDarkMode = themeProvider.isDarkMode;
    final textColor = isDarkMode ? Colors.white : Colors.blue[700];
    final inputColor = isDarkMode ? Colors.blue[800] : Colors.blue[100];
    final elevatedButtonColor = isDarkMode ? Colors.white : Colors.blue[800];
    final backgroundColor = isDarkMode ? Colors.grey[800] : Colors.grey[100];
    final iHeadColor = isDarkMode ? Colors.white : Colors.blue[800];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text(
          'Update Appointment',
          style: GoogleFonts.poppins(color: iHeadColor),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: iHeadColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 500,
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Appointment Form',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          date = DateTime.now();
                          time = TimeOfDay.now();
                          noteController.clear();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Text(
                        'Clear',
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Form(
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    children: [
                      SizedBox(height: 20),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: InkWell(
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2030),
                              initialDate: this.date ?? DateTime.now(),
                            );

                            if (date != null) {
                              setState(() {
                                _validate = false;
                                this.date = date;
                              });
                            }
                          },
                          child: IgnorePointer(
                            ignoring: true,
                            child: TextFormField(
                                controller: TextEditingController(
                                  text: this.date != null
                                      ? DateFormat('yyyy-MM-dd')
                                          .format(this.date!)
                                      : '',
                                ),
                                style: GoogleFonts.poppins(color: iHeadColor),
                                decoration: InputDecoration(
                                  labelText: 'Date',
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                  focusColor: isDarkMode
                                      ? Colors.blue[800]
                                      : Colors.blue[100],
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    borderSide:
                                        BorderSide(width: 2, color: textColor!),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                        width: 1, color: inputColor!),
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter the appointment Date';
                                  }
                                  return null;
                                },
                                readOnly: true),
                          ),
                        ),
                        trailing: Container(
                          height: 50,
                          width: 50,
                          color: elevatedButtonColor,
                          child: IconButton(
                            onPressed: () async {
                              final selectedDate = await showDatePicker(
                                context: context,
                                firstDate: DateTime(2023),
                                lastDate: DateTime(2024),
                                initialDate: date ?? DateTime.now(),
                              );
                              if (selectedDate != null) {
                                setState(() {
                                  date = selectedDate;
                                });
                              }
                            },
                            icon: Icon(
                              Icons.calendar_today,
                            ),
                            color: isDarkMode ? Colors.grey[800] : Colors.white,
                            iconSize: 30,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: InkWell(
                          onTap: () async {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: this.time ?? TimeOfDay.now(),
                            );

                            if (time != null) {
                              setState(() {
                                _validate = false;
                                this.time = time;
                              });
                            }
                          },
                          child: IgnorePointer(
                            ignoring: true,
                            child: TextFormField(
                              style: GoogleFonts.poppins(color: iHeadColor),
                              decoration: InputDecoration(
                                labelText: 'Time',
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10),
                                focusColor: isDarkMode
                                    ? Colors.blue[800]
                                    : Colors.blue[100],
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  borderSide:
                                      BorderSide(width: 2, color: textColor),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  borderSide:
                                      BorderSide(width: 1, color: inputColor),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter the appointment Time';
                                }
                                return null;
                              },
                              readOnly: true,
                              controller: TextEditingController(
                                text: this.time != null
                                    ? this.time!.format(context)
                                    : '',
                              ),
                              onTap: () async {
                                final selectedTime = await showTimePicker(
                                  context: context,
                                  initialTime: time!,
                                );
                                if (selectedTime != null) {
                                  setState(() {
                                    time = selectedTime;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                        trailing: Container(
                          height: 50,
                          width: 50,
                          color: elevatedButtonColor,
                          child: IconButton(
                            onPressed: () async {
                              final selectedTime = await showTimePicker(
                                context: context,
                                initialTime: time!,
                              );
                              if (selectedTime != null) {
                                setState(() {
                                  time = selectedTime;
                                });
                              }
                            },
                            icon: Icon(
                              Icons.more_time_rounded,
                            ),
                            color: isDarkMode ? Colors.grey[800] : Colors.white,
                            iconSize: 30,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: noteController,
                        maxLines: 5,
                        style: GoogleFonts.poppins(color: iHeadColor),
                        decoration: InputDecoration(
                          focusColor:
                              isDarkMode ? Colors.blue[800] : Colors.blue[100],
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(width: 2, color: textColor),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(width: 1, color: inputColor),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              noteController.clear();
                            },
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          labelText: "Add note",
                          labelStyle: GoogleFonts.nunito(),
                          alignLabelWithHint: true,
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (date == null || time == null) {
                            setState(() {
                              _validate = true;
                            });
                            return;
                          }

                          submitForm();
                        },
                        style: ElevatedButton.styleFrom(
                          fixedSize:
                              Size(MediaQuery.of(context).size.width, 50),
                          elevation: 2,
                          backgroundColor: elevatedButtonColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Update appointment ",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                color: isDarkMode
                                    ? Colors.grey[800]
                                    : Colors.white,
                              ),
                            ),
                            Icon(
                              Icons.send_rounded,
                              size: 30,
                              color:
                                  isDarkMode ? Colors.grey[800] : Colors.white,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
