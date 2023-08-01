import 'dart:convert';

import 'package:dcms_mobile_app/assets/component.dart';
import 'package:dcms_mobile_app/themes/darktheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _isDarkMode = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                CircleAvatar(
                  radius: 100,
                  backgroundImage: AssetImage('assets/profile.jpg'),
                )
              ]),
              SizedBox(height: 50),
              Text(
                'Profile Content',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),

              // ///////////////////////////////////////////////////////////////////////////////////////////
              // ///////////////////////////////////////////////////////////////////////////////////////////
              // ///////////////////////////////////////////////////////////////////////////////////////////
              Container(
                decoration: radius(0, Colors.transparent, Colors.blueGrey),
                child: Column(children: [
                  ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PersonalInfoPage(),
                        ),
                      );
                    },
                    title: Row(
                      children: [
                        Icon(Icons.account_box_outlined),
                        Expanded(
                          child: Text(
                            'Personal Info',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios_rounded),
                      ],
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AboutAppPage(),
                        ),
                      );
                    },
                    title: Row(
                      children: [
                        Icon(Icons.info),
                        Expanded(
                          child: Text(
                            'About App',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios_rounded),
                      ],
                    ),
                  ),
                  ListTile(
                    onTap: () {},
                    title: Row(
                      children: [
                        Icon(Icons.warning_rounded),
                        Expanded(
                          child: Text(
                            'Feedback',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios_rounded),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  ListTile(
                    onTap: () {
                      _showLogoutConfirmationDialog(context);
                    },
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Logout',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.red[700]),
                          ),
                        ),
                        Icon(
                          Icons.logout_rounded,
                          color: Colors.red[700],
                        ),
                      ],
                    ),
                  ),
                ]),
              ),

              ///////////////////////////////////////////////////////////////////////////////////////////////////
              ///////////////////////////////////////////////////////////////////////////////////////////////////
              ///////////////////////////////////////////////////////////////////////////////////////////////////
              ///////////////////////////////////////////////////////////////////////////////////////////////////
              SizedBox(height: 30),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                height: 60,
                decoration: radius(0, Colors.transparent, Colors.blueGrey),
                child: SwitchListTile(
                  title: Text("Dark Mode"),
                  value: _isDarkMode,
                  onChanged: (value) {
                    setState(() {
                      _isDarkMode = value;
                    });
                    themeProvider.toggleTheme();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context); // Pop ProfilePage from the stack
                // Perform logout logic here
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}

class PersonalInfoPage extends StatefulWidget {
  @override
  _PersonalInfoPageState createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _middleNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _birthDateController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _currentPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmNewPasswordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = true;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    fetchPatientDataFromSharedPreferences();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _birthDateController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personal Info'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              setState(() {
                _isEditing = true;
              });
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _isEditing
              ? _buildEditForm()
              : _buildDisplayForm(),
    );
  }

  Widget _buildDisplayForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDisplayField('First Name', _firstNameController.text),
          SizedBox(height: 20),
          _buildDisplayField('Middle Name', _middleNameController.text),
          SizedBox(height: 20),
          _buildDisplayField('Last Name', _lastNameController.text),
          SizedBox(height: 20),
          _buildDisplayField('Birth Date', _birthDateController.text),
          SizedBox(height: 20),
          _buildDisplayField('Phone Number', _phoneNumberController.text),
          SizedBox(height: 20),
          _buildDisplayField('Address', _addressController.text),
        ],
      ),
    );
  }

  Widget _buildEditForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRoundedTextField('First Name', _firstNameController),
            SizedBox(height: 20),
            _buildRoundedTextField('Middle Name', _middleNameController),
            SizedBox(height: 20),
            _buildRoundedTextField('Last Name', _lastNameController),
            SizedBox(height: 20),
            _buildRoundedTextField('Birth Date', _birthDateController),
            SizedBox(height: 20),
            _buildRoundedTextField('Phone Number', _phoneNumberController),
            SizedBox(height: 20),
            _buildRoundedTextField('Address', _addressController),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _savePatientInfo,
              child: Text('Save'),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: _showChangePasswordDialog,
              child: Text('Change Password'),
            ),
          ],
        ),
      ),
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change Password'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  obscureText: true,
                  controller: _currentPasswordController,
                  decoration: InputDecoration(labelText: 'Current Password'),
                  validator: (val) => val!.isEmpty ? 'Required' : null,
                ),
                SizedBox(height: 20),
                TextFormField(
                  obscureText: true,
                  controller: _newPasswordController,
                  decoration: InputDecoration(labelText: 'New Password'),
                  validator: (val) => val!.isEmpty ? 'Required' : null,
                ),
                SizedBox(height: 20),
                TextFormField(
                  obscureText: true,
                  controller: _confirmNewPasswordController,
                  decoration:
                      InputDecoration(labelText: 'Confirm New Password'),
                  validator: (value) {
                    if (value != _newPasswordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: _isLoading ? null : () => _changePassword(context),
              child: Text('Change Password'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDisplayField(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(width: 8),
        Text(value, style: TextStyle(fontSize: 16)),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildRoundedTextField(
    String label,
    TextEditingController controller,
  ) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      validator: (val) => val!.isEmpty ? 'Required' : null,
    );
  }

  Future<void> _savePatientInfo() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      Patient patient = Patient(
        firstName: _firstNameController.text,
        middleName: _middleNameController.text,
        lastName: _lastNameController.text,
        birthDate: _birthDateController.text,
        phoneNumber: _phoneNumberController.text,
        address: _addressController.text,
      );

      try {
        await saveUpdatedPatientInfoToSharedPreferences(patient);
        await saveUpdatedPatientInfoToApi(patient); // Save to API endpoint.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              'Patient information saved successfully.',
            ),
            duration: Duration(seconds: 3),
          ),
        );
        setState(() {
          _isEditing = false;
        });
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              'Failed to save patient information. Please try again.',
            ),
            duration: Duration(seconds: 3),
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _changePassword(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      String currentPassword = _currentPasswordController.text;
      String newPassword = _newPasswordController.text;

      try {
        // Replace the following API_ENDPOINT with your actual API endpoint URL.
        const API_ENDPOINT = 'https://example.com/change_password';
        var response = await http.post(
          Uri.parse(API_ENDPOINT),
          body: {
            'current_password': currentPassword,
            'new_password': newPassword,
          },
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Text(
                'Password changed successfully.',
              ),
              duration: Duration(seconds: 3),
            ),
          );
          Navigator.pop(
              context); // Close the dialog after successful password change.
        } else {
          throw Exception('Failed to change password: ${response.body}');
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              'Failed to change password: $error',
            ),
            duration: Duration(seconds: 3),
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> saveUpdatedPatientInfoToSharedPreferences(
      Patient patient) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      await prefs.setString('first_name', patient.firstName);
      await prefs.setString(
          'middle_name', patient.middleName); // Added middle name saving
      await prefs.setString('last_name', patient.lastName);
      await prefs.setString('birth_date', patient.birthDate);
      await prefs.setString('phone_number', patient.phoneNumber);
      await prefs.setString('address', patient.address);
      print("Profile Information updated successfully");
    } catch (e) {
      print("Error: $e");
      throw Exception('Failed to update patient information');
    }
  }

  Future<String?> getPasswordFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('password');
  }

  Future<void> saveNewPasswordToSharedPreferences(String newPassword) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('password', newPassword);
    print("Password changed successfully");
  }

  Future<void> saveUpdatedPatientInfoToApi(Patient patient) async {
    // Replace this function with your actual API call to update patient information.
    // For demonstration purposes, this function is left empty.
  }

  void fetchPatientDataFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      String? firstName = prefs.getString('first_name');
      String? middleName =
          prefs.getString('middle_name'); // Added middle name retrieval
      String? lastName = prefs.getString('last_name');
      String? birthDate = prefs.getString('birth_date');
      String? phoneNumber = prefs.getString('phone_number');
      String? address = prefs.getString('address');

      if (firstName != null &&
          middleName != null &&
          lastName != null &&
          birthDate != null &&
          phoneNumber != null &&
          address != null) {
        setState(() {
          _firstNameController.text = firstName;
          _middleNameController.text = middleName; // Added middle name setting
          _lastNameController.text = lastName;
          _birthDateController.text = birthDate;
          _phoneNumberController.text = phoneNumber;
          _addressController.text = address;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              'Failed to load patient data from SharedPreferences.',
              style: GoogleFonts.nunito(),
            ),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Failed to load patient data from SharedPreferences: $error',
            style: GoogleFonts.nunito(),
          ),
          duration: Duration(seconds: 3),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}

class Patient {
  final String firstName;
  final String middleName; // Added middle name
  final String lastName;
  final String birthDate;
  final String phoneNumber;
  final String address;

  Patient({
    required this.firstName,
    required this.middleName, // Added middle name
    required this.lastName,
    required this.birthDate,
    required this.phoneNumber,
    required this.address,
  });
}

class AboutAppPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About App'),
        toolbarHeight: 100,
        foregroundColor: Colors.blueGrey[300],
        elevation: 0,
      ),
      body: Center(
        child: Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              "Welcome to our Dental Clinic Management "
              "System mobile app! Experience the convenience of managing your dental appointments online, right at your fingertips. "
              " Our user-friendly Flutter-based app offers a seamless and efficient way to schedule, track, and organize your dental appointments. "
              "Gone are the days of waiting on hold or standing in queues to book an appointment. With our app, you can easily browse through available time slots, select a preferred dentist, and secure your appointment with just a few taps. "
              "Say goodbye to appointment conflicts or double bookings; our intelligent scheduling system ensures optimal management of the dental clinic's calendar. Beyond scheduling, our app offers a host of features designed to enhance your overall dental experience. "
              "Stay informed with timely reminders for upcoming appointments, allowing you to plan your day effectively. Additionally, you can access your dental history and treatment records, empowering you to make informed decisions about your oral health. "
              "Our Dental Clinic Management System app is committed to maintaining the highest standards of security and privacy. Rest assured that your personal information and medical records are safeguarded with the utmost care. "
              "Join our ever-growing community of satisfied patients who have embraced the ease and efficiency of managing their dental appointments through our mobile app. Download it now and take the first step towards a stress-free dental journey. "
              "Achieve a healthy smile effortlessly with our Dental Clinic Management System app!",
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
