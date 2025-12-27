-- Check current binary logging status
SHOW VARIABLES LIKE 'log_bin';
SHOW VARIABLES LIKE 'binlog_format';

-- Create backup log table if not exists
CREATE TABLE IF NOT EXISTS backup_log (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    backup_type VARCHAR(20),
    backup_date DATE,
    backup_path VARCHAR(255),
    status VARCHAR(20),
    error_message TEXT,
    records_backed_up INT,
    file_size_mb DECIMAL(10,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_backup_date (backup_date),
    INDEX idx_status (status)
);

-- Create directory for backups (adjust path as needed)
-- Note: Create this directory manually with appropriate permissions
-- Example: sudo mkdir -p /var/backups/mysql/hospital
-- Example: sudo chown -R mysql:mysql /var/backups/mysql/

DELIMITER $$

-- ============================================
-- PROCEDURE: CreateDailyBackup
-- Creates CSV backups of critical tables
-- ============================================
CREATE PROCEDURE CreateDailyBackup()
BEGIN
    DECLARE backup_date VARCHAR(10);
    DECLARE backup_path VARCHAR(255);
    DECLARE patient_count INT;
    DECLARE appointment_count INT;
    DECLARE doctor_count INT;
    DECLARE exit_handler INT DEFAULT 0;
    
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
    BEGIN
        SET exit_handler = 1;
        GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, 
        @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
        SET @error_message = CONCAT('Error: ', @errno, ' - ', @text);
    END;
    
    -- Set backup date and path
    SET backup_date = DATE_FORMAT(NOW(), '%Y%m%d');
    
    -- IMPORTANT: Change this path to match your system
    -- For Windows: 'C:/backups/mysql/hospital/'
    -- For Linux: '/var/backups/mysql/hospital/'
    SET backup_path = '/var/backups/mysql/hospital/';
    
    -- Log backup start
    INSERT INTO backup_log (backup_type, backup_date, backup_path, status)
    VALUES ('Daily', CURDATE(), backup_path, 'Started');
    
    SET @log_id = LAST_INSERT_ID();
    
    START TRANSACTION;
    
    -- Backup PATIENT table
    SET @patient_query = CONCAT(
        'SELECT * INTO OUTFILE \'',
        backup_path, 'patients_', backup_date, '.csv\' ',
        'FIELDS TERMINATED BY \',\' OPTIONALLY ENCLOSED BY \'"\' ',
        'LINES TERMINATED BY \'\\n\' ',
        'FROM PATIENT'
    );
    
    PREPARE patient_stmt FROM @patient_query;
    EXECUTE patient_stmt;
    DEALLOCATE PREPARE patient_stmt;
    
    -- Get count of patients backed up
    SELECT COUNT(*) INTO patient_count FROM PATIENT;
    
    -- Backup APPOINTMENT table
    SET @appointment_query = CONCAT(
        'SELECT * INTO OUTFILE \'',
        backup_path, 'appointments_', backup_date, '.csv\' ',
        'FIELDS TERMINATED BY \',\' OPTIONALLY ENCLOSED BY \'"\' ',
        'LINES TERMINATED BY \'\\n\' ',
        'FROM APPOINTMENT'
    );
    
    PREPARE appointment_stmt FROM @appointment_query;
    EXECUTE appointment_stmt;
    DEALLOCATE PREPARE appointment_stmt;
    
    -- Get count of appointments backed up
    SELECT COUNT(*) INTO appointment_count FROM APPOINTMENT;
    
    -- Backup DOCTOR table
    SET @doctor_query = CONCAT(
        'SELECT * INTO OUTFILE \'',
        backup_path, 'doctors_', backup_date, '.csv\' ',
        'FIELDS TERMINATED BY \',\' OPTIONALLY ENCLOSED BY \'"\' ',
        'LINES TERMINATED BY \'\\n\' ',
        'FROM DOCTOR'
    );
    
    PREPARE doctor_stmt FROM @doctor_query;
    EXECUTE doctor_stmt;
    DEALLOCATE PREPARE doctor_stmt;
    
    -- Get count of doctors backed up
    SELECT COUNT(*) INTO doctor_count FROM DOCTOR;
    
    -- Backup BILL table
    SET @bill_query = CONCAT(
        'SELECT * INTO OUTFILE \'',
        backup_path, 'bills_', backup_date, '.csv\' ',
        'FIELDS TERMINATED BY \',\' OPTIONALLY ENCLOSED BY \'"\' ',
        'LINES TERMINATED BY \'\\n\' ',
        'FROM BILL'
    );
    
    PREPARE bill_stmt FROM @bill_query;
    EXECUTE bill_stmt;
    DEALLOCATE PREPARE bill_stmt;
    
    -- Create manifest file
    SET @manifest_query = CONCAT(
        'SELECT ',
        '\'Hospital Appointment System Backup\' AS system_name, ',
        '\'', backup_date, '\' AS backup_date, ',
        'NOW() AS backup_time, ',
        patient_count, ' AS patient_count, ',
        appointment_count, ' AS appointment_count, ',
        doctor_count, ' AS doctor_count, ',
        '\'Backup completed successfully\' AS status ',
        'INTO OUTFILE \'',
        backup_path, 'manifest_', backup_date, '.csv\' ',
        'FIELDS TERMINATED BY \',\' OPTIONALLY ENCLOSED BY \'"\' ',
        'LINES TERMINATED BY \'\\n\''
    );
    
    PREPARE manifest_stmt FROM @manifest_query;
    EXECUTE manifest_stmt;
    DEALLOCATE PREPARE manifest_stmt;
    
    IF exit_handler = 1 THEN
        ROLLBACK;
        -- Update log with failure
        UPDATE backup_log 
        SET status = 'Failed', 
            error_message = @error_message
        WHERE log_id = @log_id;
        SELECT CONCAT('Backup failed: ', @error_message) AS Result;
    ELSE
        COMMIT;
        -- Update log with success
        UPDATE backup_log 
        SET status = 'Completed',
            records_backed_up = (patient_count + appointment_count + doctor_count),
            file_size_mb = ROUND((patient_count * 0.5 + appointment_count * 0.3 + doctor_count * 0.2) / 1024, 2)
        WHERE log_id = @log_id;
        SELECT CONCAT('Backup completed successfully to ', backup_path, 
                      '. Records backed up: ', 
                      (patient_count + appointment_count + doctor_count)) AS Result;
    END IF;
    
END$$

-- ============================================
-- PROCEDURE: RestoreFromBackup
-- Restores data from CSV backup files
-- ============================================
CREATE PROCEDURE RestoreFromBackup(IN p_backup_date VARCHAR(8))
BEGIN
    DECLARE backup_path VARCHAR(255);
    DECLARE exit_handler INT DEFAULT 0;
    
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
    BEGIN
        SET exit_handler = 1;
        GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, 
        @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
        SET @error_message = CONCAT('Error: ', @errno, ' - ', @text);
    END;
    
    -- Set backup path (must match CreateDailyBackup path)
    SET backup_path = '/var/backups/mysql/hospital/';
    
    START TRANSACTION;
    
    -- Disable foreign key checks for restore
    SET FOREIGN_KEY_CHECKS = 0;
    
    -- Truncate tables before restore (optional - comment out if you want to append)
    -- TRUNCATE TABLE PATIENT;
    -- TRUNCATE TABLE APPOINTMENT;
    -- TRUNCATE TABLE DOCTOR;
    -- TRUNCATE TABLE BILL;
    
    -- Restore PATIENT table
    SET @restore_patient = CONCAT(
        'LOAD DATA INFILE \'',
        backup_path, 'patients_', p_backup_date, '.csv\' ',
        'REPLACE INTO TABLE PATIENT ',
        'FIELDS TERMINATED BY \',\' OPTIONALLY ENCLOSED BY \'"\' ',
        'LINES TERMINATED BY \'\\n\''
    );
    
    PREPARE restore_patient_stmt FROM @restore_patient;
    EXECUTE restore_patient_stmt;
    DEALLOCATE PREPARE restore_patient_stmt;
    
    -- Restore DOCTOR table
    SET @restore_doctor = CONCAT(
        'LOAD DATA INFILE \'',
        backup_path, 'doctors_', p_backup_date, '.csv\' ',
        'REPLACE INTO TABLE DOCTOR ',
        'FIELDS TERMINATED BY \',\' OPTIONALLY ENCLOSED BY \'"\' ',
        'LINES TERMINATED BY \'\\n\''
    );
    
    PREPARE restore_doctor_stmt FROM @restore_doctor;
    EXECUTE restore_doctor_stmt;
    DEALLOCATE PREPARE restore_doctor_stmt;
    
    -- Restore APPOINTMENT table
    SET @restore_appointment = CONCAT(
        'LOAD DATA INFILE \'',
        backup_path, 'appointments_', p_backup_date, '.csv\' ',
        'REPLACE INTO TABLE APPOINTMENT ',
        'FIELDS TERMINATED BY \',\' OPTIONALLY ENCLOSED BY \'"\' ',
        'LINES TERMINATED BY \'\\n\''
    );
    
    PREPARE restore_appointment_stmt FROM @restore_appointment;
    EXECUTE restore_appointment_stmt;
    DEALLOCATE PREPARE restore_appointment_stmt;
    
    -- Restore BILL table
    SET @restore_bill = CONCAT(
        'LOAD DATA INFILE \'',
        backup_path, 'bills_', p_backup_date, '.csv\' ',
        'REPLACE INTO TABLE BILL ',
        'FIELDS TERMINATED BY \',\' OPTIONALLY ENCLOSED BY \'"\' ',
        'LINES TERMINATED BY \'\\n\''
    );
    
    PREPARE restore_bill_stmt FROM @restore_bill;
    EXECUTE restore_bill_stmt;
    DEALLOCATE PREPARE restore_bill_stmt;
    
    -- Re-enable foreign key checks
    SET FOREIGN_KEY_CHECKS = 1;
    
    IF exit_handler = 1 THEN
        ROLLBACK;
        SELECT CONCAT('Restore failed: ', @error_message) AS Result;
    ELSE
        COMMIT;
        
        -- Get counts of restored records
        SELECT 
            (SELECT COUNT(*) FROM PATIENT) AS patients_restored,
            (SELECT COUNT(*) FROM DOCTOR) AS doctors_restored,
            (SELECT COUNT(*) FROM APPOINTMENT) AS appointments_restored,
            (SELECT COUNT(*) FROM BILL) AS bills_restored,
            CONCAT('Restore completed successfully from backup: ', p_backup_date) AS message;
    END IF;
    
END$$

-- ============================================
-- PROCEDURE: BackupCriticalDataOnly
-- Backups only critical data (simplified version)
-- ============================================
CREATE PROCEDURE BackupCriticalDataOnly()
BEGIN
    DECLARE backup_timestamp VARCHAR(20);
    DECLARE backup_path VARCHAR(255);
    
    -- Create timestamp for backup
    SET backup_timestamp = DATE_FORMAT(NOW(), '%Y%m%d_%H%M%S');
    SET backup_path = '/var/backups/mysql/hospital_critical/';
    
    -- Create backup directory if needed (requires appropriate permissions)
    
    -- Backup using a simpler approach
    -- This will fail if directory doesn't exist or MySQL doesn't have permissions
    SELECT 'Starting critical data backup...' AS Status;
    
    -- Backup using dynamic SQL to avoid permission issues
    SET @backup_sql = CONCAT(
        'SELECT ',
        '(SELECT COUNT(*) FROM PATIENT) AS total_patients, ',
        '(SELECT COUNT(*) FROM APPOINTMENT WHERE Status = \"Completed\") AS completed_appointments, ',
        '(SELECT COUNT(*) FROM DOCTOR WHERE IsActive = TRUE) AS active_doctors, ',
        '(SELECT SUM(FinalAmount) FROM BILL WHERE Status = \"Paid\") AS total_revenue, ',
        'NOW() AS backup_time ',
        'INTO OUTFILE \'',
        backup_path, 'critical_stats_', backup_timestamp, '.csv\' ',
        'FIELDS TERMINATED BY \',\' OPTIONALLY ENCLOSED BY \'"\' ',
        'LINES TERMINATED BY \'\\n\''
    );
    
    PREPARE backup_stmt FROM @backup_sql;
    EXECUTE backup_stmt;
    DEALLOCATE PREPARE backup_stmt;
    
    SELECT CONCAT('Critical data backup completed: ', backup_timestamp) AS Result;
    
END$$

-- ============================================
-- PROCEDURE: ListAvailableBackups
-- Lists all available backup files
-- ============================================
CREATE PROCEDURE ListAvailableBackups()
BEGIN
    -- Show backup log entries
    SELECT 
        log_id,
        backup_type,
        backup_date,
        backup_path,
        status,
        records_backed_up,
        file_size_mb,
        created_at
    FROM backup_log
    ORDER BY created_at DESC
    LIMIT 20;
    
    -- Show recent binary logs (if binary logging is enabled)
    SHOW BINARY LOGS;
    
END$$

DELIMITER $$

CREATE PROCEDURE PointInTimeRecoveryInfo()
BEGIN
    -- Check if binary logging is enabled (MySQL 8.0+ syntax)
    -- Using performance_schema instead of information_schema
    SELECT 
        VARIABLE_NAME,
        VARIABLE_VALUE,
        CASE 
            WHEN VARIABLE_NAME = 'log_bin' AND VARIABLE_VALUE = 'ON' THEN 'Binary logging enabled'
            WHEN VARIABLE_NAME = 'log_bin' AND VARIABLE_VALUE = 'OFF' THEN 'Binary logging disabled'
            WHEN VARIABLE_NAME = 'binlog_format' THEN CONCAT('Format: ', VARIABLE_VALUE)
            WHEN VARIABLE_NAME = 'expire_logs_days' THEN CONCAT('Logs expire after: ', VARIABLE_VALUE, ' days')
            ELSE 'N/A'
        END AS description
    FROM performance_schema.global_variables
    WHERE VARIABLE_NAME IN ('log_bin', 'binlog_format', 'expire_logs_days');
    
    -- Alternative using SHOW VARIABLES (if performance_schema is not available)
    /*
    SHOW VARIABLES LIKE 'log_bin';
    SHOW VARIABLES LIKE 'binlog_format';
    SHOW VARIABLES LIKE 'expire_logs_days';
    */
    
    -- Show recent binary logs for recovery
    SHOW BINARY LOGS;
    
    -- Show replication/binary log status
    SHOW MASTER STATUS;
    
    -- Provide recovery instructions
    SELECT 
        'POINT-IN-TIME RECOVERY INSTRUCTIONS:' AS header,
        '' AS step,
        '1. Identify the time to recover to' AS step1,
        '2. Find the binary log file containing that time' AS step2,
        '3. Use mysqlbinlog command:' AS step3,
        '   mysqlbinlog --start-datetime="YYYY-MM-DD HH:MM:SS" --stop-datetime="YYYY-MM-DD HH:MM:SS" mysql-bin.XXXXXX > recovery.sql' AS step4,
        '4. Review the recovery.sql file' AS step5,
        '5. Apply the recovery: mysql -u username -p database_name < recovery.sql' AS step6;
    
END$$

DELIMITER ;
