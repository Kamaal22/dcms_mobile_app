<?php

// Create a connection to the database
$connection = mysqli_connect('localhost', 'root', '', 'dental_clinic');

// Check if the connection was successful
if (!$connection) {
    $response = [
        'statusCode' => 500,
        'status' => 'error',
        'message' => 'Error connecting to the database: ' . mysqli_connect_error(),
    ];
    echo json_encode($response);
    exit;
}

$response = [];

try {
    // Get the data from the POST request
    $type = $_POST['type'] ?? 'Online';
    $status = $_POST['status'] ?? 'Pending';
    $date = $connection->real_escape_string($_POST['date']);
    $time = $connection->real_escape_string($_POST['time']);
    $patientId = $connection->real_escape_string($_POST['patient_id']) ?? 1;
    $note = $_POST['note'] ?? null;

    // Check if the appointment time is already taken
    $checkQuery = "SELECT * FROM appointments 
    WHERE date = '$date' 
    AND (time = '$time' OR time = DATE_ADD('$time', INTERVAL 10 MINUTE) OR time = DATE_SUB('$time', INTERVAL 10 MINUTE))";
    $result = $connection->query($checkQuery);

    if ($result && $result->num_rows > 0) {
        $response = [
            'statusCode' => 400,
            'status' => 'errorT',
            'message' => 'Time has already been appointed.',
        ];
        echo json_encode($response);
        exit;
    }

    // Prepare the SQL query to insert the data into the appointments table
    $query = "INSERT INTO appointments (Type, status, date, time, patient_id, employee_id, note) 
              VALUES ('$type', '$status', '$date', '$time', '$patientId', null, '$note')";

    // Execute the query
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
