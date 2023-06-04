import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mysql1/mysql1.dart';

class Mysql {
  static String host = "192.168.1.10",
      user = "root",
      password = "hi",
      database = "dental_clinic";
  static int port = 3306;

  Mysql();

  Future<MySqlConnection> getConnection() async {
    var settings = new ConnectionSettings(
        host: host, user: user, password: password, db: database, port: port);
    return await MySqlConnection.connect(settings);
  }
}

class APIManager {
  static const String baseUrl =
      'http://192.168.1.10/DCMS/app/mobile/'; // API endpoint URL

  Future<Map<String, dynamic>> getData(String query) async {
    final url = Uri.parse('$baseUrl/services/data.php');
    final response = await http.post(url, body: {'query': query});

    if (response.statusCode == 200) {
      // Parse the JSON data
      Map<String, dynamic> data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to retrieve data');
    }
  }

  Future<bool> insertData(
      String tableName, Map<String, dynamic> columnValues) async {
    final url = Uri.parse('$baseUrl/appointment/insert.php');
    final response =
        await http.post(url, body: {'tableName': tableName, ...columnValues});
    return response.statusCode == 200;
  }

  Future<bool> updateData(
      String tableName, int id, Map<String, dynamic> columnValues) async {
    final url = Uri.parse('$baseUrl/appointment/update.php');
    final response = await http.post(url,
        body: {'tableName': tableName, 'id': id.toString(), ...columnValues});
    return response.statusCode == 200;
  }

  Future<bool> deleteData(String tableName, String columnName, int id) async {
    final url = Uri.parse('$baseUrl/appointment/delete.php');
    final response = await http.post(url, body: {
      'tableName': tableName,
      'column': columnName,
      'id': id.toString(),
    });
    return response.statusCode == 200;
  }
}
