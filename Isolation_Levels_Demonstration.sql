DELIMITER $$

CREATE PROCEDURE BookAppointmentWithCheck()
BEGIN
    DECLARE current_bookings INT;
    DECLARE max_patients INT;
    
    -- Get current bookings and max patients
    SELECT COUNT(*) INTO current_bookings 
    FROM APPOINTMENT 
    WHERE DoctorID = 2 
      AND DATE(AppointmentDateTime) = '2024-03-26'
      AND Status IN ('Scheduled', 'Confirmed');
    
    SELECT MaxPatients INTO max_patients 
    FROM DOCTOR_SCHEDULE 
    WHERE DoctorID = 2 
      AND DayOfWeek = DAYNAME('2024-03-26');
    
    IF current_bookings < max_patients THEN
        INSERT INTO APPOINTMENT (PatientID, DoctorID, AppointmentDateTime)
        VALUES (3, 2, '2024-03-26 11:30:00');
        SELECT 'Appointment booked successfully' AS Result;
    ELSE
        SELECT 'No available slots' AS Result;
    END IF;
END$$

DELIMITER ;

-- Execute the procedure
CALL BookAppointmentWithCheck();