-- Database Creation
CREATE DATABASE HospitalAppointmentSystem;
USE HospitalAppointmentSystem;

-- 1. DEPARTMENT Table
CREATE TABLE DEPARTMENT (
    DeptID INT PRIMARY KEY AUTO_INCREMENT,
    DeptName VARCHAR(50) NOT NULL UNIQUE,
    FloorNumber INT NOT NULL,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. PATIENT Table
CREATE TABLE PATIENT (
    PatientID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    DOB DATE NOT NULL,
    BloodGroup ENUM('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'),
    Phone VARCHAR(15) UNIQUE NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Address TEXT,
    EmergencyContact VARCHAR(15),
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_patient_phone (Phone),
    INDEX idx_patient_email (Email)
);

-- 3. DOCTOR Table
CREATE TABLE DOCTOR (
    DoctorID INT PRIMARY KEY AUTO_INCREMENT,
    DeptID INT NOT NULL,
    Name VARCHAR(100) NOT NULL,
    Specialization VARCHAR(100) NOT NULL,
    Qualification VARCHAR(200),
    ConsultationFee DECIMAL(10,2) NOT NULL DEFAULT 500.00,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Phone VARCHAR(15) UNIQUE NOT NULL,
    IsActive BOOLEAN DEFAULT TRUE,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (DeptID) REFERENCES DEPARTMENT(DeptID) ON DELETE RESTRICT,
    INDEX idx_doctor_specialization (Specialization),
    INDEX idx_doctor_dept (DeptID)
);

-- 4. MEDICINE Table
CREATE TABLE MEDICINE (
    MedicineID INT PRIMARY KEY AUTO_INCREMENT,
    MedicineName VARCHAR(100) NOT NULL,
    Manufacturer VARCHAR(100),
    Price DECIMAL(10,2) NOT NULL,
    StockQuantity INT DEFAULT 0,
    ExpiryDate DATE,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_medicine_name (MedicineName),
    INDEX idx_expiry_date (ExpiryDate)
);

-- 5. APPOINTMENT Table
CREATE TABLE APPOINTMENT (
    AppointmentID INT PRIMARY KEY AUTO_INCREMENT,
    PatientID INT NOT NULL,
    DoctorID INT NOT NULL,
    AppointmentDateTime DATETIME NOT NULL,
    Status ENUM('Scheduled', 'Confirmed', 'Completed', 'Cancelled', 'No-Show') DEFAULT 'Scheduled',
    Symptoms TEXT,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (PatientID) REFERENCES PATIENT(PatientID) ON DELETE CASCADE,
    FOREIGN KEY (DoctorID) REFERENCES DOCTOR(DoctorID) ON DELETE RESTRICT,
    UNIQUE KEY unique_doctor_timeslot (DoctorID, AppointmentDateTime),
    INDEX idx_appointment_date (AppointmentDateTime),
    INDEX idx_appointment_status (Status),
    INDEX idx_patient_doctor (PatientID, DoctorID)
);

-- 6. MEDICAL_RECORD Table
CREATE TABLE MEDICAL_RECORD (
    RecordID INT PRIMARY KEY AUTO_INCREMENT,
    AppointmentID INT UNIQUE NOT NULL,
    Diagnosis TEXT,
    TreatmentNotes TEXT,
    FollowUpDate DATE,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (AppointmentID) REFERENCES APPOINTMENT(AppointmentID) ON DELETE CASCADE,
    INDEX idx_followup_date (FollowUpDate)
);

-- 7. PRESCRIPTION Table
CREATE TABLE PRESCRIPTION (
    PrescriptionID INT PRIMARY KEY AUTO_INCREMENT,
    RecordID INT NOT NULL,
    IssueDate DATE NOT NULL,
    Instructions TEXT,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (RecordID) REFERENCES MEDICAL_RECORD(RecordID) ON DELETE CASCADE,
    INDEX idx_issue_date (IssueDate)
);

-- 8. PRESCRIPTION_MEDICINE Table (M:N Relationship)
CREATE TABLE PRESCRIPTION_MEDICINE (
    PrescriptionID INT NOT NULL,
    MedicineID INT NOT NULL,
    Dosage VARCHAR(50) NOT NULL,
    Frequency VARCHAR(50) NOT NULL,
    Duration VARCHAR(50) NOT NULL,
    PRIMARY KEY (PrescriptionID, MedicineID),
    FOREIGN KEY (PrescriptionID) REFERENCES PRESCRIPTION(PrescriptionID) ON DELETE CASCADE,
    FOREIGN KEY (MedicineID) REFERENCES MEDICINE(MedicineID) ON DELETE RESTRICT,
    INDEX idx_prescription_med (PrescriptionID)
);

-- 9. BILL Table
CREATE TABLE BILL (
    BillID INT PRIMARY KEY AUTO_INCREMENT,
    AppointmentID INT UNIQUE NOT NULL,
    ConsultationFee DECIMAL(10,2) NOT NULL,
    MedicineTotal DECIMAL(10,2) DEFAULT 0.00,
    Discount DECIMAL(10,2) DEFAULT 0.00,
    Tax DECIMAL(10,2) DEFAULT 0.00,
    FinalAmount DECIMAL(10,2) GENERATED ALWAYS AS (
        ConsultationFee + MedicineTotal - Discount + Tax
    ) STORED,
    Status ENUM('Pending', 'Partial', 'Paid', 'Cancelled') DEFAULT 'Pending',
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (AppointmentID) REFERENCES APPOINTMENT(AppointmentID) ON DELETE CASCADE,
    INDEX idx_bill_status (Status),
    INDEX idx_bill_date (CreatedAt)
);

-- 10. PAYMENT Table
CREATE TABLE PAYMENT (
    PaymentID INT PRIMARY KEY AUTO_INCREMENT,
    BillID INT NOT NULL,
    PaymentDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    Amount DECIMAL(10,2) NOT NULL,
    PaymentMethod ENUM('Cash', 'Credit Card', 'Debit Card', 'Insurance', 'Online') NOT NULL,
    TransactionID VARCHAR(100) UNIQUE,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (BillID) REFERENCES BILL(BillID) ON DELETE CASCADE,
    INDEX idx_payment_date (PaymentDate),
    INDEX idx_payment_method (PaymentMethod)
);

-- 11. DOCTOR_SCHEDULE Table
CREATE TABLE DOCTOR_SCHEDULE (
    ScheduleID INT PRIMARY KEY AUTO_INCREMENT,
    DoctorID INT NOT NULL,
    DayOfWeek ENUM('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday') NOT NULL,
    StartTime TIME NOT NULL,
    EndTime TIME NOT NULL,
    MaxPatients INT DEFAULT 20,
    IsActive BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (DoctorID) REFERENCES DOCTOR(DoctorID) ON DELETE CASCADE,
    UNIQUE KEY unique_doctor_schedule (DoctorID, DayOfWeek),
    INDEX idx_doctor_schedule (DoctorID)
);

-- 12. USER_ACCOUNT Table
CREATE TABLE USER_ACCOUNT (
    UserID INT PRIMARY KEY AUTO_INCREMENT,
    Username VARCHAR(50) UNIQUE NOT NULL,
    PasswordHash VARCHAR(255) NOT NULL,
    Role ENUM('Admin', 'Doctor', 'Patient', 'Receptionist') NOT NULL,
    AssociatedID INT NOT NULL COMMENT 'ID from respective table (PatientID, DoctorID, etc.)',
    LastLogin DATETIME,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    IsActive BOOLEAN DEFAULT TRUE,
    INDEX idx_username (Username),
    INDEX idx_role (Role)
);