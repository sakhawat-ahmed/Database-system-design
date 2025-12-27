

-- Storage Engine Selection (already set, but confirming)
ALTER TABLE APPOINTMENT ENGINE = InnoDB;
ALTER TABLE MEDICAL_RECORD ENGINE = InnoDB;
ALTER TABLE BILL ENGINE = InnoDB;

CREATE INDEX idx_doctor_appointment ON APPOINTMENT(DoctorID, AppointmentDateTime, Status);
CREATE INDEX idx_patient_appointment_history ON APPOINTMENT(PatientID, AppointmentDateTime DESC);
CREATE INDEX idx_billing_appointment ON BILL(AppointmentID, Status, CreatedAt);

-- Create a view for monthly appointment statistics (useful for reporting)
CREATE VIEW monthly_appointment_stats AS
SELECT 
    YEAR(AppointmentDateTime) as Year,
    MONTH(AppointmentDateTime) as Month,
    COUNT(*) as TotalAppointments,
    SUM(CASE WHEN Status = 'Completed' THEN 1 ELSE 0 END) as Completed,
    SUM(CASE WHEN Status = 'Cancelled' THEN 1 ELSE 0 END) as Cancelled,
    COUNT(DISTINCT DoctorID) as DoctorsCount,
    COUNT(DISTINCT PatientID) as PatientsCount
FROM APPOINTMENT
GROUP BY YEAR(AppointmentDateTime), MONTH(AppointmentDateTime);

-- Create a view for doctor schedule availability
CREATE VIEW doctor_schedule_view AS
SELECT 
    d.DoctorID,
    d.Name as DoctorName,
    dept.DeptName,
    ds.DayOfWeek,
    ds.StartTime,
    ds.EndTime,
    ds.MaxPatients,
    ds.IsActive
FROM DOCTOR d
JOIN DEPARTMENT dept ON d.DeptID = dept.DeptID
LEFT JOIN DOCTOR_SCHEDULE ds ON d.DoctorID = ds.DoctorID
WHERE d.IsActive = TRUE AND (ds.IsActive IS NULL OR ds.IsActive = TRUE);

-- Create a view for patient billing summary
CREATE VIEW patient_billing_summary AS
SELECT 
    p.PatientID,
    p.Name as PatientName,
    COUNT(DISTINCT a.AppointmentID) as TotalAppointments,
    COUNT(DISTINCT b.BillID) as TotalBills,
    SUM(CASE WHEN b.Status = 'Paid' THEN b.FinalAmount ELSE 0 END) as TotalPaid,
    SUM(CASE WHEN b.Status IN ('Pending', 'Partial') THEN b.FinalAmount ELSE 0 END) as TotalPending
FROM PATIENT p
LEFT JOIN APPOINTMENT a ON p.PatientID = a.PatientID
LEFT JOIN BILL b ON a.AppointmentID = b.AppointmentID
GROUP BY p.PatientID, p.Name;