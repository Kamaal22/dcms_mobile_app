import 'dart:convert';

import 'package:dcms_mobile_app/assets/component.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'index.dart';

class AppointmentModel extends StatefulWidget {
  @override
  _AppointmentModelState createState() => _AppointmentModelState();
}

class _AppointmentModelState extends State<AppointmentModel> {
  DateTime? date;
  TimeOfDay? time;
  TextEditingController note = TextEditingController();
  late bool isDarkMode = false;
  String patient_id = '';

  getPatientId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    patient_id = pref.getString('patient_id')!;
  }

  @override
  void initState() {
    super.initState();
    isDarkMode;
    date = DateTime.now();
    time = TimeOfDay.now();
    getPatientId();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    setState(() {
      themeProvider;
      getPatientId();
      print("Patient ID = " + patient_id.toString());
    });
    final isDarkMode =
        Provider.of<ThemeProvider>(context, listen: true).isDarkMode;
    final textColor = isDarkMode ? Colors.white : Colors.blue[700];
    final inputColor = isDarkMode ? Colors.blue[800] : Colors.blue[100];
    final elevatedButtonColor = isDarkMode ? Colors.white : Colors.blue[800];
    final scaffoldDarkTheme = isDarkMode ? Colors.grey[900] : Colors.grey[50];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[100],
        title: Text(
          'Make an appointment',
          style: GoogleFonts.poppins(
            color: textColor,
          ),
        ),
        elevation: 0,
      ),
      backgroundColor: scaffoldDarkTheme,
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
                          note.clear();
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
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    children: [
                      SizedBox(height: 20),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: InkWell(
                          onTap: () async {
                            final selectedDate = await showDatePicker(
                              context: context,
                              initialDate: date ?? DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2024),
                            );
                            if (selectedDate != null) {
                              setState(() {
                                date = selectedDate;
                              });
                            }
                          },
                          child: IgnorePointer(
                            ignoring: true,
                            child: TextFormField(
                              style: GoogleFonts.poppins(color: textColor),
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
                                  borderSide:
                                      BorderSide(width: 1, color: inputColor!),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter the appointment Date';
                                }
                                return null;
                              },
                              readOnly: true,
                              controller: TextEditingController(
                                text: date != null
                                    ? DateFormat('yyyy-MM-dd').format(date!)
                                    : '',
                              ),
                            ),
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
                                initialDate: date ?? DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2024),
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
                            final selectedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(date!),
                            );
                            if (selectedTime != null) {
                              setState(() {
                                time = selectedTime;
                              });
                            }
                          },
                          child: IgnorePointer(
                            ignoring: true,
                            child: TextFormField(
                              style: GoogleFonts.poppins(color: textColor),
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
                                text: time != null ? time!.format(context) : '',
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
                        controller: note,
                        maxLines: 5,
                        style: GoogleFonts.poppins(color: elevatedButtonColor),
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
                              note.clear();
                            },
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          labelText: "Add Description",
                          labelStyle: GoogleFonts.poppins(color: textColor),
                          alignLabelWithHint: true,
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      ElevatedButton(
                        onPressed: submitForm,
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
                              "Make appointment ",
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

  Future<void> submitForm() async {
    var dateFormatted = DateFormat('yyyy-MM-dd').format(date!);
    var timeFormatted = time!.format(context);

    try {
      var response = await http.post(
        Uri.parse(API_ENDPOINT("appointment/submit_appt.php")),
        body: {
          'date': dateFormatted,
          'time': timeFormatted,
          'patient_id': patient_id.toString(),
          'employee_id': 'null',
          'note': note.text.trim().toString(),
        },
      );

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        var responseData = json.decode(response.body);
        var status = responseData['status'];

        print(responseData);
        print(response.body);
        if (status == 'success') {
          showSnackBarWithMessage(
              'Appointment created successfully', Colors.green);
          setState(() {
            date = DateTime.now();
            time = TimeOfDay.now();
            note.clear();
          });
        } else if (status == 'errorT') {
          snackbar(context, Colors.red[50], Colors.red[800],
              "Time has already been appointed", 2);
        } else {
          snackbar(context, Colors.red[50], Colors.red[800],
              "Failed to create appointment!", 2);
        }
      } else {
        snackbar(context, Colors.red[50], Colors.red[800],
            "Failed to create appointment: ${response.body}", 2);
      }
    } catch (error) {
      snackbar(context, Colors.red[50], Colors.red[800], "Error: $error", 2);
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
}
