import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class DentalRecord extends StatefulWidget {
  @override
  State<DentalRecord> createState() => _DentalRecordState();
}

class _DentalRecordState extends State<DentalRecord> {

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dental Records'),
      ),
      body: ListView(
        children: [
          DentalRecordItem(
            title: 'Record 1',
            date: '2023-07-10',
            fileUrl:
                'https://acrobatusers.com/assets/uploads/actions/File_Name_Stamper.pdf',
          ),
          DentalRecordItem(
            title: 'Record 2',
            date: '2023-07-09',
            fileUrl:
                'https://acrobatusers.com/assets/uploads/actions/File_Name_Stamper.pdf',
          ),
          DentalRecordItem(
            title: 'Record 3',
            date: '2023-07-08',
            fileUrl:
                'https://acrobatusers.com/assets/uploads/actions/File_Name_Stamper.pdf',
          ),
          // Add more DentalRecordItem widgets as needed
        ],
      ),
    );
  }
}

class DentalRecordItem extends StatelessWidget {
  final String title;
  final String date;
  final String fileUrl;

  const DentalRecordItem({
    required this.title,
    required this.date,
    required this.fileUrl,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(date),
      trailing: IconButton(
        color: Colors.blueGrey[100],
        icon: Icon(Icons.file_download_rounded),
        onPressed: () {
          _downloadFile(context);
        },
      ),
    );
  }

  Future<void> _downloadFile(BuildContext context) async {
    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final downloadPath = '${appDocDir.path}/denta';
      final savedDir = Directory(downloadPath);
      bool hasExisted = await savedDir.exists();
      if (!hasExisted) {
        savedDir.create();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Downloading $title...'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to download $title.'),
        ),
      );
    }
  }
}
