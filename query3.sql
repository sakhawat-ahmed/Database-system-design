SELECT 
    p.PatientID,
    p.Name,
    p.Phone,
    COUNT(a.AppointmentID) AS TotalAppointments,
    MAX(a.AppointmentDateTime) AS LastAppointment,
    GROUP_CONCAT(DISTINCT d.Specialization ORDER BY d.Specialization) AS ConsultedSpecialties
FROM PATIENT p
JOIN APPOINTMENT a ON p.PatientID = a.PatientID
JOIN DOCTOR d ON a.DoctorID = d.DoctorID
WHERE a.Status = 'Completed'
    AND a.AppointmentDateTime >= DATE_SUB(NOW(), INTERVAL 1 YEAR)
GROUP BY p.PatientID
HAVING TotalAppointments > 3
ORDER BY TotalAppointments DESC;