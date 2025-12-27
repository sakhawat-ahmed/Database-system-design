SELECT 
    m.MedicineID,
    m.MedicineName,
    m.Manufacturer,
    m.StockQuantity,
    m.ExpiryDate,
    DATEDIFF(m.ExpiryDate, CURDATE()) AS DaysToExpiry,
    CASE 
        WHEN m.StockQuantity < 50 THEN 'CRITICAL'
        WHEN m.StockQuantity < 100 THEN 'LOW'
        ELSE 'OK'
    END AS StockStatus,
    CASE 
        WHEN DATEDIFF(m.ExpiryDate, CURDATE()) < 30 THEN 'EXPIRING SOON'
        ELSE 'OK'
    END AS ExpiryStatus,
    SUM(pm.Dosage) AS MonthlyUsage
FROM MEDICINE m
LEFT JOIN PRESCRIPTION_MEDICINE pm ON m.MedicineID = pm.MedicineID
LEFT JOIN PRESCRIPTION pr ON pm.PrescriptionID = pr.PrescriptionID
WHERE pr.IssueDate >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
    AND (m.StockQuantity < 100 OR DATEDIFF(m.ExpiryDate, CURDATE()) < 90)
GROUP BY m.MedicineID
ORDER BY StockQuantity ASC, DaysToExpiry ASC;