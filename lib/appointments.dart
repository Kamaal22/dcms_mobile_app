import 'dart:convert';

import 'package:dcms_mobile_app/Model/mysql.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'assets/colors.dart';

class AppointmentPage extends StatefulWidget {
  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  var manager = APIManager();
  List<Map<String, dynamic>> services = [];

  Future<void> getServices() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey('services')) {
      setState(() {
        services = List<Map<String, dynamic>>.from(
          prefs
              .getStringList('services')!
              .map((service) => json.decode(service)),
        );
      });
    } else {
      manager.getData("select * from services").then((results) {
        var data = results['data'];
        if (data != null && data is Map<String, dynamic>) {
          setState(() {
            services = [data];
          });
        } else if (data != null && data is List<dynamic>) {
          setState(() {
            services = data.cast<Map<String, dynamic>>();
          });
        } else {
          print('Error retrieving data: Invalid format');
        }

        prefs.setStringList(
          'services',
          services.map((service) => json.encode(service)).toList(),
        );
      }).catchError((error) {
        print('Error retrieving data: $error');
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getServices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Appointment Page',
            style: GoogleFonts.nunito(
                fontSize: 25, fontWeight: FontWeight.bold, color: white),
          ),
        ),
        elevation: 0,
        backgroundColor: primary,
      ),
      body: ListView.builder(
        itemCount: services.length,
        itemBuilder: (context, index) {
          var service = services[index];
          var service_id = service['service_id'].toString();
          var service_name = service['name'].toString();
          var service_desc = service['description'].toString();
          var service_fee = service['fee'].toString();

          return ListTile(
            title: Text("Service ID: $service_id"),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Service Name: $service_name"),
                Text("Service Description: $service_desc"),
                Text("Service Fee: $service_fee"),
              ],
            ),
          );
        },
      ),
    );
  }
}



  // void deleteRow() async {
  //   var tableName = "AppointmentPages";
  //   var column = "AppointmentPage_id";
  //   var id = 5;
  //   bool success = await manager.deleteData(tableName, column, id);
  //   print("deleting... ");
  //   setState(() {
  //     if (success) {
  //       message = 'Row deleted successfully';
  //       SToast(message, green, white);
  //     } else {
  //       message = 'Failed to delete row';
  //       SToast(message, red, white);
  //     }
  //   });
  // }