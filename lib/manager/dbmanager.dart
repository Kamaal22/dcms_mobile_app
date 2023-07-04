// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

// // class DatabaseManager {
// //   static const String apiUrl =
// //       'http://your-api-url'; // Replace with your API URL

// //   Future<bool> insert(
// //       String tableName, Map<String, dynamic> columnValues) async {
// //     final url = Uri.parse('$apiUrl/insert.php');
// //     final response = await http.post(url, body: {
// //       'tableName': tableName,
// //       'columnValues': jsonEncode(columnValues),
// //     });

// //     if (response.statusCode == 200) {
// //       final data = jsonDecode(response.body);
// //       return data['success'];
// //     }
// //     return false;
// //   }

// //   Future<bool> update(
// //       String tableName, int id, Map<String, dynamic> columnValues) async {
// //     final url = Uri.parse('$apiUrl/update.php');
// //     final response = await http.post(url, body: {
// //       'tableName': tableName,
// //       'id': id.toString(),
// //       'columnValues': jsonEncode(columnValues),
// //     });

// //     if (response.statusCode == 200) {
// //       final data = jsonDecode(response.body);
// //       return data['success'];
// //     }
// //     return false;
// //   }

// //   Future<bool> delete(String tableName, int id) async {
// //     final url = Uri.parse('$apiUrl/delete.php');
// //     final response = await http.post(url, body: {
// //       'tableName': tableName,
// //       'id': id.toString(),
// //     });

// //     if (response.statusCode == 200) {
// //       final data = jsonDecode(response.body);
// //       return data['success'];
// //     }
// //     return false;
// //   }
// // }
// class DatabaseManager {
//   static const String dbName = 'your_database.db';
//   static const String tableName = 'user';
//   static const String columnUserId = 'user_id';
//   static const String columnUsername = 'username';
//   static const String columnPassword = 'password';

//   static Future<Database> openDatabase() async {
//     final databasesPath = await getDatabasesPath();
//     final path = join(databasesPath, dbName);

//     return openDatabase(
//       path,
//       version: 1,
//       onCreate: (db, version) {
//         db.execute('''
//           CREATE TABLE $tableName (
//             $columnUserId TEXT PRIMARY KEY,
//             $columnUsername TEXT,
//             $columnPassword TEXT
//           )
//         ''');
//       },
//     );
//   }

//   static Future<void> saveUserData(
//       String userId, String username, String password) async {
//     final db = await openDatabase();
//     await db.insert(
//       tableName,
//       {
//         columnUserId: userId,
//         columnUsername: username,
//         columnPassword: password,
//       },
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }

//   static Future<Map<String, dynamic>?> getUserData() async {
//     final db = await openDatabase();
//     final data = await db.query(tableName);
//     return data.isNotEmpty ? data.first : null;
//   }
// }
