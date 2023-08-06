import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'assets/component.dart';
import 'package:provider/provider.dart';

import 'index.dart';

const Duration kApiTimeout = Duration(seconds: 10);
const String kAppointmentTable = 'appointments';

class AppointmentPage extends StatefulWidget {
  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  List<Appointment> appointments = [];
  String patient_id = '';

  Future<void> saveAppointmentsToCache(List<Appointment> appointments) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete(kAppointmentTable);

    final batch = db.batch();
    for (final appointment in appointments) {
      batch.insert(kAppointmentTable, appointment.toJson());
    }
    await batch.commit();
  }

  Future<List<Appointment>> getAppointmentsFromCache() async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query(kAppointmentTable);

    return result.map((json) => Appointment.fromJson(json)).toList();
  }

  Future<String> getPatientId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int? storedPatientID = pref.getInt('patient_id');
    return storedPatientID.toString();
  }

  // The other functions remain unchanged.

  Future<void> fetchAppointments(BuildContext context) async {
    final isConnected = await checkNetConn();

    if (!isConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Cannot fetch appointments. No Internet Connection."),
        ),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(API_ENDPOINT('appointment/getAppt.php')),
        body: {'patient_id': patient_id.toString()},
      ).timeout(kApiTimeout);

      if (response.statusCode == 200) {
        print(response.body);
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        if (jsonData['status'] == 'success') {
          List<Appointment> fetchedAppointments = [];
          for (var data in jsonData['data']) {
            fetchedAppointments.add(Appointment.fromJson(data));
          }

          if (fetchedAppointments.isNotEmpty) {
            setState(() {
              appointments = fetchedAppointments;
            });

            await saveAppointmentsToCache(appointments);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("No appointments found."),
              ),
            );
          }
        } else {
          getAppointmentsFromCache();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Error fetching appointments: ${jsonData['data']}"),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("API Error - statusCode = ${response.statusCode}"),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error fetching appointments: ${e.toString()}"),
        ),
      );
    }
  }

  Future<void> initialize(BuildContext context) async {
    final cachedAppointments = await getAppointmentsFromCache();
    if (cachedAppointments.isNotEmpty) {
      setState(() {
        appointments = cachedAppointments;
      });
    }

    final isConnected = await checkNetConn();
    if (isConnected) {
      await fetchAppointments(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("No internet connection. Can't fetch appointments."),
        ),
      );
    }
  }

  late bool _isDarkMode = false;
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      patient_id = await getPatientId();
      fetchAppointments(context as BuildContext);
      initialize(context as BuildContext);
      _isDarkMode =
          Provider.of<ThemeProvider>(context as BuildContext, listen: false)
              .isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkMode = themeProvider.isDarkMode;

    final iHeadColor = isDarkMode ? Colors.white : Colors.blue[800];
    final textColor = isDarkMode ? Colors.white : Colors.grey[800];
    final backgroundColor = isDarkMode ? Colors.grey[800] : Colors.grey[100];

    return Scaffold(
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
                  // fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
              IconButton(
                onPressed: () => fetchAppointments(context),
                color: textColor,
                icon: Icon(Icons.refresh_rounded),
              ),
            ],
          ),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          SizedBox(height: 30),
          Expanded(
            child: ListView(
              children: [
                _buildAppointmentsSection(
                  context,
                  appointments
                      .where((appointment) => appointment.status == 'Pending')
                      .toList(),
                  Icons.pending_rounded,
                  "Pending Appointments",
                  iHeadColor!,
                ),
                _buildAppointmentsSection(
                  context,
                  appointments
                      .where((appointment) => appointment.status == 'Approved')
                      .toList(),
                  Icons.approval_rounded,
                  "Approved Appointments",
                  iHeadColor,
                ),
                _buildAppointmentsSection(
                  context,
                  appointments
                      .where((appointment) => appointment.status == 'Cancelled')
                      .toList(),
                  Icons.event_busy_rounded,
                  "Cancelled Appointments",
                  iHeadColor,
                  showPopupMenu:
                      false, // Hide the popup menu for cancelled appointments
                ),
                _buildAppointmentsSection(
                  context,
                  appointments
                      .where((appointment) => appointment.status == 'Completed')
                      .toList(),
                  Icons.check_circle_rounded,
                  "Completed Appointments",
                  iHeadColor,
                  showPopupMenu:
                      false, // Hide the popup menu for cancelled appointments
                ),
                SizedBox(
                  height: 200,
                )
              ],
            ),
          ),
        ],
      ),
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
    final backgroundColor = isDarkMode ? Colors.grey[800] : Colors.grey[100];
    final statusColorMap = {
      'Pending': isDarkMode ? Colors.blue : Colors.blue[800],
      'Approved': isDarkMode ? Colors.green : Colors.green[800],
      'Cancelled': isDarkMode ? Colors.red : Colors.red[800],
      'Completed': isDarkMode ? Colors.lightGreen : Colors.lightGreen[800],
    };
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: radius(10, backgroundColor, Colors.transparent),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
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
          SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: sectionAppointments.length,
            itemBuilder: (context, index) {
              return buildAppointmentCard(context, sectionAppointments[index],
                  textColor!, showPopupMenu);
            },
          ),
          // SizedBox(height: 16),
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
        Card(
          margin: EdgeInsets.zero,
          color: Colors.transparent,
          elevation: 0,
          child: ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Date: " +
                      DateFormat('EEE, d-MMM-yy')
                          .format(DateTime.parse(appointment.date)),
                  style: GoogleFonts.ubuntu(
                    color: textColor,
                  ),
                ),
                Text(
                  "Time: " + appointmentTimeToString(appointment.time),
                  style: GoogleFonts.ubuntu(
                    color: textColor,
                  ),
                ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Dentist: ${appointment.dentist}',
                    style: GoogleFonts.actor(fontSize: 16, color: textColor)),
                Text('Patient: ${appointment.patient}',
                    style: GoogleFonts.actor(fontSize: 16, color: textColor)),
                if (appointment.note.isNotEmpty)
                  Text(
                    'Notes: ${appointment.note}',
                    style: GoogleFonts.ubuntu(
                      color: textColor,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
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
                      width: MediaQuery.of(context).size.width * 0.15,
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
            trailing: PopupMenuButton<String>(
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
                  cancelAppointment(context, appointment);
                } else if (value == 'cancel') {
                  // Add your logic for canceling the appointment
                  cancelAppointment(context, appointment);
                }
              },
            ),
          ),
        ),
        SizedBox(
          height: 0,
          child: Divider(),
        )
      ],
    );
  }
}

class Appointment {
  int appointmentId;
  String patient;
  int patientId;
  String dentist;
  int employeeId;
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
      appointmentId: int.parse(json['appointment_id'].toString()),
      patient: json['patient'] as String,
      patientId: int.parse(json['patient_id'].toString()),
      dentist: json['dentist'] as String,
      employeeId: int.parse(json['employee_id'].toString()),
      date: json['date'] as String? ?? '',
      time: json['time'] as String? ?? '',
      note: json['note'] as String? ?? '',
      type: json['Type'] as String? ?? '',
      status: json['status'] as String? ?? '',
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
      'Type': type,
      'status': status,
    };
  }
}

void cancelAppointment(BuildContext context, Appointment appointment) {
  showDialog(
    useSafeArea: false,
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text("Are you sure you want to 'CANCEL' the appointment?",
            style: GoogleFonts.ubuntu(
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
              // fontSize: 20,
            )),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'No',
              style: GoogleFonts.ubuntu(color: Colors.blue),
            ),
          ),
          TextButton(
            onPressed: () {
              // Cancel appointment logic here
              Navigator.pop(context);
            },
            child: Text(
              'Yes',
              style: GoogleFonts.ubuntu(color: Colors.red),
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
      CREATE TABLE $kAppointmentTable(
        appointment_id INTEGER PRIMARY KEY AUTOINCREMENT,
        patient TEXT NOT NULL,
        patient_id INTEGER NOT NULL,
        dentist TEXT NOT NULL,
        employee_id INTEGER NOT NULL,
        date TEXT NOT NULL,
        time TEXT NOT NULL,
        note TEXT,
        Type TEXT NOT NULL,
        status TEXT NOT NULL
      )
    ''');
  }
}
