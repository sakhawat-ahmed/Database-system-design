DELIMITER $$

CREATE PROCEDURE DispenseMedication(
    IN p_prescription_id INT,
    IN p_quantity INT
)
BEGIN
    DECLARE v_medicine_id INT;
    DECLARE v_current_stock INT;
    DECLARE v_finished INT DEFAULT 0;
    
    DECLARE medicine_cursor CURSOR FOR 
        SELECT MedicineID 
        FROM PRESCRIPTION_MEDICINE 
        WHERE PrescriptionID = p_prescription_id;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_finished = 1;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    OPEN medicine_cursor;
    
    get_medicine: LOOP
        FETCH medicine_cursor INTO v_medicine_id;
        IF v_finished = 1 THEN 
            LEAVE get_medicine;
        END IF;
        
        -- Check stock with FOR UPDATE to lock row
        SELECT StockQuantity INTO v_current_stock
        FROM MEDICINE 
        WHERE MedicineID = v_medicine_id
        FOR UPDATE;
        
        IF v_current_stock >= p_quantity THEN
            -- Update inventory
            UPDATE MEDICINE 
            SET StockQuantity = StockQuantity - p_quantity
            WHERE MedicineID = v_medicine_id;
        ELSE
            ROLLBACK;
            SELECT CONCAT('Insufficient stock for medicine ID: ', v_medicine_id) AS Error;
            LEAVE get_medicine;
        END IF;
    END LOOP get_medicine;
    
    CLOSE medicine_cursor;
    
    COMMIT;
    SELECT 'Medication dispensed successfully' AS Result;
END$$

DELIMITER ;