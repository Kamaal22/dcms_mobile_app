import 'package:dcms_mobile_app/assets/component.dart';
import 'package:dcms_mobile_app/index.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  int id = 1;
  String firstName = '';
  String middleName = '';
  String lastName = '';
  String birthDate = '';
  String gender = '';
  String phoneNumber = '';
  String address = '';
  String username = '';

  bool _isEditing = false;
  late TextEditingController _userNameController;
  late TextEditingController _firstNameController;
  late TextEditingController _middleNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _birthDateController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;

  Future<void> getPatientInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    id = prefs.getInt('patient_id')!;
    firstName = prefs.getString('first_name')!;
    middleName = prefs.getString('middle_name')!;
    lastName = prefs.getString('last_name')!;
    birthDate = prefs.getString('birth_date')!;
    phoneNumber = prefs.getString('phone_number')!;
    gender = prefs.getString('gender')!;
    address = prefs.getString('address')!;
    username = prefs.getString('username')!;

    setState(() {
      _userNameController = TextEditingController(text: username);
      _firstNameController = TextEditingController(text: firstName);
      _middleNameController = TextEditingController(text: middleName);
      _lastNameController = TextEditingController(text: lastName);
      _birthDateController = TextEditingController(
          text: DateFormat('dd-MMM-yyyy')
              .format(DateTime.parse(birthDate))
              .toString());

      _phoneController = TextEditingController(text: phoneNumber);
      _addressController = TextEditingController(text: address);
    });
  }

  @override
  void initState() {
    super.initState();
    getPatientInfo();
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  SnackBar messageSnackBar(
      Color? backgroundColor, Color? textColor, String message, int duration) {
    return SnackBar(
      duration: Duration(seconds: duration),
      backgroundColor: backgroundColor,
      content: Text(message,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500, fontSize: 20, color: textColor)),
    );
  }

  Future<void> _saveChanges() async {
    try {
      final response = await http.post(
        Uri.parse(API_ENDPOINT("patient/updatePersonalInfo.php")),
        body: {
          'patient_id': id.toString(),
          'first_name': _firstNameController.text,
          'middle_name': _middleNameController.text,
          'last_name': _lastNameController.text,
          'birth_date': _birthDateController.text,
          'phone_number': _phoneController.text,
          'address': _addressController.text,
          'username': _userNameController.text,
        },
      );
      print(response.body);
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        var data = jsonResponse['data'];
        print(data);
        print(jsonResponse);
        if (jsonResponse['status'] == 'success') {
          final prefs = await SharedPreferences.getInstance();
          prefs.setInt('patient_id', data['patient_id']);
          prefs.setString('first_name', data['first_name']);
          prefs.setString('middle_name', data['middle_name']);
          prefs.setString('last_name', data['last_name']);
          prefs.setString('birth_date', data['birth_date']);
          prefs.setString('gender', data['gender']);
          prefs.setString('phone_number', data['phone_number']);
          prefs.setString('address', data['address']);
          prefs.setString('username', data['username']);

          ScaffoldMessenger.of(context).showSnackBar((messageSnackBar(
              Colors.green[50],
              Colors.green[800],
              'Profile updated successfully',
              2)));
        } else {
          print(jsonResponse);
        }
        _toggleEditing();
      } else {
        ScaffoldMessenger.of(context).showSnackBar((messageSnackBar(
            Colors.red[50], Colors.red[800], 'Failed to update profile', 2)));
      }
    } catch (error) {
      print('Error: $error');
      ScaffoldMessenger.of(context).showSnackBar((messageSnackBar(
          Colors.red[50],
          Colors.red[800],
          'An error occurred while updating profile' + error.toString(),
          2)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkMode = themeProvider.isDarkMode;

    // Define colors based on the theme mode
    final iHeadColor = isDarkMode ? Colors.white : Colors.blue[800];
    final backgroundColor = isDarkMode ? Colors.grey[800] : Colors.grey[100];

    setState(() {
      setState(() {
        _userNameController = TextEditingController(text: username);
        _firstNameController = TextEditingController(text: firstName);
        _middleNameController = TextEditingController(text: middleName);
        _lastNameController = TextEditingController(text: lastName);
        _birthDateController = TextEditingController(
            text: DateFormat('dd-MMM-yyyy')
                .format(DateTime.parse(birthDate))
                .toString());

        _phoneController = TextEditingController(text: phoneNumber);
        _addressController = TextEditingController(text: address);
      });
    });

    return Scaffold(
      appBar: AppBar(
          backgroundColor: backgroundColor,
          title: Text(
            'Profile Settings',
            style: GoogleFonts.poppins(
              color: iHeadColor,
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: iHeadColor),
            onPressed: () => Navigator.of(context).pop(),
          ),
          elevation: 0),
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
                          color: backgroundColor,
                          border: Border.all(
                              color:
                                  isDarkMode ? Colors.grey[800]! : Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Personal Information',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              // fontWeight: FontWeight.bold,
                              color: iHeadColor,
                            ),
                          ),
                          if (!_isEditing)
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: _toggleEditing,
                              color: iHeadColor,
                            ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              color: backgroundColor,
                              border: Border.all(
                                  color: isDarkMode
                                      ? Colors.grey[800]!
                                      : Colors.grey),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Column(children: [
                            SizedBox(height: 20),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      left: BorderSide(
                                          width: 2, color: iHeadColor!))),
                              child: TextField(
                                style: TextStyle(color: iHeadColor),
                                controller: _userNameController,
                                decoration: InputDecoration(
                                  labelText: 'User Name',
                                  labelStyle: TextStyle(
                                      fontSize: 20, color: iHeadColor),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(10),
                                        topRight: Radius.circular(10)),
                                    borderSide: BorderSide(color: iHeadColor),
                                  ),
                                  border: InputBorder.none,
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(10),
                                        topRight: Radius.circular(10)),
                                    borderSide: BorderSide(color: iHeadColor),
                                  ),
                                ),
                                enabled: _isEditing,
                              ),
                            ),
                            SizedBox(height: 40),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      left: BorderSide(
                                          width: 2, color: iHeadColor))),
                              child: TextField(
                                style: TextStyle(color: iHeadColor),
                                controller: _firstNameController,
                                decoration: InputDecoration(
                                  labelText: 'First Name',
                                  labelStyle: TextStyle(
                                      fontSize: 20, color: iHeadColor),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(10),
                                        topRight: Radius.circular(10)),
                                    borderSide: BorderSide(color: iHeadColor),
                                  ),
                                  border: InputBorder.none,
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(10),
                                        topRight: Radius.circular(10)),
                                    borderSide: BorderSide(color: iHeadColor),
                                  ),
                                ),
                                enabled: _isEditing,
                              ),
                            ),
                            SizedBox(height: 30),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      left: BorderSide(
                                          width: 2, color: iHeadColor))),
                              child: TextField(
                                style: TextStyle(color: iHeadColor),
                                controller: _middleNameController,
                                decoration: InputDecoration(
                                  labelText: 'Middle Name',
                                  labelStyle: TextStyle(
                                      fontSize: 20, color: iHeadColor),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(10),
                                        topRight: Radius.circular(10)),
                                    borderSide: BorderSide(color: iHeadColor),
                                  ),
                                  border: InputBorder.none,
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(10),
                                        topRight: Radius.circular(10)),
                                    borderSide:
                                        BorderSide(color: iHeadColor, width: 2),
                                  ),
                                ),
                                enabled: _isEditing,
                              ),
                            ),
                            SizedBox(height: 30),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      left: BorderSide(
                                          width: 2, color: iHeadColor))),
                              child: TextField(
                                style: TextStyle(color: iHeadColor),
                                controller: _lastNameController,
                                decoration: InputDecoration(
                                  labelText: 'Last Name',
                                  labelStyle: TextStyle(
                                      fontSize: 20, color: iHeadColor),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(10),
                                        topRight: Radius.circular(10)),
                                    borderSide: BorderSide(color: iHeadColor),
                                  ),
                                  border: InputBorder.none,
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(10),
                                        topRight: Radius.circular(10)),
                                    borderSide:
                                        BorderSide(color: iHeadColor, width: 2),
                                  ),
                                ),
                                enabled: _isEditing,
                              ),
                            ),
                            SizedBox(height: 10)
                          ]),
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                color: backgroundColor,
                                border: Border.all(
                                    color: isDarkMode
                                        ? Colors.grey[800]!
                                        : Colors.grey),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Column(children: [
                              SizedBox(
                                height: 20,
                              ),
                              // if (_isEditing)
                              Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                        left: BorderSide(
                                            width: 2, color: iHeadColor))),
                                child: TextField(
                                  // textAlignVertical: TextAlignVertical.center,
                                  onTap: () async {
                                    DateTime? selectedDate =
                                        await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1900),
                                      lastDate: DateTime.now(),
                                    );
                                    if (selectedDate != null) {
                                      _birthDateController.text =
                                          DateFormat('dd-MMM-yyyy')
                                              .format(selectedDate);
                                    }
                                  },
                                  style: TextStyle(color: iHeadColor),
                                  controller: _birthDateController,
                                  decoration: InputDecoration(
                                    suffix: IconButton(
                                      iconSize: 30,
                                      alignment: Alignment.center,
                                      icon: Icon(
                                        Icons.date_range_rounded,
                                        color: iHeadColor,
                                      ),
                                      onPressed: () async {
                                        DateTime? selectedDate =
                                            await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(1900),
                                          lastDate: DateTime.now(),
                                        );
                                        if (selectedDate != null) {
                                          _birthDateController.text =
                                              DateFormat('dd-MMM-yyyy')
                                                  .format(selectedDate);
                                        }
                                      },
                                    ),
                                    labelText: 'Date of Birth',
                                    labelStyle: TextStyle(
                                        fontSize: 20, color: iHeadColor),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 0),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(10),
                                          topRight: Radius.circular(10)),
                                      borderSide: BorderSide(color: iHeadColor),
                                    ),
                                    border: InputBorder.none,
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(10),
                                          topRight: Radius.circular(10)),
                                      borderSide: BorderSide(
                                          color: iHeadColor, width: 2),
                                    ),
                                  ),
                                  enabled: _isEditing,
                                ),
                              ),
                              SizedBox(height: 30),
                              Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                        left: BorderSide(
                                            width: 2, color: iHeadColor))),
                                child: TextField(
                                  style: TextStyle(color: iHeadColor),
                                  controller: _phoneController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    labelText: 'Phone Number',
                                    labelStyle: TextStyle(
                                        fontSize: 20, color: iHeadColor),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(10),
                                          topRight: Radius.circular(10)),
                                      borderSide: BorderSide(color: iHeadColor),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(10),
                                          topRight: Radius.circular(10)),
                                      borderSide: BorderSide(
                                          color: iHeadColor, width: 2),
                                    ),
                                  ),
                                  enabled: _isEditing,
                                ),
                              ),
                              SizedBox(height: 30),
                              Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                        left: BorderSide(
                                            width: 2, color: iHeadColor))),
                                child: TextField(
                                  style: TextStyle(color: iHeadColor),
                                  controller: _addressController,
                                  decoration: InputDecoration(
                                    labelText: 'Address',
                                    labelStyle: TextStyle(
                                        fontSize: 20, color: iHeadColor),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(10),
                                          topRight: Radius.circular(10)),
                                      borderSide: BorderSide(color: iHeadColor),
                                    ),
                                    border: InputBorder.none,
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(10),
                                          topRight: Radius.circular(10)),
                                      borderSide: BorderSide(
                                          color: iHeadColor, width: 2),
                                    ),
                                  ),
                                  enabled: _isEditing,
                                ),
                              ),
                              SizedBox(height: 20)
                            ])),
                        if (_isEditing)
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            child: ElevatedButton(
                              onPressed: () {
                                _saveChanges();
                              },
                              child: Text('Save Changes'),
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                fixedSize:
                                    Size(MediaQuery.of(context).size.width, 50),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                backgroundColor: Colors.blue[800],
                                textStyle: GoogleFonts.poppins(fontSize: 20),
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 300)
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
