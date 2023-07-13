<?php
// Fetch services from the database and return as JSON response

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

// Fetch services from the database
$sql = "SELECT service_id, name FROM services";
$result = mysqli_query($conn, $sql);

// Store the results in an array
$services = [];
if (mysqli_num_rows($result) > 0) {
    while ($row = mysqli_fetch_assoc($result)) {
        $services[] = $row;
    }
}

// Close the database connection
mysqli_close($conn);

// Return the services as JSON response
header('Content-Type: application/json');
echo json_encode($services);
?>
