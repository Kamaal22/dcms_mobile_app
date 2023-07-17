<?php
// Check if the form is submitted
if ($_SERVER["REQUEST_METHOD"] === "POST") {
    // Get the appointment ID
    $appointmentId = $_POST['appointment_id'];

    // Get the updated appointment details
    $updatedType = $_POST['edit_appointment_type'];
    $updatedDate = $_POST['edit_appointment_date'];
    $updatedTime = $_POST['edit_appointment_time'];
    $updatedServices = implode(',', $_POST['edit_services']);

    // Connect to the database
    $host = "localhost";
    $db = "denta";
    $user = "root";
    $password = "";

    $conn = new mysqli($host, $user, $password, $db);
    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }

    // Check if the appointment already exists in the appointment_services table
    $checkAppointmentSql = "SELECT * FROM appointment_services WHERE appointment_id = $appointmentId";
    $checkResult = $conn->query($checkAppointmentSql);

    if ($checkResult && $checkResult->num_rows > 0) {
        // Update the appointment details in the appointments table
        $updateAppointmentSql = "UPDATE appointments SET Type = '$updatedType', date = '$updatedDate', time = '$updatedTime' WHERE appointment_id = $appointmentId";
        if ($conn->query($updateAppointmentSql) === true) {
            // Update the associated services in the appointment_services table
            $updateServicesSql = "UPDATE appointment_services SET service_ids = '$updatedServices' WHERE appointment_id = $appointmentId";
            if ($conn->query($updateServicesSql) === true) {
                echo "Appointment updated successfully.";
            } else {
                echo "Error updating services: " . $conn->error;
            }
        } else {
            echo "Error updating appointment: " . $conn->error;
        }
    } else {
        // Insert a new record in the appointment_services table
        $insertAppointmentSql = "INSERT INTO appointment_services (appointment_id, service_ids) VALUES ($appointmentId, '$updatedServices')";
        if ($conn->query($insertAppointmentSql) === true) {
            echo "Appointment inserted successfully.";
        } else {
            echo "Error inserting appointment: " . $conn->error;
        }
    }

    // Debugging information
    echo "Appointment ID: " . $appointmentId . "<br>";
    echo "Updated Type: " . $updatedType . "<br>";
    echo "Updated Date: " . $updatedDate . "<br>";
    echo "Updated Time: " . $updatedTime . "<br>";
    echo "Updated Services: " . $updatedServices . "<br>";

    // Close the database connection
    $conn->close();
}
?>
