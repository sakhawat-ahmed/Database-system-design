-- Pessimistic Locking for Critical Operations
START TRANSACTION;

-- Lock the doctor's schedule for update
SELECT * FROM DOCTOR_SCHEDULE 
WHERE DoctorID = 3 
  AND DayOfWeek = 'Wednesday'
FOR UPDATE;

-- Perform updates
UPDATE DOCTOR_SCHEDULE 
SET MaxPatients = MaxPatients + 2 
WHERE DoctorID = 3 
  AND DayOfWeek = 'Wednesday';

COMMIT;

-- Optimistic Locking with Versioning
ALTER TABLE APPOINTMENT ADD COLUMN version INT DEFAULT 1;

-- Update with version check
UPDATE APPOINTMENT 
SET Status = 'Cancelled',
    version = version + 1
WHERE AppointmentID = 5 
  AND version = 1; -- Ensure no concurrent update