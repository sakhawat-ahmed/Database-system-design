-- ============================================
-- DATABASE SECURITY SETUP SCRIPT
-- Must be executed by MySQL root user or user with GRANT privilege
-- ============================================

-- 1. Create the database
CREATE DATABASE IF NOT EXISTS HospitalAppointmentSystem;
USE HospitalAppointmentSystem;

-- 2. Create roles
CREATE ROLE IF NOT EXISTS 'db_admin';
CREATE ROLE IF NOT EXISTS 'db_doctor';
CREATE ROLE IF NOT EXISTS 'db_patient';
CREATE ROLE IF NOT EXISTS 'db_receptionist';

-- 3. Grant privileges to roles

-- Admin Role (Full Access)
GRANT ALL PRIVILEGES ON HospitalAppointmentSystem.* TO 'db_admin';
GRANT GRANT OPTION ON HospitalAppointmentSystem.* TO 'db_admin';

-- Doctor Role
GRANT SELECT, INSERT, UPDATE ON HospitalAppointmentSystem.APPOINTMENT TO 'db_doctor';
GRANT SELECT, INSERT, UPDATE ON HospitalAppointmentSystem.MEDICAL_RECORD TO 'db_doctor';
GRANT SELECT, INSERT, UPDATE ON HospitalAppointmentSystem.PRESCRIPTION TO 'db_doctor';
GRANT SELECT, INSERT, UPDATE ON HospitalAppointmentSystem.PRESCRIPTION_MEDICINE TO 'db_doctor';
GRANT SELECT ON HospitalAppointmentSystem.PATIENT TO 'db_doctor';
GRANT SELECT ON HospitalAppointmentSystem.MEDICINE TO 'db_doctor';
GRANT SELECT, UPDATE ON HospitalAppointmentSystem.DOCTOR_SCHEDULE TO 'db_doctor';
GRANT SELECT ON HospitalAppointmentSystem.DOCTOR TO 'db_doctor';
GRANT SELECT ON HospitalAppointmentSystem.DEPARTMENT TO 'db_doctor';

-- Patient Role
GRANT SELECT, INSERT, UPDATE ON HospitalAppointmentSystem.APPOINTMENT TO 'db_patient';
GRANT SELECT ON HospitalAppointmentSystem.MEDICAL_RECORD TO 'db_patient';
GRANT SELECT ON HospitalAppointmentSystem.PRESCRIPTION TO 'db_patient';
GRANT SELECT ON HospitalAppointmentSystem.BILL TO 'db_patient';
GRANT SELECT ON HospitalAppointmentSystem.PAYMENT TO 'db_patient';
GRANT SELECT, UPDATE ON HospitalAppointmentSystem.PATIENT TO 'db_patient';

-- Receptionist Role
GRANT SELECT, INSERT, UPDATE, DELETE ON HospitalAppointmentSystem.APPOINTMENT TO 'db_receptionist';
GRANT SELECT, INSERT, UPDATE ON HospitalAppointmentSystem.PATIENT TO 'db_receptionist';
GRANT SELECT, INSERT, UPDATE ON HospitalAppointmentSystem.BILL TO 'db_receptionist';
GRANT SELECT, INSERT, UPDATE ON HospitalAppointmentSystem.PAYMENT TO 'db_receptionist';
GRANT SELECT ON HospitalAppointmentSystem.DOCTOR TO 'db_receptionist';
GRANT SELECT ON HospitalAppointmentSystem.DOCTOR_SCHEDULE TO 'db_receptionist';
GRANT SELECT ON HospitalAppointmentSystem.MEDICINE TO 'db_receptionist';

-- 4. Create users
CREATE USER IF NOT EXISTS 'sys_admin'@'localhost' IDENTIFIED BY 'StrongAdminPass123!';
CREATE USER IF NOT EXISTS 'dr_carter'@'localhost' IDENTIFIED BY 'DoctorPass456!';
CREATE USER IF NOT EXISTS 'john_smith'@'localhost' IDENTIFIED BY 'PatientPass789!';
CREATE USER IF NOT EXISTS 'reception_main'@'localhost' IDENTIFIED BY 'ReceptionPass101!';
CREATE USER IF NOT EXISTS 'report_user'@'localhost' IDENTIFIED BY 'ReportPass202!';

-- 5. Assign roles to users
GRANT 'db_admin' TO 'sys_admin'@'localhost';
GRANT 'db_doctor' TO 'dr_carter'@'localhost';
GRANT 'db_patient' TO 'john_smith'@'localhost';
GRANT 'db_receptionist' TO 'reception_main'@'localhost';

-- Report user (read-only access)
GRANT SELECT ON HospitalAppointmentSystem.* TO 'report_user'@'localhost';

-- 6. Set default roles
SET DEFAULT ROLE ALL TO 'sys_admin'@'localhost';
SET DEFAULT ROLE ALL TO 'dr_carter'@'localhost';
SET DEFAULT ROLE ALL TO 'john_smith'@'localhost';
SET DEFAULT ROLE ALL TO 'reception_main'@'localhost';
SET DEFAULT ROLE ALL TO 'report_user'@'localhost';

-- 7. Enable role activation
SET GLOBAL activate_all_roles_on_login = ON;

-- 8. Verify privileges
SELECT * FROM mysql.user WHERE user LIKE '%admin%' OR user LIKE '%dr_%' OR user LIKE '%reception%';
SELECT * FROM mysql.roles_mapping;