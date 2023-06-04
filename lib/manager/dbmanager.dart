import 'package:http/http.dart' as http;
import 'dart:convert';

class DatabaseManager {
  static const String apiUrl =
      'http://your-api-url'; // Replace with your API URL

  Future<bool> insert(
      String tableName, Map<String, dynamic> columnValues) async {
    final url = Uri.parse('$apiUrl/insert.php');
    final response = await http.post(url, body: {
      'tableName': tableName,
      'columnValues': jsonEncode(columnValues),
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['success'];
    }
    return false;
  }

  Future<bool> update(
      String tableName, int id, Map<String, dynamic> columnValues) async {
    final url = Uri.parse('$apiUrl/update.php');
    final response = await http.post(url, body: {
      'tableName': tableName,
      'id': id.toString(),
      'columnValues': jsonEncode(columnValues),
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['success'];
    }
    return false;
  }

  Future<bool> delete(String tableName, int id) async {
    final url = Uri.parse('$apiUrl/delete.php');
    final response = await http.post(url, body: {
      'tableName': tableName,
      'id': id.toString(),
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['success'];
    }
    return false;
  }
}
