<!DOCTYPE html>
<html>

<head>
    <title>Appointment Form</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css">
</head>

<body>
    <h1>Appointment Form</h1>
    <form action="process.php" method="POST">
        <label for="appointment_type">Appointment Type:</label>
        <input class="form-control" type="text" name="appointment_type" id="appointment_type" required><br><br>

        <label for="appointment_date">Date:</label>
        <input class="form-control" type="date" name="appointment_date" id="appointment_date" required><br><br>

        <label for="appointment_time">Time:</label>
        <input class="form-control" type="time" name="appointment_time" id="appointment_time" required><br><br>

        <label for="services">Services:</label><br>
        <?php
        // Connect to the database
        $host = "localhost";
        $db = "denta";
        $user = "root";
        $password = "";

        $conn = new mysqli($host, $user, $password, $db);
        if ($conn->connect_error) {
            die("Connection failed: " . $conn->connect_error);
        }

        // Fetch services from the services table
        $fetchServicesSql = "SELECT * FROM services";
        $result = $conn->query($fetchServicesSql);
        if ($result->num_rows > 0) {
            while ($row = $result->fetch_assoc()) {
                $serviceId = $row['service_id'];
                $serviceName = $row['name'];
                echo "<input type='checkbox' class='checkbox' name='services[]' value='$serviceId'>$serviceName<br>";
            }
        } else {
            echo "No services found.";
        }

        // Close the database connection
        $conn->close();
        ?>

        <br>
        <input class="btn btn-outline-primary" style="border-radius: 10px; padding-inline: 30px;" type="submit"
            value="Submit">
    </form>
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

    // Retrieve appointment details with associated services, patient, and dentist
    $query = "
    SELECT a.appointment_id, a.Type, a.`status`, a.date, a.time, 
           CONCAT(p.first_name, ' ', p.middle_name, ' ', p.last_name) AS patient_name,
           CONCAT(e.first_name, ' ', e.last_name) AS dentist_name,
           GROUP_CONCAT(s.name) AS services
    FROM appointments a
    LEFT JOIN appointment_services ast ON a.appointment_id = ast.appointment_id
    LEFT JOIN services s ON FIND_IN_SET(s.service_id, ast.service_ids)
    LEFT JOIN patients p ON a.patient_id = p.patient_id
    LEFT JOIN employees e ON a.employee_id = e.employee_id
    GROUP BY a.appointment_id, a.Type, a.`status`, a.date, a.time, patient_name, dentist_name
";

    $result = mysqli_query($conn, $query);

    if ($result) {
        // Fetch and process the data
        echo '<div class="px-5 py-3">';
        echo '<table id="appointmentTable" class="table table-bordered">';
        echo '<thead><tr><th>Appointment ID</th><th>Type</th><th>Status</th><th>Date</th><th>Time</th><th>Patient Name</th><th>Dentist Name</th><th>Services</th><th>Actions</th></tr></thead>';
        echo '<tbody>';

        while ($row = mysqli_fetch_assoc($result)) {
            $appointmentId = $row['appointment_id'];
            $appointmentType = $row['Type'];
            $appointmentStatus = $row['status'];
            $appointmentDate = $row['date'];
            $appointmentTime = $row['time'];
            $patientName = $row['patient_name'];
            $dentistName = $row['dentist_name'];

            // Retrieve the services for each appointment
            $servicesQuery = "SELECT s.name FROM services s LEFT JOIN appointment_services ast ON s.service_id = ast.service_ids WHERE ast.appointment_id = $appointmentId";
            $servicesResult = mysqli_query($conn, $servicesQuery);

            // Fetch the services as an array
            $services = [];
            while ($serviceRow = mysqli_fetch_assoc($servicesResult)) {
                $services[] = $serviceRow['name'];
            }

            // Display the appointment details in HTML table rows
            echo '<tr>';
            echo '<td>' . $appointmentId . '</td>';
            echo '<td class="text-truncate" style="max-width: 10px;">' . $appointmentType . '</td>';
            echo '<td>' . $appointmentStatus . '</td>';
            echo '<td>' . $appointmentDate . '</td>';
            echo '<td>' . $appointmentTime . '</td>';
            echo '<td class="text-truncate" style="max-width: 10px;">' . $patientName . '</td>';
            echo '<td class="text-truncate" style="max-width: 10px;">' . $dentistName . '</td>';
            echo '<td class="text-truncate" style="max-width: 10px;">' . implode(', ', $services) . '</td>';
            echo '<td><button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#editModal-' . $appointmentId . '">Edit</button></td>';
            echo '</tr>';

            // Free the services result set
            mysqli_free_result($servicesResult);

            // Edit Modal for each appointment
            echo '<div class="modal fade" id="editModal-' . $appointmentId . '" tabindex="-1" aria-labelledby="editModalLabel-' . $appointmentId . '" aria-hidden="true">';
            echo '<div class="modal-dialog">';
            echo '<div class="modal-content">';
            echo '<div class="modal-header">';
            echo '<h5 class="modal-title" id="editModalLabel-' . $appointmentId . '">Edit Appointment</h5>';
            echo '<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>';
            echo '</div>';
            echo '<div class="modal-body">';
            echo '<form action="edit.php" method="POST">';
            echo '<input type="hidden" name="appointment_id" value="' . $appointmentId . '">';
            echo '<label for="edit_appointment_type">Appointment Type:</label>';
            echo '<input type="text" name="edit_appointment_type" id="edit_appointment_type" value="' . $appointmentType . '"><br><br>';
            echo '<label for="edit_appointment_date">Date:</label>';
            echo '<input type="date" name="edit_appointment_date" id="edit_appointment_date" value="' . $appointmentDate . '"><br><br>';
            echo '<label for="edit_appointment_time">Time:</label>';
            echo '<input type="time" name="edit_appointment_time" id="edit_appointment_time" value="' . $appointmentTime . '"><br><br>';

            // Fetch all services from the services table
            $allServicesQuery = "SELECT * FROM services";
            $allServicesResult = mysqli_query($conn, $allServicesQuery);

            if ($allServicesResult && mysqli_num_rows($allServicesResult) > 0) {
                while ($serviceRow = mysqli_fetch_assoc($allServicesResult)) {
                    $serviceId = $serviceRow['service_id'];
                    $serviceName = $serviceRow['name'];
                    $isChecked = in_array($serviceName, $services) ? 'checked' : '';

                    echo '<input type="checkbox" name="edit_services[]" value="' . $serviceId . '" ' . $isChecked . '>' . $serviceName . '<br>';
                }
            }

            // Free the all services result set
            mysqli_free_result($allServicesResult);

            echo '</div>';
            echo '<div class="modal-footer">';
            echo '<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>';
            echo '<button type="submit" class="btn btn-primary">Save Changes</button>';
            echo '</form>';
            echo '</div>';
            echo '</div>';
            echo '</div>';
            echo '</div>';
        }

        echo '</tbody>';
        echo '</table>';
        echo '</div>';

        // Free the result set
        mysqli_free_result($result);
    } else {
        // Handle query error
        echo "Error: " . mysqli_error($conn);
    }

    // Close the database connection
    mysqli_close($conn);
    ?>