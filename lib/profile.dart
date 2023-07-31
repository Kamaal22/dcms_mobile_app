import 'dart:convert';

import 'package:dcms_mobile_app/themes/darktheme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

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
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(0),
                  color: Colors.blueGrey,
                ),
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
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(0),
                  color: Colors.blueGrey,
                ),
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
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _birthDateController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchPatientDataFromApi();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _birthDateController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personal Info'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : _buildForm(),
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            keyboardType: TextInputType.name,
            controller: _firstNameController,
            decoration: InputDecoration(labelText: 'First Name'),
            validator: _validateField,
          ),
          TextFormField(
            controller: _lastNameController,
            decoration: InputDecoration(labelText: 'Last Name'),
            validator: _validateField,
          ),
          TextFormField(
            keyboardType: TextInputType.datetime,
            controller: _birthDateController,
            decoration: InputDecoration(labelText: 'Birth Date'),
            validator: _validateField,
          ),
          TextFormField(
            controller: _phoneNumberController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(labelText: 'Phone Number'),
            validator: _validateField,
          ),
          TextFormField(
            controller: _addressController,
            decoration: InputDecoration(labelText: 'Address'),
            validator: _validateField,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              textStyle: TextStyle(fontFamily: 'GoogleFonts.nunito()'),
              primary: Colors.transparent,
              onPrimary: Colors.blueGrey,
              padding: EdgeInsets.zero,
              fixedSize: Size(MediaQuery.of(context).size.width, 30),
              side: BorderSide(width: 1, color: Colors.blueGrey),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onPressed: _isLoading ? null : _savePatientInfo,
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  String? _validateField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a value';
    }
    return null;
  }

  Future<void> _savePatientInfo() async {
    if (_validateForm()) {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      Patient patient = Patient(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        birthDate: _birthDateController.text,
        phoneNumber: _phoneNumberController.text,
        address: _addressController.text,
      );

      try {
        await saveUpdatedPatientInfo(patient);
        Navigator.pop(context); // Go back to the previous screen after saving
      } catch (error) {
        setState(() {
          _errorMessage =
              'Failed to save patient information. Please try again.';
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  bool _validateForm() {
    final form = Form.of(context);
    return form.validate();
  }

  Future<void> fetchPatientDataFromApi() async {
    try {
      final response = await http.post(
        Uri.parse(
          "http://192.168.33.163/DCMS/app/mobile/patient/getPatientInfo.php",
        ),
        body: {'patient_id': '3'},
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print(jsonData);
        if (jsonData['status'] == 'success') {
          final patientData =
              jsonData['data'][0]; // Use [0] to access the first patient data
          setState(() {
            _firstNameController.text = patientData['first_name'];
            _lastNameController.text = patientData['last_name'];
            _birthDateController.text = patientData['birth_date'];
            _phoneNumberController.text = patientData['phone_number'];
            _addressController.text = patientData['address'];
          });
        } else {
          setState(() {
            _errorMessage = 'Failed to load patient data: ' + jsonData['data'];
          });
        }
      } else {
        setState(() {
          _errorMessage =
              'Failed to load patient data: Status code: ${response.statusCode}';
        });
      }
    } catch (error) {
      setState(() {
        _errorMessage = 'Failed to load patient data: $error';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> saveUpdatedPatientInfo(Patient patient) async {
    try {
      final response = await http.post(
        Uri.parse(
          "http://192.168.33.163/DCMS/app/mobile/patient/updatePatientInfo.php",
        ),
        body: {
          'patient_id': '3',
          'first_name': patient.firstName,
          'last_name': patient.lastName,
          'birth_date': patient.birthDate,
          'phone_number': patient.phoneNumber,
          'address': patient.address,
        },
      );

      if (response.statusCode != 200 ||
          json.decode(response.body)['status'] != 'success') {
        throw Exception('Failed to update patient information');
      } else {
        print("Profile Information updated successfully");
      }
    } catch (e) {
      print("Error: " + e.toString());
    }
  }
}

class Patient {
  final String firstName;
  final String lastName;
  final String birthDate;
  final String phoneNumber;
  final String address;

  Patient({
    required this.firstName,
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
