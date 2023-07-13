<?php
// Connect to the database
$conn = mysqli_connect("localhost", "root", "", "denta");

// Check connection
if (mysqli_connect_errno()) {
    echo "Failed to connect to MySQL: " . mysqli_connect_error();
}

// Check if the appointment ID is provided in the URL
if (isset($_GET['appointment_id'])) {
    $appointmentId = $_GET['appointment_id'];

    // Check if the employee exists
    $employeeId = 3; // Replace with the actual employee ID
    $checkEmployeeQuery = "SELECT * FROM employees WHERE employee_id = $employeeId";
    $result = mysqli_query($conn, $checkEmployeeQuery);

    if (mysqli_num_rows($result) > 0) {
        // Update the appointment status to 'approved' and assign an employee (dentist) and services
        $query = "UPDATE appointments SET status = 'approved', employee_id = $employeeId, Type = 'routine checkup' WHERE appointment_id = $appointmentId";

        if (mysqli_query($conn, $query)) {
            echo "Appointment approved successfully.";
            header("Location: appointments.php");
        } else {
            echo "Error updating appointment: " . mysqli_error($conn);
        }
    } else {
        echo "Invalid employee ID.";
    }
} else {
    echo "Invalid appointment ID.";
}

// Close the connection
mysqli_close($conn);
?>
