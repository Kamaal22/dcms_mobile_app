import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppointmentModel extends StatefulWidget {
  const AppointmentModel({super.key});

  @override
  State<AppointmentModel> createState() => _AppointmentModelState();
}

class _AppointmentModelState extends State<AppointmentModel> {
  List<Appointment> appointments = [];
  List<String> serviceOptions = [];

  @override
  void initState() {
    super.initState();
    fetchDataFromApi();
  }

  Future<void> fetchDataFromApi() async {
    try {
      final response = await http.get(
          Uri.parse('https://192.168.1.9/DCMS/app/mobile/appointment/api.php'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        appointments.clear();

        final database = await openDatabase(
          join(await getDatabasesPath(), 'appointment_database.db'),
          onCreate: (db, version) {
            return db.execute(
              'CREATE TABLE appointments(id INTEGER PRIMARY KEY, patientName TEXT, appointmentDate TEXT, appointmentTime TEXT, service TEXT)',
            );
          },
          version: 1,
        );

        for (var appointment in jsonData) {
          await database.insert(
            'appointments',
            {
              'id': appointment['id'],
              'patientName': appointment['patientName'],
              'appointmentDate': appointment['appointmentDate'],
              'appointmentTime': appointment['appointmentTime'],
              'service': appointment['service'],
            },
            conflictAlgorithm: ConflictAlgorithm.replace,
          );

          appointments.add(Appointment.fromJson(appointment));
        }

        final serviceResponse = await http.get(Uri.parse(
            'https://192.168.1.9/DCMS/app/mobile/appointment/api.php'));

        if (serviceResponse.statusCode == 200) {
          final serviceData = json.decode(serviceResponse.body);

          serviceOptions.clear();

          for (var service in serviceData) {
            serviceOptions.add(service['name']);
          }
        }

        await database.close();

        setState(() {});
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointments'),
      ),
      body: ListView.builder(
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          final appointment = appointments[index];
          return ListTile(
            title: Text(appointment.patientName),
            subtitle: Text(
                '${appointment.appointmentDate}, ${appointment.appointmentTime}'),
            trailing: DropdownButton<String>(
              value: appointment.service,
              items: serviceOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  appointment.service = newValue!;
                });
              },
            ),
          );
        },
      ),
    );
  }
}

class Appointment {
  final int id;
  final String patientName;
  final String appointmentDate;
  final String appointmentTime;
  String service;

  Appointment({
    required this.id,
    required this.patientName,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.service,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      patientName: json['patientName'],
      appointmentDate: json['appointmentDate'],
      appointmentTime: json['appointmentTime'],
      service: json['service'],
    );
  }
}
