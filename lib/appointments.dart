import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'appointment_edit.dart';
import 'assets/component.dart';
import 'package:provider/provider.dart';

import 'index.dart';

const String AppointmentTable = 'appointments';
bool isLoading = false;

class AppointmentPage extends StatefulWidget {
  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  List<Appointment> appointments = [];
  String patient_id = '';

  void editAppointment(BuildContext context, Appointment appointment) {
    // Navigate to appointment edit screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AppointmentEditPage(
            appointmentId: appointment.appointmentId.toString(),
            patientId: appointment.patientId,
            appointmentDate: appointment.date,
            appointmentTime: appointment.time,
            appointmentType: appointment.type,
            appointmentNote: appointment.note),
      ),
    );
  }

  Future<void> saveAppointmentsToCache(List<Appointment> appointments) async {
    final db = await DatabaseHelper.instance.database;

    final batch = db.batch();
    for (final appointment in appointments) {
      final existingAppointment = await db.query(
        AppointmentTable,
        where: 'appointment_id = ?',
        whereArgs: [appointment.appointmentId],
      );

      if (existingAppointment.isNotEmpty) {
        // Update existing appointment if needed
        batch.update(
          AppointmentTable,
          appointment.toJson(),
          where: 'appointment_id = ?',
          whereArgs: [appointment.appointmentId],
        );
      } else {
        // Insert new appointment
        batch.insert(AppointmentTable, appointment.toJson());
      }
    }
    await batch.commit();
  }

  Future<List<Appointment>> getAppointmentsFromCache() async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query(AppointmentTable);

    return result.map((json) => Appointment.fromJson(json)).toList();
  }

  Future<bool> checkNetConn() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return true; // Internet connection is available
    } else {
      return false; // No internet connection
    }
  }

  Future<void> fetchAppointments() async {
    final isConnected = await checkNetConn();

    if (!isConnected) {
      // snackbar(context, Colors.red[50], Colors.red[800],
      //     "No Internet Connection. Getting appointments from cache...", 2);
      // setState(() async {
      isLoading = false;
      appointments = await getAppointmentsFromCache();
      // });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(API_ENDPOINT('appointment/getAppt.php')),
        body: {'patient_id': patient_id},
      ).timeout(Duration(seconds: 10));
      setState(() {
        isLoading = true;
      });
      if (response.statusCode == 200) {
        // print(response.body);
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        if (jsonData['status'] == 'success') {
          final appointmentsData = jsonData['data'] as List;

          List<Appointment> appointments = []; // Initialize an empty list

          for (final appointmentData in appointmentsData) {
            appointments.add(Appointment(
              appointmentId: appointmentData['appointment_id'] ?? "",
              patient: appointmentData['patient'] ?? "",
              patientId: appointmentData['patient_id'] ?? "",
              dentist: appointmentData['dentist'] ?? "",
              employeeId: appointmentData['employee_id'] ?? "",
              date: appointmentData['date'] ?? "",
              time: appointmentData['time'] ?? "",
              note: appointmentData['note'] ?? "",
              type: appointmentData['type'] ?? "",
              status: appointmentData['status'] ?? "",
            ));
          }

          setState(() {
            isLoading = false;
            this.appointments =
                appointments; // Update the state with the list of appointments
          });

          saveAppointmentsToCache(appointments);
        } else {
          print(jsonData['message']);
          snackbar(
            context,
            Colors.red[50],
            Colors.red[800],
            jsonData['message'],
            2,
          );
        }
      } else {
        print(
            response.statusCode.toString() + " : " + response.body.toString());
        snackbar(context, Colors.red[50], Colors.red[800], response.body, 2);
      }
    } catch (e) {
      print(e);
      snackbar(context, Colors.red[50], Colors.red[800], e.toString(), 2);
    }

    setState(() {
      isLoading = false;
    });
  }

  getPatientId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    patient_id = pref.getString('patient_id')!;
  }

  @override
  void initState() {
    super.initState();
    getPatientId();

    // Call fetchAppointments here to load data when the page is first created
    fetchAppointments();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    final isDarkMode = themeProvider.isDarkMode;

    final iHeadColor = isDarkMode ? Colors.white : Colors.blue[800];
    final textColor = isDarkMode ? Colors.white : Colors.grey[800];
    final backgroundColor = isDarkMode ? Colors.grey[800] : Colors.grey[100];
    final scaffoldDarkTheme = isDarkMode ? Colors.grey[900] : Colors.grey[50];

    Future.delayed(Duration(seconds: 20), () {
      setState(() {
        getPatientId();
        fetchAppointments();
      });
    });

    Future.delayed(Duration(seconds: 10), () {
      setState(() {
        isLoading = false;
      });
    });

    return Scaffold(
      backgroundColor: scaffoldDarkTheme,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Your Appointments",
                style: GoogleFonts.poppins(
                  color: textColor,
                ),
              ),
              IconButton(
                onPressed: () => fetchAppointments(),
                color: textColor,
                icon: Icon(Icons.refresh_rounded),
              ),
            ],
          ),
        ),
        elevation: 0,
      ),
      body: RefreshIndicator(
          onRefresh: () async {
            // Call fetchAppointments when the user triggers a refresh
            await fetchAppointments();
          },
          child: isLoading
              ? Container(
                  color: backgroundColor,
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(backgroundColor: iHeadColor),
                        SizedBox(height: 20),
                        Text("Loading...",
                            style: GoogleFonts.syne(
                                fontSize: 22, color: iHeadColor))
                      ],
                    ),
                  ),
                )
              : Column(
                  children: [
                    SizedBox(height: 30),
                    Expanded(
                      child: ListView(
                        children: [
                          _buildAppointmentsSection(
                            context,
                            appointments
                                .where((appointment) =>
                                    appointment.status == 'Pending')
                                .toList(),
                            Icons.pending_rounded,
                            "Pending Appointments",
                            iHeadColor!,
                          ),
                          _buildAppointmentsSection(
                              context,
                              appointments
                                  .where((appointment) =>
                                      appointment.status == 'Approved')
                                  .toList(),
                              Icons.approval_rounded,
                              "Approved Appointments",
                              iHeadColor,
                              showPopupMenu: false),
                          _buildAppointmentsSection(
                            context,
                            appointments
                                .where((appointment) =>
                                    appointment.status == 'Cancelled')
                                .toList(),
                            Icons.event_busy_rounded,
                            "Cancelled Appointments",
                            iHeadColor,
                            showPopupMenu: false,
                          ),
                          _buildAppointmentsSection(
                            context,
                            appointments
                                .where((appointment) =>
                                    appointment.status == 'Completed')
                                .toList(),
                            Icons.check_circle_rounded,
                            "Completed Appointments",
                            iHeadColor,
                            showPopupMenu: false,
                          ),
                          SizedBox(
                            height: 200,
                          )
                        ],
                      ),
                    ),
                  ],
                )),
    );
  }

  Widget _buildAppointmentsSection(
      BuildContext context,
      List<Appointment> sectionAppointments,
      IconData icons,
      String sectionTitle,
      Color textColor,
      {bool showPopupMenu = true}) {
    if (sectionAppointments.isEmpty) {
      return SizedBox.shrink();
    }

    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkMode = themeProvider.isDarkMode;

    final textColor = isDarkMode ? Colors.white : Colors.grey[800];
    final backgroundColor = isDarkMode ? Colors.grey[800] : Colors.grey[200];

    final statusColorMap = {
      'Pending': isDarkMode ? Colors.blue : Colors.blue[800],
      'Approved': isDarkMode ? Colors.green : Colors.green[800],
      'Cancelled': isDarkMode ? Colors.red : Colors.red[800],
      'Completed': isDarkMode ? Colors.lightGreen : Colors.lightGreen[800],
    };
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      // decoration: radius(1000, backgroundColor, Colors.transparent),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            tileColor: backgroundColor,
            leading: Icon(icons,
                color: statusColorMap[sectionAppointments.first.status] ??
                    Colors.grey),
            title: Text(
              sectionTitle,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: statusColorMap[sectionAppointments.first.status] ??
                    Colors.grey,
              ),
            ),
          ),
          SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: sectionAppointments.length,
            itemBuilder: (context, index) {
              return buildAppointmentCard(context, sectionAppointments[index],
                  textColor!, showPopupMenu);
            },
          ),
        ],
      ),
    );
  }

  Widget buildAppointmentCard(BuildContext context, Appointment appointment,
      Color textColor, bool showPopupMenu) {
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

    Color statusColor;
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkMode = themeProvider.isDarkMode;
    final textColor = isDarkMode ? Colors.white : Colors.grey[800];
    final backgroundColor = isDarkMode ? Colors.grey[800] : Colors.grey[200];

    switch (appointment.status) {
      case 'Pending':
        statusColor = isDarkMode ? Colors.blue : Colors.blue[800]!;
        break;
      case 'Approved':
        statusColor = isDarkMode ? Colors.green : Colors.green[800]!;
        break;
      case 'Cancelled':
        statusColor = isDarkMode ? Colors.red : Colors.red[800]!;
        break;
      case 'Completed':
        statusColor = isDarkMode ? Colors.lightGreen : Colors.lightGreen[800]!;
        break;
      default:
        statusColor = textColor!;
    }

    return Column(
      children: [
        // SizedBox(height: 2, child: Divider()),
        Card(
          margin: EdgeInsets.zero,
          color: backgroundColor!,
          elevation: 0,
          child: ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Appointment ID: " + appointment.appointmentId.toString(),
                  style: GoogleFonts.ubuntu(
                    color: textColor,
                  ),
                ),
                Text(
                  "Date: " +
                      DateFormat('EEE, d-MMM-yy')
                          .format(DateTime.parse(appointment.date)),
                  style: GoogleFonts.ubuntu(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                Text(
                  "Time: " + appointmentTimeToString(appointment.time),
                  style: GoogleFonts.ubuntu(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('type: ${appointment.type}',
                    style: GoogleFonts.actor(fontSize: 16, color: textColor)),
                Text('Dentist:' + appointment.dentist ?? "",
                    style: GoogleFonts.actor(fontSize: 16, color: textColor)),
                Text('Patient: ${appointment.patient}',
                    style: GoogleFonts.actor(
                      fontSize: 16,
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    )),
                if (appointment.note.isNotEmpty)
                  Text(
                    'Notes: ${appointment.note}',
                    style: GoogleFonts.ubuntu(
                      color: textColor,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      'Status: ',
                      style: GoogleFonts.ubuntu(
                        color: textColor,
                      ),
                    ),
                    Container(
                      decoration:
                          radius(10, statusColor.withOpacity(0.1), statusColor),
                      alignment: Alignment.center,
                      height: 20,
                      width: MediaQuery.of(context).size.width * 0.20,
                      // color: statusColor,
                      child: Text(
                        appointment.status,
                        style: GoogleFonts.ubuntu(
                          color: statusColor,
                          // fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: showPopupMenu
                ? PopupMenuButton<String>(
                    elevation: 2,
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          child: Text(
                            'Edit',
                            style: GoogleFonts.ubuntu(
                              color: Colors.lightBlue[500],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          value: 'edit',
                        ),
                        PopupMenuItem(
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.ubuntu(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          value: 'cancel',
                        ),
                      ];
                    },
                    onSelected: (value) {
                      if (value == 'edit') {
                        // Add your logic for editing the appointment
                        // cancelAppointment(context, appointment);
                        editAppointment(context, appointment);
                      } else if (value == 'cancel') {
                        // Add your logic for canceling the appointment
                        cancelAppointment(context, appointment);
                      }
                    },
                  )
                : null,
          ),
        ),
        // SizedBox(
        // height: 0,
        // Divider(),
        // )
      ],
    );
  }
}

class Appointment {
  String appointmentId;
  String patient;
  String patientId;
  String dentist;
  String employeeId;
  String date;
  String time;
  String note;
  String type;
  String status;

  Appointment({
    required this.appointmentId,
    required this.patient,
    required this.patientId,
    required this.dentist,
    required this.employeeId,
    required this.date,
    required this.time,
    required this.note,
    required this.type,
    required this.status,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      appointmentId: json['appointment_id'].toString() ?? "",
      patient: json['patient'].toString() ?? "",
      patientId: json['patient_id'].toString() ?? "",
      dentist: json['dentist'].toString() ?? "",
      employeeId: json['employee_id'].toString() ?? "",
      date: json['date'].toString() ?? "",
      time: json['time'].toString() ?? "",
      note: json['note'] ?? '',
      type: json['type'].toString() ?? "",
      status: json['status'].toString() ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appointment_id': appointmentId,
      'patient': patient,
      'patient_id': patientId,
      'dentist': dentist,
      'employee_id': employeeId,
      'date': date,
      'time': time,
      'note': note,
      'type': type,
      'status': status,
    };
  }
}

void cancelAppointment(BuildContext context, Appointment appointment) {
  final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
  final isDarkMode = themeProvider.isDarkMode;

  // Define colors based on the theme mode
  final bgColor = isDarkMode ? Colors.red[800] : Colors.white;
  final textColor = isDarkMode ? Colors.white : Colors.red[800];
  showDialog(
    useSafeArea: false,
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        content: Text(
          textAlign: TextAlign.left,
          "if you cancel the appointment you will not be able to reschedule it again",
          style: GoogleFonts.ubuntu(fontSize: 14),
        ),
        title: Text("Are you sure you want to 'CANCEL' this appointment?",
            style: GoogleFonts.ubuntu(
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
              fontSize: 16,
            )),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'No',
              style: GoogleFonts.poppins(
                  color: Colors.blue, fontWeight: FontWeight.w600),
            ),
          ),
          TextButton(
            onPressed: () async {
              void showSnackBarWithMessage(
                  String message, Color backgroundColor) {
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

              final isConnected = await checkNetConn();

              if (!isConnected) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: textColor,
                    content: Text(
                        textAlign: TextAlign.center,
                        "Cannot cancel appointment. No internet connection",
                        style: GoogleFonts.syne(color: bgColor, fontSize: 18)),
                  ),
                );
              } else {
                print(appointment.appointmentId);
                var response = await http.post(
                  Uri.parse(API_ENDPOINT("appointment/cancel_appt.php")),
                  body: {
                    'appointment_id': appointment.appointmentId.toString()
                  },
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
                    } else if (status == 'errorT') {
                      showSnackBarWithMessage(
                          'Time has already been appointed. Select another time!',
                          Colors.red);
                    } else {
                      showSnackBarWithMessage(
                          'Failed to update appointment!' +
                              responseData.toString(),
                          Colors.red);
                    }
                  } else {
                    var responseData = json.decode(response.body);
                    showSnackBarWithMessage(
                        'Failed to update appointment: ' +
                            responseData.toString(),
                        Colors.red);
                  }
                } catch (error) {
                  print('Response Body: ${response.body}'); // Debugging
                  showSnackBarWithMessage('Error: $error', Colors.red);
                }
              }
              Navigator.pop(context);
            },
            child: Text(
              'Yes, Cancel',
              style: GoogleFonts.poppins(
                  color: Colors.red, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      );
    },
  );
}

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('appointments.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $AppointmentTable(
        appointment_id TEXT,
        patient TEXT,
        patient_id TEXT,
        dentist TEXT,
        employee_id TEXT,
        date TEXT,
        time TEXT,
        note TEXT,
        type TEXT,
        status TEXT
      )
    ''');
  }
}
