USE HospitalAppointmentSystem;
SELECT 
    ds.DayOfWeek,
    ds.StartTime,
    ds.EndTime,
    ds.MaxPatients,
    COUNT(a.AppointmentID) AS BookedAppointments,
    (ds.MaxPatients - COUNT(a.AppointmentID)) AS AvailableSlots
FROM DOCTOR_SCHEDULE ds
LEFT JOIN APPOINTMENT a ON ds.DoctorID = a.DoctorID 
    AND DATE(a.AppointmentDateTime) = '2024-03-25'
    AND a.Status IN ('Scheduled', 'Confirmed')
WHERE ds.DoctorID = 1
    AND ds.DayOfWeek = DAYNAME('2024-03-25')
    AND ds.IsActive = TRUE
GROUP BY ds.ScheduleID
HAVING AvailableSlots > 0;