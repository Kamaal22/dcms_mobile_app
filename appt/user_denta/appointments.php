<!DOCTYPE html>
<html>
<head>
    <title>Appointments</title>
    <style>
        @import url('https://fonts.cdnfonts.com/css/nunito');
        body {
            font-family: nunito;
        }
        table {
            border-collapse: collapse;
            width: 100%;
        }

        th, td {
            border: 1px solid black;
            padding: 8px;
        }

        th {
            background-color: #f2f2f2;
        }
    </style>
</head>
<body>
    <h1>Appointments</h1>
    <h2>Pending Appointments</h2>
    <table>
        <tr>
            <th>Appointment ID</th>
            <th>Type</th>
            <th>Status</th>
            <th>Date</th>
            <th>Time</th>
            <th>Patient</th>
            <th>Employee</th>
            <th>Action</th>
        </tr>
        <?php
        // Connect to the database
        $conn = mysqli_connect("localhost", "root", "", "denta");

        // Check connection
        if (mysqli_connect_errno()) {
            echo "Failed to connect to MySQL: " . mysqli_connect_error();
        }

        // Fetch pending appointments with patient and employee names
        $query = "SELECT a.appointment_id, a.Type, a.status, a.date, a.time, CONCAT(p.first_name, ' ', p.last_name) AS patient_name, CONCAT(e.first_name, ' ', e.last_name) AS employee_name
                  FROM appointments a
                  INNER JOIN patients p ON a.patient_id = p.patient_id
                  INNER JOIN employees e ON a.employee_id = e.employee_id
                  WHERE a.status != 'approved'";
        $result = mysqli_query($conn, $query);

        // Loop through pending appointments
        while ($row = mysqli_fetch_assoc($result)) {
            echo "<tr>";
            echo "<td>".$row['appointment_id']."</td>";
            echo "<td>".$row['Type']."</td>";
            echo "<td>".$row['status']."</td>";
            echo "<td>".$row['date']."</td>";
            echo "<td>".$row['time']."</td>";
            echo "<td>".$row['patient_name']."</td>";
            echo "<td>".$row['employee_name']."</td>";
            echo "<td><a href='approve.php?appointment_id=".$row['appointment_id']."'>Approve</a></td>";
            echo "</tr>";
        }
        ?>
    </table>

    <h2>Approved Appointments</h2>
    <table>
        <tr>
            <th>Appointment ID</th>
            <th>Type</th>
            <th>Status</th>
            <th>Date</th>
            <th>Time</th>
            <th>Patient</th>
            <th>Employee</th>
        </tr>
        <?php
        // Fetch approved appointments with patient and employee names
        $query = "SELECT a.appointment_id, a.Type, a.status, a.date, a.time, CONCAT(p.first_name, ' ', p.last_name) AS patient_name, CONCAT(e.first_name, ' ', e.last_name) AS employee_name
                  FROM appointments a
                  INNER JOIN patients p ON a.patient_id = p.patient_id
                  INNER JOIN employees e ON a.employee_id = e.employee_id
                  WHERE a.status = 'approved'";
        $result = mysqli_query($conn, $query);

        // Loop through approved appointments
        while ($row = mysqli_fetch_assoc($result)) {
            echo "<tr>";
            echo "<td>".$row['appointment_id']."</td>";
            echo "<td>".$row['Type']."</td>";
            echo "<td style='color: green;'>".$row['status']."</td>";
            echo "<td>".$row['date']."</td>";
            echo "<td>".$row['time']."</td>";
            echo "<td>".$row['patient_name']."</td>";
            echo "<td>".$row['employee_name']."</td>";
            echo "</tr>";
        }

        // Close the connection
        mysqli_close($conn);
        ?>
    </table>
</body>
</html>
