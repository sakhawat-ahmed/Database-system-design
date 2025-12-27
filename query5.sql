SELECT 
    d.DoctorID,
    d.Name,
    d.Specialization,
    d.ConsultationFee,
    COUNT(a.AppointmentID) AS TotalAppointments,
    SUM(CASE WHEN a.Status = 'Completed' THEN 1 ELSE 0 END) AS CompletedAppointments,
    SUM(CASE WHEN a.Status = 'Cancelled' THEN 1 ELSE 0 END) AS CancelledAppointments,
    AVG(TIMESTAMPDIFF(MINUTE, a.AppointmentDateTime, a2.AppointmentDateTime)) AS AvgConsultationTime,
    SUM(b.FinalAmount) AS TotalRevenue,
    AVG(b.FinalAmount) AS AvgBillAmount,
    COUNT(DISTINCT p.PatientID) AS UniquePatients
FROM DOCTOR d
LEFT JOIN APPOINTMENT a ON d.DoctorID = a.DoctorID
LEFT JOIN APPOINTMENT a2 ON a.AppointmentID + 1 = a2.AppointmentID 
    AND a.DoctorID = a2.DoctorID
    AND DATE(a.AppointmentDateTime) = DATE(a2.AppointmentDateTime)
LEFT JOIN BILL b ON a.AppointmentID = b.AppointmentID
LEFT JOIN PATIENT p ON a.PatientID = p.PatientID
WHERE a.AppointmentDateTime BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY d.DoctorID
ORDER BY TotalRevenue DESC;