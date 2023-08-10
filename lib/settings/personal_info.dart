import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:google_fonts/google_fonts.dart';

class Patient {
  int id;
  String firstName;
  String middleName;
  String lastName;
  DateTime birthDate;
  String gender;
  String phoneNumber;
  String address;

  Patient({
    required this.id,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.birthDate,
    required this.gender,
    required this.phoneNumber,
    required this.address,
  });
}

class ProfileSettingsPage extends StatefulWidget {
  @override
  _ProfileSettingsPageState createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  late Patient _patient = Patient(
    id: 1,
    firstName: 'John',
    middleName: 'Doe',
    lastName: 'Smith',
    birthDate: DateTime(1990, 12, 15),
    gender: 'Male',
    phoneNumber: '123-456-7890',
    address: '123 Main St, City',
  );
  bool _isEditing = false;
  late TextEditingController _firstNameController;
  late TextEditingController _middleNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _birthDateController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: _patient.firstName);
    _middleNameController = TextEditingController(text: _patient.middleName);
    _lastNameController = TextEditingController(text: _patient.lastName);
    _birthDateController =
        TextEditingController(text: _patient.birthDate.toString());
    _phoneController = TextEditingController(text: _patient.phoneNumber);
    _addressController = TextEditingController(text: _patient.address);
  }

  void _editInfo() {
    setState(() {
      _isEditing = true;
    });
  }

  Future<void> _saveChanges(Patient updatedPatient) async {
    try {
      // Simulate an HTTP POST request here
      // Replace the URL with your actual API endpoint
      final response = await http.post(
        Uri.parse('https://example.com/update_patient_info'),
        body: {
          'first_name': updatedPatient.firstName,
          'middle_name': updatedPatient.middleName,
          'last_name': updatedPatient.lastName,
          // ... add other fields to update
        },
      );

      if (response.statusCode == 200) {
        // If the HTTP POST is successful, update shared preferences
        // Implement the shared preferences update logic here
        setState(() {
          _patient = updatedPatient;
          _isEditing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')),
        );
      } else {
        throw Exception('Failed to update profile');
      }
    } catch (error) {
      print('Error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred while updating profile')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[300],
        title: Text(
          'Profile Settings',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        actions: [
          if (!_isEditing)
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: _editInfo,
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SingleChildScrollView(
              child: Container(
                // color: Colors.black,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      margin:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Personal Information',
                            style: TextStyle(
                              fontSize: 18,
                              // fontWeight: FontWeight.bold,
                              color: Colors.blue[800],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 500,
                      margin:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          TextField(
                            controller: _firstNameController,
                            decoration: InputDecoration(
                              labelText: 'First Name',
                              labelStyle: TextStyle(fontSize: 16),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(0)),
                                borderSide:
                                    BorderSide(color: Colors.grey[800]!),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(0)),
                                borderSide:
                                    BorderSide(color: Colors.grey[800]!),
                              ),
                            ),
                            enabled: _isEditing,
                          ),
                          SizedBox(height: 10),
                          TextField(
                            controller: _middleNameController,
                            decoration: InputDecoration(
                              labelText: 'Middle Name',
                              labelStyle: TextStyle(fontSize: 16),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(0)),
                                borderSide:
                                    BorderSide(color: Colors.grey[800]!),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(0)),
                                borderSide:
                                    BorderSide(color: Colors.grey[800]!),
                              ),
                            ),
                            enabled: _isEditing,
                          ),
                          SizedBox(height: 10),
                          TextField(
                            controller: _lastNameController,
                            decoration: InputDecoration(
                              labelText: 'Last Name',
                              labelStyle: TextStyle(fontSize: 16),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(0)),
                                borderSide:
                                    BorderSide(color: Colors.grey[800]!),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(0)),
                                borderSide:
                                    BorderSide(color: Colors.grey[800]!),
                              ),
                            ),
                            enabled: _isEditing,
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  // controller: _birthDateController,
                                  decoration: InputDecoration(
                                    labelText: 'Date of birth',
                                    labelStyle: TextStyle(fontSize: 16),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(0)),
                                      borderSide:
                                          BorderSide(color: Colors.grey[800]!),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(0)),
                                      borderSide:
                                          BorderSide(color: Colors.grey[800]!),
                                    ),
                                  ),
                                  enabled: _isEditing,
                                ),
                              ),
                              OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(0)))),
                                  onPressed: () {},
                                  child: Icon(Icons.date_range_rounded))
                            ],
                          ),
                          SizedBox(height: 10),
                          TextField(
                            controller: _phoneController,
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                              labelStyle: TextStyle(fontSize: 16),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(0)),
                                borderSide:
                                    BorderSide(color: Colors.grey[800]!),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(0)),
                                borderSide:
                                    BorderSide(color: Colors.grey[800]!),
                              ),
                            ),
                            enabled: _isEditing,
                          ),
                          SizedBox(height: 10),
                          TextField(
                            controller: _addressController,
                            decoration: InputDecoration(
                              labelText: 'Address',
                              labelStyle: TextStyle(fontSize: 16),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(0)),
                                borderSide:
                                    BorderSide(color: Colors.grey[800]!),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(0)),
                                borderSide:
                                    BorderSide(color: Colors.grey[800]!),
                              ),
                            ),
                            enabled: _isEditing,
                          ),
                          SizedBox(height: 20),
                          if (_isEditing)
                            ElevatedButton(
                              onPressed: () {
                                final updatedPatient = Patient(
                                  id: _patient.id,
                                  firstName: _firstNameController.text,
                                  middleName: _middleNameController.text,
                                  lastName: _lastNameController.text,
                                  birthDate: _patient.birthDate,
                                  gender: _patient.gender,
                                  phoneNumber: _phoneController.text,
                                  address: _addressController.text,
                                );

                                _saveChanges(updatedPatient);
                              },
                              child: Text('Save Changes'),
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                fixedSize:
                                    Size(MediaQuery.of(context).size.width, 30),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(0))),
                                backgroundColor: Colors.blue[800],
                                textStyle: GoogleFonts.poppins(fontSize: 20),
                              ),
                            ),
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
    );
  }
}
