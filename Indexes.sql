-- Additional Indexes for Query Optimization
CREATE INDEX idx_appointment_composite ON APPOINTMENT(PatientID, Status, AppointmentDateTime);
CREATE INDEX idx_doctor_availability ON DOCTOR(IsActive, Specialization);
CREATE INDEX idx_medicine_stock ON MEDICINE(StockQuantity, ExpiryDate);
CREATE INDEX idx_payment_bill ON PAYMENT(BillID, PaymentDate);
CREATE FULLTEXT INDEX idx_patient_name ON PATIENT(Name);
CREATE FULLTEXT INDEX idx_medical_diagnosis ON MEDICAL_RECORD(Diagnosis);