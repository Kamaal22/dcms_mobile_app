<!DOCTYPE html>
<html>

<head>
    <title>Appointment Form</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css">
</head>

<body>
    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#appointmentModal">show</button>
    <!-- Appointment Form Modal -->
    <div class="modal fade" id="appointmentModal" tabindex="-1" aria-labelledby="appointmentModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="appointmentModalLabel">Appointment Form</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form action="process.php" method="POST">
                        <label for="appointment_type">Appointment Type:</label>
                        <input class="form-control" type="text" name="appointment_type" id="appointment_type" required><br><br>

                        <label for="appointment_date">Date:</label>
                        <input class="form-control" type="date" name="appointment_date" id="appointment_date" required><br><br>

                        <label for="appointment_time">Time:</label>
                        <input class="form-control" type="time" name="appointment_time" id="appointment_time" required><br><br>

                        <label for="patient">Patient:</label>
                        <select class="form-control" name="patient" id="patient" required>
                            <option value="">Select Patient</option>
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

                            // Fetch patients from the patients table
                            $fetchPatientsSql = "SELECT * FROM patients";
                            $result = $conn->query($fetchPatientsSql);
                            if ($result->num_rows > 0) {
                                while ($row = $result->fetch_assoc()) {
                                    $patientId = $row['patient_id'];
                                    $patientName = $row['first_name'] . ' ' . $row['middle_name'] . ' ' . $row['last_name'];
                                    echo "<option value='$patientId'>$patientName</option>";
                                }
                            } else {
                                echo "<option value=''>No patients found</option>";
                            }

                            // Close the database connection
                            $conn->close();
                            ?>
                        </select><br><br>

                        <label for="dentist">Dentist:</label>
                        <select class="form-control" name="dentist" id="dentist" required>
                            <option value="">Select Dentist</option>
                            <?php
                            // Connect to the database
                            $conn = new mysqli($host, $user, $password, $db);
                            if ($conn->connect_error) {
                                die("Connection failed: " . $conn->connect_error);
                            }

                            // Fetch dentists from the employees table with role 'dentist'
                            $fetchDentistsSql = "SELECT * FROM employees WHERE role = 'dentist'";
                            $result = $conn->query($fetchDentistsSql);
                            if ($result->num_rows > 0) {
                                while ($row = $result->fetch_assoc()) {
                                    $dentistId = $row['employee_id'];
                                    $dentistName = $row['first_name'] . ' ' . $row['middle_name'] . ' ' . $row['last_name'];
                                    echo "<option value='$dentistId'>$dentistName</option>";
                                }
                            } else {
                                echo "<option value=''>No dentists found</option>";
                            }

                            // Close the database connection
                            $conn->close();
                            ?>
                        </select><br><br>

                        <label for="services">Services:</label><br>
                        <?php
                        // Connect to the database
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
                        <button type="submit" class="btn btn-outline-primary">Submit</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <div class="container">
        <div class="card mt-5">
            <div class="card-header">
                <h1>Appointment List</h1>
            </div>
            <div class="card-body">
                <?php
                // Connect to the database
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
                ?>
                    <table id="appointmentTable" class="table table-bordered">
                        <thead>
                            <tr>
                                <th>Appointment ID</th>
                                <th>Type</th>
                                <th>Status</th>
                                <th>Date</th>
                                <th>Time</th>
                                <th>Patient Name</th>
                                <th>Dentist Name</th>
                                <th>Services</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php
                            while ($row = mysqli_fetch_assoc($result)) {
                                $appointmentId = $row['appointment_id'];
                                $appointmentType = $row['Type'];
                                $appointmentStatus = $row['status'];
                                $appointmentDate = $row['date'];
                                $appointmentTime = $row['time'];
                                $patientName = $row['patient_name'];
                                $dentistName = $row['dentist_name'];
                                $services = $row['services'];

                                echo '<tr>';
                                echo '<td>' . $appointmentId . '</td>';
                                echo '<td>' . $appointmentType . '</td>';
                                echo '<td>' . $appointmentStatus . '</td>';
                                echo '<td>' . $appointmentDate . '</td>';
                                echo '<td>' . $appointmentTime . '</td>';
                                echo '<td>' . $patientName . '</td>';
                                echo '<td>' . $dentistName . '</td>';
                                echo '<td>' . $services . '</td>';
                                echo '<td><a class="btn " data-bs-toggle="modal" data-bs-target="#editModal-' . $appointmentId . '">Edit</a></td>';
                                echo '</tr>';

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
                              ?>  
                               <input class="form-control mb-2" type="text" name="edit_appointment_type" id="edit_appointment_type" value="<?php echo $appointmentType; ?>">
                            
                                <div class='row mb-2'>
                                    <input class="form-control" style="width: 45%;" type="date" name="edit_appointment_date" id="edit_appointment_date" value="<?php echo $appointmentDate; ?>">
                                    <input class="form-control" style="width: 45%;" type="time" name="edit_appointment_time" id="edit_appointment_time" value="<?php echo $appointmentTime; ?>">
                                </div>
                            <?php
                                echo '<select class="form-select mb-2" name="edit_patient" id="edit_patient">';
                                echo '<option value="">Select Patient</option>';

                                // Fetch patients from the patients table
                                $fetchPatientsSql = "SELECT * FROM patients";
                                $patientsResult = $conn->query($fetchPatientsSql);
                                if ($patientsResult->num_rows > 0) {
                                    while ($patientRow = $patientsResult->fetch_assoc()) {
                                        $patientId = $patientRow['patient_id'];
                                        $patientFirstName = $patientRow['first_name'];
                                        $patientMiddleName = $patientRow['middle_name'];
                                        $patientLastName = $patientRow['last_name'];
                                        $patientFullName = $patientFirstName . ' ' . $patientMiddleName . ' ' . $patientLastName;
                                        $selected = $patientId == $row['patient_id'] ? 'selected' : '';
                                        echo "<option value='$patientId' $selected>$patientFullName</option>";
                                    }
                                }

                                echo '</select>';
                                echo '<select class="form-select mb-2" name="edit_dentist" id="edit_dentist">';
                                echo '<option value="">Select Dentist</option>';

                                // Fetch dentists from the employees table with role 'dentist'
                                $fetchDentistsSql = "SELECT * FROM employees WHERE role = 'dentist'";
                                $dentistsResult = $conn->query($fetchDentistsSql);
                                if ($dentistsResult->num_rows > 0) {
                                    while ($dentistRow = $dentistsResult->fetch_assoc()) {
                                        $dentistId = $dentistRow['employee_id'];
                                        $dentistFirstName = $dentistRow['first_name'];
                                        $dentistLastName = $dentistRow['last_name'];
                                        $dentistFullName = $dentistFirstName . ' ' . $dentistLastName;
                                        $selected = $dentistId == $row['employee_id'] ? 'selected' : '';
                                        echo "<option value='$dentistId' $selected>$dentistFullName</option>";
                                    }
                                }

                                echo '</select>';
                                echo '<label for="edit_services">Services:</label><br>';

                                // Fetch services from the services table
                                $fetchServicesSql = "SELECT * FROM services";
                                $servicesResult = $conn->query($fetchServicesSql);
                                if ($servicesResult->num_rows > 0) {
                                    while ($serviceRow = $servicesResult->fetch_assoc()) {
                                        $serviceId = $serviceRow['service_id'];
                                        $serviceName = $serviceRow['name'];
                                        $isChecked = in_array($serviceName, explode(',', $services)) ? 'checked' : '';
                                        echo "<input class='form-check-input' type='checkbox' name='edit_services[]' value='$serviceId' $isChecked> $serviceName<br>";
                                    }
                                } else {
                                    echo "No services found.";
                                }

                                echo '</div>';
                                echo '<div class="modal-footer">';
                                echo '<button type="button" class="btn btn-outline-danger" data-bs-dismiss="modal">Close</button>';
                                echo '<button type="submit" class="btn btn-outline-primary">Save Changes</button>';
                                echo '</form>';
                                echo '</div>';
                                echo '</div>';
                                echo '</div>';
                                echo '</div>';
                            }
                            ?>
                        </tbody>
                    </table>
                <?php
                    // Free the result set
                    mysqli_free_result($result);
                } else {
                    // Handle query error
                    echo "Error: " . mysqli_error($conn);
                }

                // Close the database connection
                mysqli_close($conn);
                ?>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</body>

</html>