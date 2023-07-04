import 'package:flutter/material.dart';

class AppointmentModel extends StatefulWidget {
  @override
  _AppointmentModelState createState() => _AppointmentModelState();
}

class _AppointmentModelState extends State<AppointmentModel> {
  final _formKey = GlobalKey<FormState>();
  final List<String> dentists = ['Dr. Smith', 'Dr. Johnson', 'Dr. Brown'];
  String? selectedDentist; // Changed to nullable type
  DateTime? selectedDateTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Appointment'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Patient Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter patient name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      onTap: _selectDateTime,
                      decoration: InputDecoration(
                        labelText: 'Preferred Date and Time',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select preferred date and time';
                        }
                        return null;
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: _selectDateTime,
                    icon: Icon(Icons.calendar_today),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: selectedDentist,
                onChanged: (value) {
                  setState(() {
                    selectedDentist = value;
                  });
                },
                items: dentists.map((dentist) {
                  return DropdownMenuItem<String>(
                    value: dentist,
                    child: Text(dentist),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Select Dentist',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a dentist';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(labelText: 'Services Required'),
                maxLines: 3,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(labelText: 'Additional Notes'),
                maxLines: 3,
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectDateTime() async {
    final DateTime? pickedDateTime = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDateTime != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          selectedDateTime = DateTime(
            pickedDateTime.year,
            pickedDateTime.month,
            pickedDateTime.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() == true) {
      // Process the form data and schedule the appointment
      // Add your logic here for handling the form submission
    }
  }
}
