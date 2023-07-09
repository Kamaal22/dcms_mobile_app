import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

class Employee {
  final int id;
  final String name;

  Employee(this.id, this.name);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      map['id'],
      map['name'],
    );
  }
}

Future<List<Employee>> fetchEmployeesFromApi() async {
  final response = await http
      .get(Uri.parse('http://192.168.129.163/appt/fetch_employees.php'));

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    print(data);
    final List<Employee> employees = data.map((item) {
      final int id = item['id'] ?? 0; // Null check for id
      final String name = item['name'] ?? ''; // Null check for name
      return Employee(id, name);
    }).toList();

    await storeEmployees(employees);

    return employees;
  } else {
    throw Exception('Failed to fetch employees');
  }
}

Future<void> storeEmployees(List<Employee> employees) async {
  final Database db = await _initDatabase();
  final batch = db.batch();

  await db.delete('employees');

  for (final employee in employees) {
    batch.insert(
      'employees',
      employee.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  await batch.commit();
}

Future<List<Employee>> fetchEmployeesFromDatabase() async {
  final Database db = await _initDatabase();
  final List<Map<String, dynamic>> results = await db.query('employees');
  final List<Employee> employees =
      results.map((map) => Employee.fromMap(map)).toList();
  print(employees);
  return employees;
}

class Service {
  final int id;
  final String name;
  bool isSelected;

  Service(this.id, this.name, this.isSelected);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory Service.fromMap(Map<String, dynamic> map) {
    return Service(
      map['id'],
      map['name'],
      false, // Initialize isSelected as false
    );
  }
}

Future<List<Service>> fetchServicesFromApi() async {
  final response = await http
      .get(Uri.parse('http://192.168.129.163/appt/fetch_services.php'));

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    print(data);
    final List<Service> services = data.map((item) {
      final int id = item['id'] ?? 0; // Null check for id
      final String name = item['name'] ?? ''; // Null check for name
      return Service(id, name, false);
    }).toList();

    await storeServices(services);

    return services;
  } else {
    throw Exception('Failed to fetch services');
  }
}

Future<void> storeServices(List<Service> services) async {
  final Database db = await _initDatabase();
  final batch = db.batch();

  await db.delete('services');

  for (final service in services) {
    batch.insert(
      'services',
      service.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  await batch.commit();
}

Future<List<Service>> fetchServicesFromDatabase() async {
  final Database db = await _initDatabase();
  final List<Map<String, dynamic>> results = await db.query('services');
  final List<Service> services =
      results.map((map) => Service.fromMap(map)).toList();
  print(services);
  return services;
}

Future<Database> _initDatabase() async {
  final databasesPath = await getDatabasesPath();
  final dbPath = path.join(databasesPath, 'denta.db');

  return await openDatabase(
    dbPath,
    version: 1,
    onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE employees (
          id INTEGER PRIMARY KEY,
          name TEXT
        )
      ''');
      await db.execute('''
        CREATE TABLE services (
          id INTEGER PRIMARY KEY,
          name TEXT
        )
      ''');
    },
  );
}
