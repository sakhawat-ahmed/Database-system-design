DELIMITER $$

CREATE PROCEDURE BookAppointment(
    IN p_patient_id INT,
    IN p_doctor_id INT,
    IN p_appointment_datetime DATETIME
)
proc_label: BEGIN
    DECLARE v_available_slots INT;
    DECLARE v_consultation_fee DECIMAL(10,2);
    DECLARE v_last_appointment_id INT;
    DECLARE v_is_doctor_active BOOLEAN;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    -- Check if doctor is active
    SELECT IsActive INTO v_is_doctor_active
    FROM DOCTOR 
    WHERE DoctorID = p_doctor_id;
    
    IF NOT v_is_doctor_active THEN
        ROLLBACK;
        SELECT 'Doctor is not active' AS Result;
        LEAVE proc_label;
    END IF;
    
    -- Check availability using subquery
    SELECT 
        (ds.MaxPatients - COALESCE(a.booked_count, 0)) 
    INTO v_available_slots
    FROM DOCTOR_SCHEDULE ds
    LEFT JOIN (
        SELECT DoctorID, COUNT(*) as booked_count
        FROM APPOINTMENT 
        WHERE DoctorID = p_doctor_id
            AND DATE(AppointmentDateTime) = DATE(p_appointment_datetime)
            AND Status IN ('Scheduled', 'Confirmed')
        GROUP BY DoctorID
    ) a ON ds.DoctorID = a.DoctorID
    WHERE ds.DoctorID = p_doctor_id
        AND ds.DayOfWeek = DAYNAME(p_appointment_datetime)
        AND TIME(p_appointment_datetime) BETWEEN ds.StartTime AND ds.EndTime
        AND ds.IsActive = TRUE;
    
    -- If no schedule found or no slots available
    IF v_available_slots IS NULL THEN
        ROLLBACK;
        SELECT 'Doctor not available at this time' AS Result;
        LEAVE proc_label;
    ELSEIF v_available_slots <= 0 THEN
        ROLLBACK;
        SELECT 'No available slots for selected doctor' AS Result;
        LEAVE proc_label;
    END IF;
    
    -- Book appointment
    INSERT INTO APPOINTMENT (PatientID, DoctorID, AppointmentDateTime, Status)
    VALUES (p_patient_id, p_doctor_id, p_appointment_datetime, 'Scheduled');
    
    SET v_last_appointment_id = LAST_INSERT_ID();
    
    -- Get consultation fee
    SELECT ConsultationFee INTO v_consultation_fee
    FROM DOCTOR WHERE DoctorID = p_doctor_id;
    
    -- Create initial bill
    INSERT INTO BILL (AppointmentID, ConsultationFee, Status)
    VALUES (v_last_appointment_id, v_consultation_fee, 'Pending');
    
    COMMIT;
    
    SELECT 
        'Appointment booked successfully' AS Result,
        v_last_appointment_id AS AppointmentID,
        p_appointment_datetime AS AppointmentTime;
    
END$$

DELIMITER ;