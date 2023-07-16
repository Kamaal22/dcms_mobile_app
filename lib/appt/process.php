<?php
// Connect to the database
$host = "localhost";
$db = "denta";
$user = "root";
$password = "";

$conn = mysqli_connect($host, $user, $password, $db);
if (mysqli_connect_errno()) {
    die("Connection failed: " . mysqli_connect_error());
}

// Process form data
if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $appointmentType = $_POST["appointment_type"];
    $appointmentDate = $_POST["appointment_date"];
    $appointmentTime = $_POST["appointment_time"];
    $serviceIds = $_POST["services"];

    // Insert appointment into appointments table
    $insertAppointmentSql = "INSERT INTO appointments (`Type`, `date`, `time`) VALUES (?, ?, ?)";
    $stmt = mysqli_prepare($conn, $insertAppointmentSql);
    mysqli_stmt_bind_param($stmt, "sss", $appointmentType, $appointmentDate, $appointmentTime);
    mysqli_stmt_execute($stmt);
    $appointmentId = mysqli_insert_id($conn);
    mysqli_stmt_close($stmt);

    // Store service IDs as a comma-separated string
    $serviceIdsString = implode(",", $serviceIds);

    // Insert appointment services into appointment_services table
    $insertAppointmentServiceSql = "INSERT INTO appointment_services (appointment_id, service_ids) VALUES (?, ?)";
    $stmt = mysqli_prepare($conn, $insertAppointmentServiceSql);
    mysqli_stmt_bind_param($stmt, "is", $appointmentId, $serviceIdsString);
    mysqli_stmt_execute($stmt);
    mysqli_stmt_close($stmt);

    // Close the database connection
    mysqli_close($conn);

    // Redirect the user to a success page or perform any other desired actions
    header("Location: view.php?success=true");
    exit();
}
?>



