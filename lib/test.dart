// import 'package:flutter/material.dart';

// class DropdownExample extends StatefulWidget {
//   @override
//   _DropdownExampleState createState() => _DropdownExampleState();
// }

// class _DropdownExampleState extends State<DropdownExample> {
//   String _selectedItem = 'Item 1'; // Initialize with a default value

//   List<String> _dropdownItems = [
//     'Item 1',
//     'Item 2',
//     'Item 3',
//     'Item 4',
//     'Item 5',
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Dropdown Example'),
//       ),
//       body: Center(
//         child: Container(
//           padding: EdgeInsets.all(16.0),
//           child: DropdownButton(
//             value: _selectedItem,
//             hint: Text('Select an item'),
//             onChanged: (newValue) {
//               setState(() {
//                 _selectedItem = newValue.toString();
//               });
//             },
//             items: _dropdownItems.map((String value) {
//               return DropdownMenuItem(
//                 value: value,
//                 child: Text(value),
//               );
//             }).toList(),
//           ),
//         ),
//       ),
//     );
//   }
// }

// late DateTime _selectedStartDate = DateTime.now();
// late TimeOfDay _selectedStartTime = TimeOfDay.now();
// late DateTime _selectedEndDate = DateTime.now();
// late TimeOfDay _selectedEndTime = TimeOfDay.now();

// Future<void> _selectStartDate() async {
//   final DateTime? pickedDate = await showDatePicker(
//     context: context,
//     initialDate: _selectedStartDate,
//     firstDate: DateTime(2020),
//     lastDate: DateTime(2100),
//   );

//   if (pickedDate != null && pickedDate != _selectedStartDate) {
//     setState(() {
//       _selectedStartDate = pickedDate;
//     });
//   }
// }

// Future<void> _selectStartTime() async {
//   final TimeOfDay? pickedTime = await showTimePicker(
//     context: context,
//     initialTime: _selectedStartTime,
//   );

//   if (pickedTime != null && pickedTime != _selectedStartTime) {
//     setState(() {
//       _selectedStartTime = pickedTime;
//     });
//   }
// }

// Future<void> _selectEndDate() async {
//   final DateTime? pickedDate = await showDatePicker(
//     context: context,
//     initialDate: _selectedEndDate,
//     firstDate: DateTime(2020),
//     lastDate: DateTime(2100),
//   );

//   if (pickedDate != null && pickedDate != _selectedEndDate) {
//     setState(() {
//       _selectedEndDate = pickedDate;
//     });
//   }
// }

// Future<void> _selectEndTime() async {
//   final TimeOfDay? pickedTime = await showTimePicker(
//     context: context,
//     initialTime: _selectedEndTime,
//   );

//   if (pickedTime != null && pickedTime != _selectedEndTime) {
//     setState(() {
//       _selectedEndTime = pickedTime;
//     });
//   }
// }

// String formatDateTime(DateTime date, TimeOfDay time) {
//   final String formattedDate =
//       '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
//   final String formattedTime =
//       '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
//   return '$formattedDate $formattedTime';
// }

// Future<bool> insertAppointment(Map<String, dynamic> columnValues) async {
//   Mysql mysql = Mysql();

//   // Insert
//   bool insertSuccess = await mysql.insert("appointments", columnValues);
//   return insertSuccess;
// }

// Future<void> saveAppointment() async {
//   Map<String, dynamic> insertValues = {
//     'Type': 'Online',
//     'status': 'Pending',
//     'start_date': formatDateTime(_selectedStartDate, _selectedStartTime),
//     'end_date': formatDateTime(_selectedEndDate, _selectedEndTime),
//     'patient_id': 16,
//     'employee_id': 1,
//     'service_id': null,
//   };

//   bool insertSuccess = await insertAppointment(insertValues);
//   if (insertSuccess) {
//     SToast('Appointment inserted successfully!', Colors.green, Colors.white);
//   } else {
//     SToast('Failed to insert appointment.', Colors.red, Colors.white);
//   }
// }
