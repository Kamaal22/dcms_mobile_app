import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const String kApiUrl =
    'http://192.168.39.163/DCMS/app/mobile/appointment/getAppt.php';
const Duration kApiTimeout = Duration(seconds: 10);

const String kAppointmentTable = 'appointments';

class AppointmentPage extends StatefulWidget {
  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  List<Appointment> appointments = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      initialize();
    });
  }

  // Function to save the appointments to cache using SQLite
  Future<void> saveAppointmentsToCache(List<Appointment> appointments) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete(kAppointmentTable);

    final batch = db.batch();
    for (final appointment in appointments) {
      batch.insert(kAppointmentTable, appointment.toJson());
    }
    await batch.commit();
  }

  // Function to retrieve the appointments from cache using SQLite
  Future<List<Appointment>> getAppointmentsFromCache() async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query(kAppointmentTable);

    return result.map((json) => Appointment.fromJson(json)).toList();
  }

  // Function to fetch appointments from the server and update the cache
  Future<void> fetchAppointments() async {
    try {
      final response = await http.post(
        Uri.parse(kApiUrl),
        body: {'patient_id': '3'},
      ).timeout(kApiTimeout);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        if (jsonData['status'] == 'success') {
          List<Appointment> fetchedAppointments = [];
          for (var data in jsonData['data']) {
            fetchedAppointments.add(Appointment.fromJson(data));
          }

          setState(() {
            appointments = fetchedAppointments;
          });

          // Save the fetched appointments to cache
          await saveAppointmentsToCache(appointments);
        } else {
          var data = jsonData['data'];
          print(data);
          // Handle error when no appointments found
        }
      } else {
        print("API Error - statusCode = ${response.statusCode}");
      }
    } catch (e) {
      // Handle network or server error
      print('Error fetching appointments: ${e.toString()}');
    }
  }

  Future<bool> checkNetConn() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  // New method to handle initialization tasks
  Future<void> initialize() async {
    final cachedAppointments = await getAppointmentsFromCache();
    if (cachedAppointments.isNotEmpty) {
      setState(() {
        appointments = cachedAppointments;
      });
    }

    final isConnected = await checkNetConn();
    if (isConnected) {
      await fetchAppointments();
    } else {
      // Show snackbar saying there is no internet connection. Can't fetch appointments.
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        SnackBar(
          content: Text("No internet connection. Can't fetch appointments."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "List of Your Appointments",
                style: GoogleFonts.nunito(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.blueGrey,
                ),
              ),
              RefreshIndicator(
                child: IconButton(
                  onPressed: fetchAppointments,
                  color: Colors.blueGrey,
                  icon: Icon(Icons.refresh_rounded),
                ),
                onRefresh: fetchAppointments,
              ),
            ],
          ),
        ),
        elevation: 0,
        toolbarHeight: 150,
      ),
      body: Column(
        children: [
          SizedBox(height: 30),
          Expanded(
            child: ListView.builder(
              key: UniqueKey(),
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                return buildAppointmentCard(context, appointments[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAppointmentCard(BuildContext context, Appointment appointment) {
    Color statusColor;

    switch (appointment.status) {
      case 'Pending':
        statusColor = Colors.blue[800]!;
        break;
      case 'Approved':
        statusColor = Colors.green[800]!;
        break;
      case 'Cancelled':
        statusColor = Colors.red[800]!;
        break;
      default:
        statusColor = Colors.grey[800]!;
    }

    return Card(
      margin: EdgeInsets.zero,
      // color: Colors.blueGrey,
      shape: RoundedRectangleBorder(
        side: BorderSide(width: 0, color: Colors.blueGrey),
      ),
      elevation: 0,
      child: ListTile(
        title: Text(
          appointment.date + '          ' + appointment.time,
          style: GoogleFonts.nunito(
            color: Colors.grey[800],
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dentist: ${appointment.dentist}'),
            if (appointment.note.isNotEmpty)
              Text(
                'Notes: ${appointment.note}',
                style: GoogleFonts.nunito(
                  color: Colors.grey[800],
                  fontStyle: FontStyle.italic,
                ),
              ),
            Row(
              children: [
                Text(
                  'Status: ',
                  style: GoogleFonts.nunito(
                    color: Colors.grey[800],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 20,
                  width: MediaQuery.of(context).size.width * 0.15,
                  color: statusColor,
                  child: Text(
                    appointment.status,
                    style: GoogleFonts.nunito(
                      color: Colors.grey[100],
                      fontWeight: FontWeight.bold,
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
                  'View',
                  style: GoogleFonts.nunito(
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                value: 'view',
              ),
              PopupMenuItem(
                child: Text(
                  'Edit',
                  style: GoogleFonts.nunito(
                    color: Colors.lightBlue[500],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                value: 'edit',
              ),
              PopupMenuItem(
                child: Text(
                  'Cancel',
                  style: GoogleFonts.nunito(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                value: 'cancel',
              ),
            ];
          },
          onSelected: (value) {
            if (value == 'view') {
              // Add your logic for viewing the appointment
            } else if (value == 'edit') {
              // Add your logic for editing the appointment
              cancelAppointment(context, appointment);
            } else if (value == 'cancel') {
              // Add your logic for canceling the appointment
              cancelAppointment(context, appointment);
            }
          },
        ),
      ),
    );
  }
}

class Appointment {
  late int appointmentId;
  late String patient;
  late int patientId;
  late String dentist;
  late int employeeId;
  late String date;
  late String time;
  late String note;
  late String type;
  late String status;

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
      return AlertDialog(
        titleTextStyle: GoogleFonts.nunito(
          fontWeight: FontWeight.bold,
          color: Colors.blue[800],
          fontSize: 20,
        ),
        contentTextStyle: GoogleFonts.nunito(color: Colors.blue),
        elevation: 0,
        scrollable: true,
        title: Text('Confirm Cancellation'),
        content: Text('Are you sure you want to cancel the appointment?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'No',
              style: GoogleFonts.nunito(),
            ),
          ),
          TextButton(
            onPressed: () {
              // Cancel appointment logic here
              Navigator.pop(context);
            },
            child: Text(
              'Yes',
              style: GoogleFonts.nunito(color: Colors.red[300]),
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
