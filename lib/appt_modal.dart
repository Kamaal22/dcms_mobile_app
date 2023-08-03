import 'package:dcms_mobile_app/themes/darktheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class AppointmentModel extends StatefulWidget {
  @override
  _AppointmentModelState createState() => _AppointmentModelState();
}

class _AppointmentModelState extends State<AppointmentModel> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime? _selectedDay;
  final _formKey = GlobalKey<FormState>();
  DateTime? date;
  TimeOfDay? time;
  TextEditingController note = TextEditingController();
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _isDarkMode = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    final textColor = isDarkMode ? Colors.black : Colors.black;
    final iconColor = isDarkMode ? Colors.black : Colors.white;
    final containerColor = isDarkMode ? Colors.white : Colors.white;
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
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
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
              Card(
                // elevation: 10,
                // tileColor: Colors.orange,
                // contentPadding: EdgeInsets.zero,
                child: Container(
                  color: isDarkMode ? Colors.grey[100] : Colors.white,
                  child: TableCalendar(
                    firstDay: DateTime.now(),
                    lastDay: DateTime(2030),
                    focusedDay: DateTime.now(),
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                      });
                    },
                    calendarFormat: _calendarFormat,
                    onFormatChanged: (format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    },
                    headerStyle: HeaderStyle(
                        decoration: BoxDecoration(
                          color: containerColor,
                        ),
                        titleTextStyle: GoogleFonts.poppins(color: textColor),
                        leftChevronIcon: Icon(
                          Icons.chevron_left_rounded,
                          color: textColor,
                        ),
                        rightChevronIcon: Icon(
                          Icons.chevron_right_rounded,
                          color: textColor,
                        ),
                        formatButtonTextStyle: GoogleFonts.poppins(
                            color: textColor, backgroundColor: containerColor)),
                    calendarStyle: CalendarStyle(
                      cellPadding: EdgeInsets.all(0),
                      defaultTextStyle: GoogleFonts.poppins(color: textColor),
                    ),
                  ),
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: InkWell(
                  onTap: () {
                    showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    ).then((selectedTime) {
                      if (selectedTime != null) {
                        setState(() {
                          time = selectedTime;
                        });
                      }
                    });
                  },
                  child: IgnorePointer(
                    child: TextFormField(
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
                      readOnly: true,
                      controller: TextEditingController(
                        text: time != null ? time!.format(context) : '',
                      ),
                    ),
                  ),
                ),
                trailing: Ink(
                  color: Colors.blue[50],
                  child: IconButton(
                    onPressed: () {
                      showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      ).then((selectedTime) {
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
                    color: Colors.blue[800],
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
        elevation: 2,
        onPressed: submitForm,
        highlightElevation: 0.5,
        backgroundColor: isDarkMode ? Colors.white : Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(150),
        ),
        child: Center(
          child: Transform.rotate(
            angle: -45,
            child: Icon(
              Icons.send_rounded,
              size: 30,
              semanticLabel: "submit appointment",
              color: iconColor,
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
          Uri.parse('http://192.168.1.202/appt/submit_appt.php'),
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
                  'Appointment created successfully',
                  style: GoogleFonts.nunito(),
                ),
                backgroundColor: Colors.green,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Failed to create appointment!',
                  style: GoogleFonts.nunito(),
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Failed to create appointment?',
                style: GoogleFonts.nunito(),
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
}
