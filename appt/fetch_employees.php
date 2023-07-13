<?php
// Fetch employees from the database and return as JSON response

// Database configuration
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "denta";

// Create a connection to the database
$conn = mysqli_connect($servername, $username, $password, $dbname);

// Check if the connection was successful
if (!$conn) {
    die("Connection failed: " . mysqli_connect_error());
}

// Fetch employees from the database
$sql = "SELECT employee_id, CONCAT(first_name, ' ', last_name) AS full_name FROM employees";
$result = mysqli_query($conn, $sql);

// Store the results in an array
$employees = [];
if (mysqli_num_rows($result) > 0) {
    while ($row = mysqli_fetch_assoc($result)) {
        $employees[] = $row;
    }
}

// Close the database connection
mysqli_close($conn);

// Return the employees as JSON response
header('Content-Type: application/json');
echo json_encode($employees);
?>
