// // ignore_for_file: prefer_const_literals_to_create_immutables, unnecessary_null_comparison, prefer_const_constructors, unused_field, library_private_types_in_public_api

// import 'package:flutter/material.dart';

// class SignUpScreen extends StatefulWidget {
//   const SignUpScreen({super.key});

//   @override
//   _SignUpScreenState createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends State<SignUpScreen> {
//   final _formKey = GlobalKey<FormState>();
//   late String _firstName;
//   late String _middleName;
//   late String _lastName;
//   late DateTime _dob;
//   late String _gender;
//   late String _username;
//   late String _password;
//   late String _email;

//   Future<void> _submitForm() async {
//     if (_formKey.currentState!.validate()) {
//       // send POST request to server to store user's data in MySQL database
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('Sign Up'),
//         ),
//         body: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: <Widget>[
//                   TextFormField(
//                     decoration: InputDecoration(labelText: 'First Name'),
//                     validator: (value) {
//                       if (value!.isEmpty) {
//                         return 'Please enter your first name.';
//                       }
//                       return null;
//                     },
//                     onSaved: (value) {
//                       _firstName = value!;
//                     },
//                   ),
//                   TextFormField(
//                     decoration: InputDecoration(labelText: 'Middle Name'),
//                     onSaved: (value) {
//                       _middleName = value!;
//                     },
//                   ),
//                   TextFormField(
//                     decoration: InputDecoration(labelText: 'Last Name'),
//                     validator: (value) {
//                       if (value!.isEmpty) {
//                         return 'Please enter your last name.';
//                       }
//                       return null;
//                     },
//                     onSaved: (value) {
//                       _lastName = value!;
//                     },
//                   ),
//                   TextFormField(
//                     decoration: InputDecoration(labelText: 'Date of Birth'),
//                     onTap: () async {
//                       DateTime? dob = await showDatePicker(
//                         context: context,
//                         initialDate: DateTime(2000),
//                         firstDate: DateTime(1900),
//                         lastDate: DateTime(2100),
//                       );
//                       setState(() {
//                         _dob = dob!;
//                       });
//                     },
//                     validator: (value) {
//                       if (_dob == null) {
//                         return 'Please enter your date of birth.';
//                       }
//                       return null;
//                     },
//                     onSaved: (value) {},
//                   ),
//                   DropdownButtonFormField(
//                     value: _gender,
//                     decoration: InputDecoration(labelText: 'Gender'),
//                     items: [
//                       DropdownMenuItem(value: 'Male', child: Text('Male')),
//                       DropdownMenuItem(value: 'Female', child: Text('Female')),
//                       DropdownMenuItem(value: 'Other', child: Text('Other')),
//                     ],
//                     onChanged: (value) {
//                       setState(() {
//                         _gender = value!;
//                       });
//                     },
//                     validator: (value) {
//                       if (value == null) {
//                         return 'Please select your gender.';
//                       }
//                       return null;
//                     },
//                     onSaved: (value) {},
//                   ),
//                   TextFormField(
//                     decoration: InputDecoration(labelText: 'Username'),
//                     validator: (value) {
//                       if (value!.isEmpty) {
//                         return 'Please enter a username.';
//                       }
//                       return null;
//                     },
//                     onSaved: (value) {
//                       _username = value!;
//                     },
//                   ),
//                   TextFormField(
//                     obscureText: true,
//                     decoration: InputDecoration(labelText: 'Password'),
//                     validator: (value) {
//                       if (value!.isEmpty) {
//                         return 'Please enter a password.';
//                       }
//                       return null;
//                     },
//                     onSaved: (value) {
//                       _password = value!;
//                     },
//                   ),
//                   TextFormField(
//                     decoration: InputDecoration(labelText: 'Email Address'),
//                     validator: (value) {
//                       if (value!.isEmpty) {
//                         return 'Please enter an email address.';
//                       }
//                       if (!EmailValidator.validate(value)) {
//                         return 'Please enter a valid email address.';
//                       }
//                       return null;
//                     },
//                     onSaved: (value) {
//                       _email = value!;
//                     },
//                   ),
//                   SizedBox(height: 16.0),
//                   ElevatedButton(
//                     onPressed: _submitForm,
//                     child: Text('Sign Up'),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ));
//   }
// }
