-- Table structure for `addresses`
CREATE TABLE IF NOT EXISTS `addresses` (
  `address_id` INT PRIMARY KEY AUTO_INCREMENT,
  `street` VARCHAR(255) DEFAULT NULL,
  `city` VARCHAR(255) DEFAULT NULL,
  `state` VARCHAR(255) DEFAULT NULL,
  `country` VARCHAR(255) DEFAULT NULL,
  `zip` VARCHAR(255) DEFAULT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Table structure for `employees`
CREATE TABLE IF NOT EXISTS `employees` (
  `employee_id` INT PRIMARY KEY AUTO_INCREMENT,
  `first_name` VARCHAR(255) DEFAULT NULL,
  `last_name` VARCHAR(255) DEFAULT NULL,
  `email` VARCHAR(255) DEFAULT NULL,
  `phone` VARCHAR(255) DEFAULT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Table structure for `patients`
CREATE TABLE IF NOT EXISTS `patients` (
  `patient_id` INT PRIMARY KEY AUTO_INCREMENT,
  `first_name` VARCHAR(50) DEFAULT NULL,
  `last_name` VARCHAR(50) DEFAULT NULL,
  `phone_number` VARCHAR(20) DEFAULT NULL,
  `gender` ENUM('Male', 'Female') DEFAULT NULL,
  `birth_date` DATE DEFAULT NULL,
  `address_id` INT DEFAULT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`address_id`) REFERENCES `addresses` (`address_id`)
);

-- Table structure for `appointments`
CREATE TABLE IF NOT EXISTS `appointments` (
  `appointment_id` INT PRIMARY KEY AUTO_INCREMENT,
  `Type` VARCHAR(50) DEFAULT NULL,
  `status` VARCHAR(20) DEFAULT NULL,
  `date` DATE DEFAULT NULL,
  `time` TIME DEFAULT NULL,
  `patient_id` INT DEFAULT NULL,
  `employee_id` INT DEFAULT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`patient_id`) REFERENCES `patients` (`patient_id`),
  FOREIGN KEY (`employee_id`) REFERENCES `employees` (`employee_id`)
);

-- Table structure for `appointment_services`
CREATE TABLE IF NOT EXISTS `appointment_services` (
  `appointment_id` INT,
  `service` VARCHAR(50),
  FOREIGN KEY (`appointment_id`) REFERENCES `appointments` (`appointment_id`)
);

-- Table structure for `drugs`
CREATE TABLE IF NOT EXISTS `drugs` (
  `drug_id` INT PRIMARY KEY AUTO_INCREMENT,
  `drug_name` VARCHAR(50) NOT NULL,
  `drug_description` TEXT DEFAULT NULL,
  `drug_cost` DECIMAL(10,2) NOT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Table structure for `equipment`
CREATE TABLE IF NOT EXISTS `equipment` (
  `equipment_id` INT PRIMARY KEY AUTO_INCREMENT,
  `equipment_type` VARCHAR(100) DEFAULT NULL,
  `manufacturer` VARCHAR(100) DEFAULT NULL,
  `model` VARCHAR(100) DEFAULT NULL,
  `purchase_date` DATE DEFAULT NULL,
  `warranty_information` VARCHAR(200) DEFAULT NULL,
  `maintenance_schedule` VARCHAR(200) DEFAULT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Table structure for `expenses`
CREATE TABLE IF NOT EXISTS `expenses` (
  `expense_id` INT PRIMARY KEY AUTO_INCREMENT,
  `date` DATE NOT NULL,
  `description` VARCHAR(100) NOT NULL,
  `amount` DECIMAL(10,2) NOT NULL,
  `Quantity` DOUBLE NOT NULL,
  `expense_type` ENUM('purchasing', 'selling', 'other') NOT NULL,
  `drug_id` INT DEFAULT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`drug_id`) REFERENCES `drugs` (`drug_id`)
);

-- Table structure for `suppliers`
CREATE TABLE IF NOT EXISTS `suppliers` (
  `supplier_id` INT PRIMARY KEY AUTO_INCREMENT,
  `supplier_name` VARCHAR(100) DEFAULT NULL,
  `email` VARCHAR(100) DEFAULT NULL,
  `phone_number` VARCHAR(20) DEFAULT NULL,
  `address_id` INT DEFAULT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`address_id`) REFERENCES `addresses` (`address_id`)
);

-- Table structure for `inventory`
CREATE TABLE IF NOT EXISTS `inventory` (
  `inventory_id` INT PRIMARY KEY AUTO_INCREMENT,
  `item_name` VARCHAR(100) DEFAULT NULL,
  `description` TEXT DEFAULT NULL,
  `unit_cost` DECIMAL(10,2) DEFAULT NULL,
  `quantity` INT DEFAULT NULL,
  `supplier_id` INT DEFAULT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`supplier_id`)
);

-- Table structure for `invoices`
CREATE TABLE IF NOT EXISTS `invoices` (
  `invoice_id` INT PRIMARY KEY AUTO_INCREMENT,
  `patient_id` INT DEFAULT NULL,
  `invoice_date` DATE DEFAULT NULL,
  `total_cost` DECIMAL(10,2) DEFAULT NULL,
  `paid` TINYINT(1) DEFAULT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`patient_id`) REFERENCES `patients` (`patient_id`)
);

-- Table structure for `medications`
CREATE TABLE IF NOT EXISTS `medications` (
  `medication_id` INT PRIMARY KEY AUTO_INCREMENT,
  `medication_name` VARCHAR(50) DEFAULT NULL,
  `description` TEXT DEFAULT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Table structure for `payments`
CREATE TABLE IF NOT EXISTS `payments` (
  `payment_id` INT PRIMARY KEY AUTO_INCREMENT,
  `patient_id` INT DEFAULT NULL,
  `amount` DECIMAL(10,2) DEFAULT NULL,
  `amount_paid` DECIMAL(10,2) DEFAULT NULL,
  `amount_due` DECIMAL(10,2) DEFAULT NULL,
  `description` VARCHAR(100) DEFAULT NULL,
  `date_paid` DATE DEFAULT NULL,
  `payment_method` VARCHAR(50) DEFAULT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`patient_id`) REFERENCES `patients` (`patient_id`)
);

-- Table structure for `prescriptions`
CREATE TABLE IF NOT EXISTS `prescriptions` (
  `prescription_id` INT PRIMARY KEY AUTO_INCREMENT,
  `patient_id` INT DEFAULT NULL,
  `medication_id` INT DEFAULT NULL,
  `dosage` VARCHAR(50) DEFAULT NULL,
  `instructions` TEXT DEFAULT NULL,
  `date_prescribed` DATE DEFAULT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`patient_id`) REFERENCES `patients` (`patient_id`),
  FOREIGN KEY (`medication_id`) REFERENCES `medications` (`medication_id`)
);

-- Table structure for `services`
CREATE TABLE IF NOT EXISTS `services` (
  `service_id` INT PRIMARY KEY AUTO_INCREMENT,
  `name` VARCHAR(50) DEFAULT NULL,
  `description` TEXT DEFAULT NULL,
  `cost` DECIMAL(10,2) DEFAULT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Table structure for `treatment_plans`
CREATE TABLE IF NOT EXISTS `treatment_plans` (
  `treatment_plan_id` INT PRIMARY KEY AUTO_INCREMENT,
  `patient_id` INT DEFAULT NULL,
  `start_date` DATE DEFAULT NULL,
  `end_date` DATE DEFAULT NULL,
  `total_cost` DECIMAL(10,2) DEFAULT NULL,
  `status` VARCHAR(50) DEFAULT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`patient_id`) REFERENCES `patients` (`patient_id`)
);

-- Table structure for `users`
CREATE TABLE IF NOT EXISTS `users` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `email` VARCHAR(255) DEFAULT NULL,
  `password` VARCHAR(255) DEFAULT NULL,
  `auth_token` VARCHAR(255) DEFAULT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);



-- Insertion for addresses
INSERT INTO addresses (street, city, state, country, zip)
VALUES ('123 Main Street', 'New York', 'New York', 'USA', '10001');

-- Insertion for employees
INSERT INTO employees (first_name, last_name, email, phone)
VALUES ('John', 'Doe', 'johndoe@example.com', '123-456-7890');

-- Insertion for patients
INSERT INTO patients (first_name, last_name, phone_number, gender, birth_date, address_id)
VALUES ('Jane', 'Smith', '555-123-4567', 'Female', '1990-05-15', 1);

-- Insertion for services
INSERT INTO services (name, description, cost)
VALUES ('Dental Cleaning', 'Routine cleaning and examination of teeth', 75.00);

-- Insertion for appointments
INSERT INTO appointments (Type, status, date, time, patient_id, employee_id)
VALUES ('Checkup', 'Confirmed', '2023-07-10', '10:00:00', 1, 1);

-- Insertion for appointment_services
INSERT INTO appointment_services (appointment_id, service)
VALUES (1, 'Dental Cleaning');

-- Insertion for drugs
INSERT INTO drugs (drug_name, drug_description, drug_cost)
VALUES ('Aspirin', 'Pain reliever', 10.99);

-- Insertion for equipment
INSERT INTO equipment (equipment_type, manufacturer, model, purchase_date, warranty_information, maintenance_schedule)
VALUES ('MRI Machine', 'ABC Corporation', 'MRI-2000', '2023-06-30', '1 year', 'Monthly');

-- Insertion for expenses
INSERT INTO expenses (date, description, amount, Quantity, expense_type, drug_id)
VALUES ('2023-07-01', 'Office supplies', 50.00, 5, 'other', NULL);

-- Insertion for suppliers
INSERT INTO suppliers (supplier_name, email, phone_number, address_id)
VALUES ('ABC Supplier', 'abcsupplier@example.com', '555-987-6543', 1);

-- Insertion for inventory
INSERT INTO inventory (item_name, description, unit_cost, quantity, supplier_id)
VALUES ('Gloves', 'Disposable gloves', 1.99, 100, 1);

-- Insertion for invoices
INSERT INTO invoices (patient_id, invoice_date, total_cost, paid)
VALUES (1, '2023-07-05', 100.00, 1);

-- Insertion for medications
INSERT INTO medications (medication_name, description)
VALUES ('Antibiotic', 'For bacterial infections');

-- Insertion for payments
INSERT INTO payments (patient_id, amount, amount_paid, amount_due, description, date_paid, payment_method)
VALUES (1, 50.00, 50.00, 0.00, 'Payment for appointment', '2023-07-05', 'Credit Card');

-- Insertion for prescriptions
INSERT INTO prescriptions (patient_id, medication_id, dosage, instructions, date_prescribed)
VALUES (1, 1, '500mg', 'Take twice a day', '2023-07-05');

-- Insertion for treatment_plans
INSERT INTO treatment_plans (patient_id, start_date, end_date, total_cost, status)
VALUES (1, '2023-07-01', '2023-07-31', 500.00, 'In progress');

-- Insertion for users
INSERT INTO users (email, password, auth_token)
VALUES ('user@example.com', 'password123', 'abcdef123456');

-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////// APPOINTMENT REALTED VIEWS ////////////////////////////////////////////////////////////////////////////////////


CREATE VIEW `appointment_details` AS
SELECT a.appointment_id, a.date, a.time, p.first_name AS patient_first_name, p.last_name AS patient_last_name, e.first_name AS employee_first_name, e.last_name AS employee_last_name
FROM appointments a
JOIN patients p ON a.patient_id = p.patient_id
JOIN employees e ON a.employee_id = e.employee_id;


CREATE VIEW `upcoming_appointments` AS
SELECT a.appointment_id, a.date, a.time, p.first_name AS patient_first_name, p.last_name AS patient_last_name, e.first_name AS employee_first_name, e.last_name AS employee_last_name
FROM appointments a
JOIN patients p ON a.patient_id = p.patient_id
JOIN employees e ON a.employee_id = e.employee_id
WHERE a.date >= CURDATE();


CREATE VIEW `past_appointments` AS
SELECT a.appointment_id, a.date, a.time, p.first_name AS patient_first_name, p.last_name AS patient_last_name, e.first_name AS employee_first_name, e.last_name AS employee_last_name
FROM appointments a
JOIN patients p ON a.patient_id = p.patient_id
JOIN employees e ON a.employee_id = e.employee_id
WHERE a.date < CURDATE();



-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- /////////////////////////////////////////// MONEY RELATED VIEWS ///////////////////////////////////////////////////////////////////////////////////////

CREATE VIEW `total_revenue` AS
SELECT SUM(total_cost) AS revenue
FROM invoices;


CREATE VIEW `total_expenses` AS
SELECT SUM(amount) AS total_expenses
FROM expenses;


CREATE VIEW `net_profit` AS
SELECT (SELECT COALESCE(SUM(total_cost), 0) FROM invoices) - (SELECT COALESCE(SUM(amount), 0) FROM expenses) AS profit;


CREATE VIEW `outstanding_payments` AS
SELECT patient_id, SUM(amount_due) AS total_outstanding
FROM payments
GROUP BY patient_id;


CREATE VIEW `top_paying_patients` AS
SELECT p.patient_id, p.first_name, p.last_name, SUM(i.total_cost) AS total_paid
FROM patients p
JOIN invoices i ON p.patient_id = i.patient_id
GROUP BY p.patient_id
ORDER BY total_paid DESC;



-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- /////////////////////////////////////////// EXPENSE RELATED VIEWS ///////////////////////////////////////////////////////////////////////////////////////

CREATE VIEW `expenses_by_type` AS
SELECT expense_type, SUM(amount) AS total_expenses
FROM expenses
GROUP BY expense_type;


CREATE VIEW `monthly_expenses` AS
SELECT MONTH(date) AS month, YEAR(date) AS year, SUM(amount) AS total_expenses
FROM expenses
GROUP BY month, year;


CREATE VIEW `top_expense_categories` AS
SELECT expense_type, SUM(amount) AS total_expenses
FROM expenses
GROUP BY expense_type
ORDER BY total_expenses DESC;


CREATE VIEW `expenses_by_supplier` AS
SELECT s.supplier_id, s.supplier_name, SUM(e.amount) AS total_expenses
FROM suppliers s
JOIN expenses e ON s.supplier_id = e.supplier_id
GROUP BY s.supplier_id, s.supplier_name;


CREATE VIEW `monthly_average_expenses` AS
SELECT MONTH(date) AS month, YEAR(date) AS year, AVG(amount) AS average_expenses
FROM expenses
GROUP BY month, year;


-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- /////////////////////////////////////////// PAYMENT RELATED VIEWS ///////////////////////////////////////////////////////////////////////////////////////


CREATE VIEW `total_payments_received` AS
SELECT SUM(amount_paid) AS total_payments
FROM payments;


CREATE VIEW `outstanding_payments` AS
SELECT patient_id, SUM(amount_due) AS total_outstanding
FROM payments
GROUP BY patient_id;


CREATE VIEW `payment_history` AS
SELECT patient_id, amount, amount_paid, amount_due, date_paid
FROM payments
WHERE patient_id = <patient_id>;


CREATE VIEW `average_payment_per_patient` AS
SELECT patient_id, AVG(amount_paid) AS average_payment
FROM payments
GROUP BY patient_id;


CREATE VIEW `top_paying_patients` AS
SELECT patient_id, SUM(amount_paid) AS total_paid
FROM payments
GROUP BY patient_id
ORDER BY total_paid DESC;


-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- /////////////////////////////////////////// OTHER VIEWS ///////////////////////////////////////////////////////////////////////////////////////


CREATE VIEW `appointments_per_day` AS
SELECT date, COUNT(*) AS appointment_count
FROM appointments
GROUP BY date;


CREATE VIEW `patients_per_gender` AS
SELECT gender, COUNT(*) AS patient_count
FROM patients
GROUP BY gender;


CREATE VIEW `medications_per_patient` AS
SELECT patient_id, COUNT(*) AS medication_count
FROM prescriptions
GROUP BY patient_id;


CREATE VIEW `appointments_per_employee` AS
SELECT employee_id, COUNT(*) AS appointment_count
FROM appointments
GROUP BY employee_id;


CREATE VIEW `total_drug_cost` AS
SELECT SUM(drug_cost) AS total_cost
FROM drugs;



CREATE VIEW `average_drug_cost_by_category` AS
SELECT d.category, AVG(d.drug_cost) AS average_cost
FROM drugs d
GROUP BY d.category;


CREATE VIEW `appointments_by_type` AS
SELECT Type, COUNT(*) AS appointment_count
FROM appointments
GROUP BY Type;


CREATE VIEW `appointments_by_status` AS
SELECT status, COUNT(*) AS appointment_count
FROM appointments
GROUP BY status;


CREATE VIEW `monthly_revenue` AS
SELECT MONTH(invoice_date) AS month, YEAR(invoice_date) AS year, SUM(total_cost) AS total_revenue
FROM invoices
GROUP BY month, year;


CREATE VIEW `expenses_by_type` AS
SELECT expense_type, SUM(amount) AS total_cost
FROM expenses
GROUP BY expense_type;


CREATE VIEW `patients_per_age_group` AS
SELECT CASE
    WHEN YEAR(CURDATE()) - YEAR(birth_date) >= 65 THEN '65+'
    WHEN YEAR(CURDATE()) - YEAR(birth_date) BETWEEN 45 AND 64 THEN '45-64'
    WHEN YEAR(CURDATE()) - YEAR(birth_date) BETWEEN 25 AND 44 THEN '25-44'
    WHEN YEAR(CURDATE()) - YEAR(birth_date) BETWEEN 18 AND 24 THEN '18-24'
    ELSE 'Under 18'
  END AS age_group,
  COUNT(*) AS patient_count
FROM patients
GROUP BY age_group;


CREATE VIEW `appointments_per_month` AS
SELECT MONTH(date) AS month, YEAR(date) AS year, COUNT(*) AS appointment_count
FROM appointments
GROUP BY month, year;



CREATE VIEW `prescriptions_per_medication` AS
SELECT m.medication_name, COUNT(*) AS prescription_count
FROM medications m
JOIN prescriptions p ON m.medication_id = p.medication_id
GROUP BY m.medication_name;


CREATE VIEW `employees_per_department` AS
SELECT department, COUNT(*) AS employee_count
FROM employees
GROUP BY department;


CREATE VIEW `revenue_per_patient` AS
SELECT i.patient_id, SUM(i.total_cost) AS total_revenue
FROM invoices i
GROUP BY i.patient_id;