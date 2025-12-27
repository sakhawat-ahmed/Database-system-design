DELIMITER $$

CREATE PROCEDURE RescheduleAppointment(
    IN p_appointment_id INT,
    IN p_new_datetime DATETIME,
    IN p_doctor_id INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    -- Check if new slot is available
    SELECT COUNT(*) INTO @conflict_count
    FROM APPOINTMENT
    WHERE DoctorID = p_doctor_id
      AND AppointmentDateTime = p_new_datetime
      AND Status IN ('Scheduled', 'Confirmed')
      AND AppointmentID != p_appointment_id;
    
    IF @conflict_count > 0 THEN
        ROLLBACK;
        SELECT 'Timeslot not available' AS Result;
    ELSE
        -- Update appointment
        UPDATE APPOINTMENT 
        SET AppointmentDateTime = p_new_datetime,
            DoctorID = p_doctor_id,
            Status = 'Confirmed'
        WHERE AppointmentID = p_appointment_id;
        
        -- Update bill if doctor changed (different consultation fee)
        UPDATE BILL b
        JOIN APPOINTMENT a ON b.AppointmentID = a.AppointmentID
        JOIN DOCTOR d ON a.DoctorID = d.DoctorID
        SET b.ConsultationFee = d.ConsultationFee
        WHERE a.AppointmentID = p_appointment_id;
        
        COMMIT;
        SELECT 'Appointment rescheduled successfully' AS Result;
    END IF;
END$$

DELIMITER ;