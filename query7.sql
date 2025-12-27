SELECT 
    p.PatientID,
    p.Name,
    p.Phone,
    COUNT(a.AppointmentID) AS TotalAppointments,
    SUM(CASE WHEN a.Status = 'No-Show' THEN 1 ELSE 0 END) AS NoShowCount,
    ROUND(SUM(CASE WHEN a.Status = 'No-Show' THEN 1 ELSE 0 END) * 100.0 / COUNT(a.AppointmentID), 2) AS NoShowRate,
    GROUP_CONCAT(DISTINCT DATE_FORMAT(a.AppointmentDateTime, '%Y-%m-%d') ORDER BY a.AppointmentDateTime DESC) AS AppointmentDates,
    MAX(a.AppointmentDateTime) AS LastAppointment
FROM PATIENT p
JOIN APPOINTMENT a ON p.PatientID = a.PatientID
WHERE a.AppointmentDateTime >= DATE_SUB(NOW(), INTERVAL 1 YEAR)
GROUP BY p.PatientID
HAVING NoShowCount >= 2
    AND NoShowRate > 20
ORDER BY NoShowRate DESC;