import 'package:flutter/material.dart';

class DentalRecord extends StatefulWidget {
  @override
  _DentalRecordState createState() => _DentalRecordState();
}

class _DentalRecordState extends State<DentalRecord> {
  List<DentalEntry> dentalEntries = [
    DentalEntry(
      date: DateTime(2022, 5, 15),
      treatment: 'Dental Cleaning',
      diagnosis: 'Healthy gums, minimal tartar buildup',
      medications: '',
      allergies: '',
    ),
    DentalEntry(
      date: DateTime(2022, 6, 30),
      treatment: 'Tooth Extraction',
      diagnosis: 'Severe tooth decay',
      medications: 'Prescribed painkillers',
      allergies: 'Penicillin',
    ),
    DentalEntry(
      date: DateTime(2022, 8, 20),
      treatment: 'Root Canal',
      diagnosis: 'Infected tooth pulp',
      medications: 'Prescribed antibiotics',
      allergies: '',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dental Record'),
      ),
      body: ListView.builder(
        itemCount: dentalEntries.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              dentalEntries[index].treatment,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('Date: ${dentalEntries[index].date.toString()}'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DentalEntryDetailsPage(
                    dentalEntry: dentalEntries[index],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddDentalEntryPage(),
            ),
          ).then((newEntry) {
            if (newEntry != null) {
              setState(() {
                dentalEntries.add(newEntry);
              });
            }
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class DentalEntry {
  final DateTime date;
  final String treatment;
  final String diagnosis;
  final String medications;
  final String allergies;

  DentalEntry({
    required this.date,
    required this.treatment,
    required this.diagnosis,
    required this.medications,
    required this.allergies,
  });
}

class DentalEntryDetailsPage extends StatelessWidget {
  final DentalEntry dentalEntry;

  DentalEntryDetailsPage({required this.dentalEntry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dental Entry Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Treatment: ${dentalEntry.treatment}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text('Date: ${dentalEntry.date.toString()}'),
            SizedBox(height: 8.0),
            Text('Diagnosis: ${dentalEntry.diagnosis}'),
            SizedBox(height: 8.0),
            Text('Medications: ${dentalEntry.medications}'),
            SizedBox(height: 8.0),
            Text('Allergies: ${dentalEntry.allergies}'),
          ],
        ),
      ),
    );
  }
}

class AddDentalEntryPage extends StatefulWidget {
  @override
  _AddDentalEntryPageState createState() => _AddDentalEntryPageState();
}

class _AddDentalEntryPageState extends State<AddDentalEntryPage> {
  TextEditingController _treatmentController = TextEditingController();
  TextEditingController _diagnosisController = TextEditingController();
  TextEditingController _medicationsController = TextEditingController();
  TextEditingController _allergiesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Dental Entry'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _treatmentController,
              decoration: InputDecoration(labelText: 'Treatment'),
            ),
            TextField(
              controller: _diagnosisController,
              decoration: InputDecoration(labelText: 'Diagnosis'),
            ),
            TextField(
              controller: _medicationsController,
              decoration: InputDecoration(labelText: 'Medications'),
            ),
            TextField(
              controller: _allergiesController,
              decoration: InputDecoration(labelText: 'Allergies'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                DentalEntry newEntry = DentalEntry(
                  date: DateTime.now(),
                  treatment: _treatmentController.text,
                  diagnosis: _diagnosisController.text,
                  medications: _medicationsController.text,
                  allergies: _allergiesController.text,
                );
                Navigator.pop(context, newEntry);
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
