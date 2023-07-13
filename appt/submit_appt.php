<?php

// Retrieve the appointment data
$type = $_POST['type'];
$status = $_POST['status'];
$date = $_POST['date'];
$time = $_POST['time'];
$patientId = $_POST['patient_id'];
$note = $_POST['note'];

// Retrieve the patient ID from Shared Preferences or any other source
// TODO: Replace this with your actual code to retrieve the patient ID
// $patientId = $_GET['patient_id'];

// Set the services and employee as null for now
// $services = null;
$employeeId = 2;

// Create a mysqli connection
$host = 'localhost';
$username = 'root';
$password = '';
$database = 'denta';

$response = [];

try {
    // Create a mysqli connection
    $connection = new mysqli($host, $username, $password, $database);

    if ($connection->connect_error) {
        throw new Exception('Failed to connect to the database: ' . $connection->connect_error);
    }

    // Sanitize and validate the data before using it in SQL queries
    $type = $connection->real_escape_string($type);
    $status = $connection->real_escape_string($status);
    $date = $connection->real_escape_string($date);
    $time = $connection->real_escape_string($time);
    $patientId = $connection->real_escape_string($patientId);

    // Process the appointment data (e.g., save to database, send email, etc.)
    // TODO: Add your code here to handle the appointment data
    // Example:
    $query = "INSERT INTO appointments (Type, status, date, time, patient_id, employee_id, note) 
              VALUES ('$type', '$status', '$date', '$time', '$patientId', '$employeeId', '$note')";

    if ($connection->query($query) === TRUE) {
        $response['status'] = 'success';
        $response['message'] = 'Appointment created successfully';
    } else {
        throw new Exception('Failed to create appointment: ' . $connection->error);
    }

    // Close the database connection
    $connection->close();
} catch (Exception $e) {
    $response['status'] = 'error';
    $response['message'] = $e->getMessage();
}

// Return a response to the Flutter app
header('Content-Type: application/json');
echo json_encode($response);
?>