SELECT 
    Diagnosis,
    COUNT(*) AS Frequency,
    GROUP_CONCAT(DISTINCT d.Specialization) AS TreatingSpecialties,
    AVG(b.FinalAmount) AS AvgTreatmentCost,
    COUNT(DISTINCT p.PatientID) AS AffectedPatients
FROM MEDICAL_RECORD mr
JOIN APPOINTMENT a ON mr.AppointmentID = a.AppointmentID
JOIN DOCTOR d ON a.DoctorID = d.DoctorID
JOIN BILL b ON a.AppointmentID = b.AppointmentID
JOIN PATIENT p ON a.PatientID = p.PatientID
WHERE mr.Diagnosis IS NOT NULL 
    AND mr.Diagnosis != ''
    AND a.AppointmentDateTime >= DATE_SUB(NOW(), INTERVAL 6 MONTH)
GROUP BY mr.Diagnosis
HAVING Frequency > 5
ORDER BY Frequency DESC
LIMIT 10;