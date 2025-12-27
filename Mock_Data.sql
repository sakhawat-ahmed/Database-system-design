-- Insert Departments
INSERT INTO DEPARTMENT (DeptName, FloorNumber) VALUES
('Cardiology', 1),
('Neurology', 2),
('Orthopedics', 1),
('Pediatrics', 3),
('Dermatology', 2),
('Oncology', 4),
('Gynecology', 3),
('Emergency', 1);

-- Insert Patients (20 records)
INSERT INTO PATIENT (Name, DOB, BloodGroup, Phone, Email, Address, EmergencyContact) VALUES
('John Smith', '1985-03-15', 'A+', '555-0101', 'john.smith@email.com', '123 Main St, Cityville', '555-0202'),
('Sarah Johnson', '1990-07-22', 'O-', '555-0102', 'sarah.j@email.com', '456 Oak Ave, Townsville', '555-0203'),
('Michael Brown', '1978-11-30', 'B+', '555-0103', 'm.brown@email.com', '789 Pine Rd, Villageton', '555-0204'),
('Emily Davis', '1995-02-14', 'AB+', '555-0104', 'emily.davis@email.com', '321 Elm St, Hamletville', '555-0205'),
('Robert Wilson', '1982-09-08', 'A-', '555-0105', 'robert.w@email.com', '654 Maple Dr, Boroughburg', '555-0206'),
('Jennifer Lee', '1988-12-25', 'O+', '555-0106', 'j.lee@email.com', '987 Birch Ln, Countyville', '555-0207'),
('David Miller', '1975-06-18', 'B-', '555-0107', 'd.miller@email.com', '147 Cedar Blvd, Township', '555-0208'),
('Lisa Taylor', '1992-04-03', 'A+', '555-0108', 'lisa.t@email.com', '258 Spruce Way, Cityburg', '555-0209'),
('James Anderson', '1980-08-11', 'AB-', '555-0109', 'j.anderson@email.com', '369 Willow Cir, Townville', '555-0210'),
('Maria Garcia', '1987-01-29', 'O-', '555-0110', 'm.garcia@email.com', '741 Aspen Ct, Villageburg', '555-0211'),
('William Martinez', '1972-05-17', 'B+', '555-0111', 'w.martinez@email.com', '852 Poplar Pl, Hamletsville', '555-0212'),
('Patricia Robinson', '1998-10-22', 'A+', '555-0112', 'p.robinson@email.com', '963 Redwood Rd, Boroughville', '555-0213'),
('Richard Clark', '1968-03-07', 'O+', '555-0113', 'r.clark@email.com', '159 Sequoia St, Countyburg', '555-0214'),
('Susan Rodriguez', '1983-11-14', 'AB+', '555-0114', 's.rodriguez@email.com', '357 Magnolia Ave, Cityton', '555-0215'),
('Joseph Lewis', '1979-07-01', 'B-', '555-0115', 'j.lewis@email.com', '753 Dogwood Dr, Townberg', '555-0216'),
('Karen Walker', '1991-09-19', 'A-', '555-0116', 'k.walker@email.com', '951 Sycamore Ln, Villageville', '555-0217'),
('Thomas Hall', '1965-02-28', 'O-', '555-0117', 't.hall@email.com', '862 Hickory Blvd, Hamletberg', '555-0218'),
('Nancy Allen', '1986-06-12', 'A+', '555-0118', 'n.allen@email.com', '264 Chestnut Way, Boroughton', '555-0219'),
('Charles Young', '1974-04-05', 'B+', '555-0119', 'c.young@email.com', '468 Walnut Cir, Cityville', '555-0220'),
('Jessica King', '1993-08-27', 'O+', '555-0120', 'j.king@email.com', '680 Fir Pl, Townsberg', '555-0221');

-- Insert Doctors (10 records)
INSERT INTO DOCTOR (DeptID, Name, Specialization, Qualification, ConsultationFee, Email, Phone) VALUES
(1, 'Dr. James Carter', 'Cardiologist', 'MD, FACC', 1500.00, 'j.carter@hospital.com', '555-0301'),
(1, 'Dr. Lisa Wong', 'Cardiologist', 'MD, PhD Cardiology', 1200.00, 'l.wong@hospital.com', '555-0302'),
(2, 'Dr. Robert Chen', 'Neurologist', 'MD, Neurology Board Certified', 1300.00, 'r.chen@hospital.com', '555-0303'),
(3, 'Dr. Maria Rodriguez', 'Orthopedic Surgeon', 'MD, Orthopedic Surgery', 1400.00, 'm.rodriguez@hospital.com', '555-0304'),
(4, 'Dr. Sarah Johnson', 'Pediatrician', 'MD, Pediatrics', 800.00, 's.johnson@hospital.com', '555-0305'),
(5, 'Dr. David Kim', 'Dermatologist', 'MD, Dermatology', 900.00, 'd.kim@hospital.com', '555-0306'),
(6, 'Dr. Amanda Lee', 'Oncologist', 'MD, Oncology', 1600.00, 'a.lee@hospital.com', '555-0307'),
(7, 'Dr. Michael Brown', 'Gynecologist', 'MD, OB/GYN', 1100.00, 'm.brown@hospital.com', '555-0308'),
(8, 'Dr. Jennifer Wilson', 'Emergency Physician', 'MD, Emergency Medicine', 1000.00, 'j.wilson@hospital.com', '555-0309'),
(2, 'Dr. Kevin Patel', 'Neurosurgeon', 'MD, Neurosurgery', 2000.00, 'k.patel@hospital.com', '555-0310');

-- Insert Medicines (15 records)
INSERT INTO MEDICINE (MedicineName, Manufacturer, Price, StockQuantity, ExpiryDate) VALUES
('Paracetamol', 'PharmaCorp', 5.50, 1000, '2025-12-31'),
('Ibuprofen', 'MediHealth', 8.75, 800, '2025-10-15'),
('Amoxicillin', 'BioPharm', 12.30, 500, '2024-11-30'),
('Lisinopril', 'CardioMed', 15.80, 300, '2026-03-31'),
('Atorvastatin', 'CholestoFix', 20.45, 400, '2025-09-30'),
('Metformin', 'DiabetoCare', 9.90, 600, '2025-08-31'),
('Levothyroxine', 'ThyroHealth', 7.25, 350, '2025-11-30'),
('Albuterol', 'RespiraCorp', 18.50, 250, '2025-06-30'),
('Omeprazole', 'GastroMed', 10.20, 450, '2025-07-31'),
('Cetirizine', 'AllerFree', 6.80, 700, '2025-05-31'),
('Fluoxetine', 'NeuroPharm', 14.90, 200, '2026-01-31'),
('Warfarin', 'HemoCare', 11.30, 150, '2025-04-30'),
('Insulin Glargine', 'DiabetoMed', 25.00, 100, '2025-03-31'),
('Losartan', 'BPControl', 13.75, 320, '2025-10-31'),
('Montelukast', 'AsthmaCare', 16.40, 280, '2025-09-30');

-- Insert Appointments (20 records)
INSERT INTO APPOINTMENT (PatientID, DoctorID, AppointmentDateTime, Status, Symptoms) VALUES
(1, 1, '2024-03-15 09:00:00', 'Completed', 'Chest pain and shortness of breath'),
(2, 5, '2024-03-15 10:30:00', 'Completed', 'Child fever and cough'),
(3, 3, '2024-03-16 11:00:00', 'Completed', 'Headaches and dizziness'),
(4, 6, '2024-03-16 14:00:00', 'Completed', 'Skin rash and itching'),
(5, 4, '2024-03-17 09:30:00', 'Completed', 'Knee pain after injury'),
(6, 2, '2024-03-17 15:00:00', 'Completed', 'High blood pressure'),
(7, 7, '2024-03-18 10:00:00', 'Completed', 'Routine cancer screening'),
(8, 8, '2024-03-18 11:30:00', 'Completed', 'Pregnancy checkup'),
(9, 9, '2024-03-19 13:00:00', 'Completed', 'Minor injury from accident'),
(10, 10, '2024-03-19 16:00:00', 'Completed', 'Back pain and numbness'),
(11, 1, '2024-03-20 09:00:00', 'Scheduled', 'Heart palpitations'),
(12, 5, '2024-03-20 10:30:00', 'Confirmed', 'Child vaccination'),
(13, 3, '2024-03-21 11:00:00', 'Scheduled', 'Migraine symptoms'),
(14, 6, '2024-03-21 14:00:00', 'Confirmed', 'Acne treatment'),
(15, 4, '2024-03-22 09:30:00', 'Scheduled', 'Fractured wrist'),
(16, 2, '2024-03-22 15:00:00', 'Confirmed', 'Cholesterol check'),
(17, 7, '2024-03-23 10:00:00', 'Scheduled', 'Follow-up chemotherapy'),
(18, 8, '2024-03-23 11:30:00', 'Confirmed', 'Annual gynecological exam'),
(19, 9, '2024-03-24 13:00:00', 'Scheduled', 'Sprained ankle'),
(20, 10, '2024-03-24 16:00:00', 'Confirmed', 'Spinal consultation');

-- Insert Medical Records
INSERT INTO MEDICAL_RECORD (AppointmentID, Diagnosis, TreatmentNotes, FollowUpDate) VALUES
(1, 'Hypertension with angina symptoms', 'Prescribed medication and lifestyle changes. Recommended stress test.', '2024-04-15'),
(2, 'Viral fever with upper respiratory infection', 'Antipyretics and rest prescribed. Antibiotics if no improvement in 48 hours.', '2024-03-22'),
(3, 'Migraine with aura', 'Prescribed preventive medication and asked to maintain headache diary.', '2024-04-16'),
(4, 'Contact dermatitis', 'Topical steroids prescribed. Avoid suspected allergens.', '2024-03-30'),
(5, 'Meniscus tear', 'Physical therapy recommended. Surgery may be needed if no improvement.', '2024-04-17'),
(6, 'Stage 1 hypertension', 'Started on antihypertensive medication. Salt restriction advised.', '2024-04-18'),
(7, 'Routine screening - No abnormalities detected', 'Annual follow-up recommended.', '2025-03-18'),
(8, 'Normal pregnancy, 20 weeks', 'All parameters normal. Prescribed prenatal vitamins.', '2024-04-01'),
(9, 'Minor laceration and contusion', 'Wound cleaned and dressed. Tetanus shot administered.', '2024-03-26'),
(10, 'Lumbar disc herniation', 'Physical therapy and pain management started. MRI ordered.', '2024-04-19');

-- Insert Prescriptions
INSERT INTO PRESCRIPTION (RecordID, IssueDate, Instructions) VALUES
(1, '2024-03-15', 'Take medication after meals. Monitor blood pressure daily.'),
(2, '2024-03-15', 'Complete full course of antibiotics. Maintain hydration.'),
(3, '2024-03-16', 'Take as directed. Avoid trigger factors like bright lights.'),
(4, '2024-03-16', 'Apply thin layer twice daily. Do not use on broken skin.'),
(5, '2024-03-17', 'Take with food. Use ice pack for swelling.'),
(6, '2024-03-17', 'Take every morning. Regular BP monitoring essential.'),
(7, '2024-03-18', 'Continue regular checkups. Maintain healthy lifestyle.'),
(8, '2024-03-18', 'Take daily with breakfast. Attend all prenatal appointments.'),
(9, '2024-03-19', 'Keep wound dry for 48 hours. Change dressing daily.'),
(10, '2024-03-19', 'Take as needed for pain. Attend all physical therapy sessions.');

-- Insert Prescription Medicines
INSERT INTO PRESCRIPTION_MEDICINE (PrescriptionID, MedicineID, Dosage, Frequency, Duration) VALUES
(1, 4, '10mg', 'Once daily', '30 days'),
(1, 5, '20mg', 'Once daily at bedtime', '30 days'),
(2, 3, '500mg', 'Three times daily', '7 days'),
(2, 1, '500mg', 'Every 6 hours as needed', '3 days'),
(3, 11, '20mg', 'Once daily', '90 days'),
(4, 10, '10mg', 'Once daily', '14 days'),
(5, 2, '400mg', 'Every 8 hours as needed', '7 days'),
(6, 4, '5mg', 'Once daily', '30 days'),
(7, 13, '10 units', 'Once daily at bedtime', 'Continuous'),
(8, 9, '20mg', 'Once daily', '30 days'),
(9, 1, '500mg', 'Every 6 hours as needed', '5 days'),
(10, 2, '400mg', 'Every 8 hours', '10 days');

-- Insert Bills
INSERT INTO BILL (AppointmentID, ConsultationFee, MedicineTotal, Discount, Tax, Status) VALUES
(1, 1500.00, 35.25, 100.00, 86.31, 'Paid'),
(2, 800.00, 19.80, 50.00, 38.49, 'Paid'),
(3, 1300.00, 14.90, 0.00, 65.75, 'Paid'),
(4, 900.00, 6.80, 0.00, 45.34, 'Paid'),
(5, 1400.00, 8.75, 200.00, 60.44, 'Partial'),
(6, 1200.00, 15.80, 100.00, 55.79, 'Pending'),
(7, 1600.00, 25.00, 300.00, 66.25, 'Paid'),
(8, 1100.00, 10.20, 150.00, 48.01, 'Paid'),
(9, 1000.00, 5.50, 0.00, 50.28, 'Paid'),
(10, 2000.00, 8.75, 500.00, 75.44, 'Pending');

-- Insert Payments
INSERT INTO PAYMENT (BillID, Amount, PaymentMethod, TransactionID) VALUES
(1, 1521.56, 'Credit Card', 'TXN00123456'),
(2, 808.29, 'Cash', 'TXN00123457'),
(3, 1380.65, 'Debit Card', 'TXN00123458'),
(4, 952.14, 'Insurance', 'TXN00123459'),
(5, 600.00, 'Online', 'TXN00123460'),
(6, 500.00, 'Credit Card', 'TXN00123461'),
(7, 1391.25, 'Debit Card', 'TXN00123462'),
(8, 1008.21, 'Cash', 'TXN00123463'),
(9, 1055.78, 'Insurance', 'TXN00123464'),
(10, 1000.00, 'Online', 'TXN00123465');

-- Insert Doctor Schedules
INSERT INTO DOCTOR_SCHEDULE (DoctorID, DayOfWeek, StartTime, EndTime, MaxPatients) VALUES
(1, 'Monday', '09:00:00', '17:00:00', 15),
(1, 'Wednesday', '09:00:00', '17:00:00', 15),
(1, 'Friday', '09:00:00', '13:00:00', 10),
(2, 'Tuesday', '10:00:00', '18:00:00', 20),
(2, 'Thursday', '10:00:00', '18:00:00', 20),
(3, 'Monday', '08:00:00', '16:00:00', 12),
(3, 'Wednesday', '08:00:00', '16:00:00', 12),
(4, 'Tuesday', '09:00:00', '17:00:00', 18),
(4, 'Friday', '09:00:00', '17:00:00', 18),
(5, 'Monday', '08:00:00', '16:00:00', 25),
(5, 'Wednesday', '08:00:00', '16:00:00', 25);

-- Insert User Accounts
INSERT INTO USER_ACCOUNT (Username, PasswordHash, Role, AssociatedID) VALUES
('admin', '$2y$10$YourHashedPasswordHere', 'Admin', 1),
('dr.carter', '$2y$10$YourHashedPasswordHere', 'Doctor', 1),
('dr.wong', '$2y$10$YourHashedPasswordHere', 'Doctor', 2),
('dr.chen', '$2y$10$YourHashedPasswordHere', 'Doctor', 3),
('john.smith', '$2y$10$YourHashedPasswordHere', 'Patient', 1),
('sarah.j', '$2y$10$YourHashedPasswordHere', 'Patient', 2),
('reception1', '$2y$10$YourHashedPasswordHere', 'Receptionist', 1);