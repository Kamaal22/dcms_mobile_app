import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'appt_functions.dart';
import 'assets/colors.dart';
import 'assets/component.dart';
import 'package:http/http.dart' as http;

class AppointmentModel extends StatefulWidget {
  @override
  _AppointmentModelState createState() => _AppointmentModelState();
}

class _AppointmentModelState extends State<AppointmentModel> {
  final _formKey = GlobalKey<FormState>();

  // Form fields
  DateTime? date;
  TimeOfDay? time;
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
        title: Text('Appointment Form'),
      ),
      body: RefreshIndicator(
        backgroundColor: Colors.blueGrey[50],
        strokeWidth: 2,
        color: Colors.blueGrey,
        onRefresh: _refreshData,
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                ListTile(
                  title: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Date',
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
                        lastDate: DateTime(2100),
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
                    readOnly: true,
                    controller: TextEditingController(
                      text: date != null
                          ? DateFormat('yyyy-MM-dd').format(date!)
                          : '',
                    ),
                  ),
                  trailing: Icon(Icons.calendar_today),
                ),
                ListTile(
                  title: TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(0))),
                        labelText: 'Time',
                        contentPadding: EdgeInsets.symmetric(horizontal: 10)),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the appointment time';
                      }
                      return null;
                    },
                    onTap: () {
                      _showCustomTimePicker(context).then((selectedTime) {
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
                    controller: TextEditingController(
                      text: time != null ? time!.format(context) : '',
                    ),
                  ),
                  // trailing: GestureDetector(
                  //     onTap: () {
                  //       _showCustomTimePicker(context).then((selectedTime) {
                  //         if (selectedTime != null) {
                  //           setState(() {
                  //             // Handle the selected time
                  //             // For example, you can store it in a variable or update a text field
                  //             time = selectedTime;
                  //           });
                  //         }
                  //       });
                  //     },
                  //     child: Icon(Icons.access_time)),
                ),
                SizedBox(height: 10),
                TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      labelText: 'Patient ID',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)))),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the patient ID';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    patientId = int.parse(value!);
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                FutureBuilder<List<Employee>>(
                  future: fetchEmployeesFromDatabase(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      final employees = snapshot.data!;
                      return DropdownButtonFormField<int>(
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 5),
                            hintText: 'Employee ID',
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)))),
                        validator: (value) {
                          if (value == null) {
                            return 'Please select an employee';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            employeeId = value;
                          });
                        },
                        items: employees.map((employee) {
                          return DropdownMenuItem<int>(
                            value: employee.id,
                            child: Text(
                              employee.name,
                              style: GoogleFonts.nunito(color: red),
                            ),
                          );
                        }).toList(),
                      );
                    } else {
                      return Text('No employees found');
                    }
                  },
                ),
                SizedBox(height: 10),
                Container(
                  decoration: radius(10, transparent, blueGrey),
                  child: FutureBuilder<List<Service>>(
                    future: fetchServicesFromDatabase(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        final servicesList = snapshot.data!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: servicesList.map((service) {
                            return CheckboxListTile(
                              activeColor: blue900,
                              title: Text(service.name,
                                  style: GoogleFonts.nunito()),
                              value: services.contains(service.id.toString()),
                              onChanged: (value) {
                                setState(() {
                                  if (value!) {
                                    services.add(service.id.toString());
                                  } else {
                                    services.remove(service.id.toString());
                                  }
                                });
                              },
                            );
                          }).toList(),
                        );
                      } else {
                        return Text('No services found');
                      }
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: submitForm,
                  style: ElevatedButton.styleFrom(elevation: 0),
                  child: Text('Submit'),
                ),
              ],
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
      };

      // Send the appointment data to the server
      try {
        var response = await http.post(
          Uri.parse('http://192.168.150.163/appt/submit_appt.php'),
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

  Future<TimeOfDay?> _showCustomTimePicker(BuildContext context) async {
    TimeOfDay? selectedTime;
    String? selectedPeriod;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              elevation: 0,
              titlePadding: EdgeInsets.all(0),
              contentPadding: EdgeInsets.symmetric(horizontal: 2),
              title: Container(
                alignment: Alignment.center,
                color: Colors.blueGrey[100],
                height: 50,
                padding: EdgeInsets.all(5),
                child: Text(
                  'SELECT TIME',
                  style: GoogleFonts.nunito(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.blueGrey),
                ),
              ),
              content: Container(
                width: 200,
                height: 300,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      color: Colors.blueGrey[50],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              height: 50,
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    selectedPeriod = 'AM';
                                  });
                                },
                                child: Text('AM',
                                    style: GoogleFonts.nunito(
                                        color: Colors.blueGrey[800])),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              height: 50,
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    selectedPeriod = 'PM';
                                  });
                                },
                                child: Text('PM',
                                    style: GoogleFonts.nunito(
                                        color: Colors.blueGrey[800])),
                              ),
                            ),
                          ),
                          Divider(
                            thickness: 2,
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: 48,
                        itemBuilder: (BuildContext context, int index) {
                          final hour =
                              index ~/ 2 % 12 == 0 ? 12 : index ~/ 2 % 12;
                          final minute = (index % 2) * 30;
                          final isAM = selectedPeriod == 'AM';
                          final formattedTime =
                              '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} ${isAM ? 'AM' : 'PM'}';
                          return Column(
                            children: [
                              ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 10),
                                title: Text(formattedTime,
                                    style: GoogleFonts.nunito(
                                        color: Colors.blueGrey[700])),
                                onTap: () {
                                  setState(() {
                                    selectedTime =
                                        TimeOfDay(hour: hour, minute: minute);
                                  });
                                },
                              ),
                              Divider(),
                            ],
                          );
                        },
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          fixedSize:
                              Size(MediaQuery.of(context).size.width, 30)),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('OK', style: GoogleFonts.nunito()),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    return selectedTime;
  }
}
