SELECT 
    YEAR(p.PaymentDate) AS Year,
    MONTH(p.PaymentDate) AS Month,
    d.DeptName,
    COUNT(DISTINCT p.BillID) AS TotalBills,
    SUM(p.Amount) AS TotalRevenue,
    AVG(p.Amount) AS AverageBillAmount,
    SUM(CASE WHEN p.PaymentMethod = 'Insurance' THEN p.Amount ELSE 0 END) AS InsuranceRevenue,
    SUM(CASE WHEN p.PaymentMethod = 'Cash' THEN p.Amount ELSE 0 END) AS CashRevenue
FROM PAYMENT p
JOIN BILL b ON p.BillID = b.BillID
JOIN APPOINTMENT a ON b.AppointmentID = a.AppointmentID
JOIN DOCTOR dct ON a.DoctorID = dct.DoctorID
JOIN DEPARTMENT d ON dct.DeptID = d.DeptID
WHERE p.PaymentDate BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY YEAR(p.PaymentDate), MONTH(p.PaymentDate), d.DeptID
ORDER BY Year DESC, Month DESC, TotalRevenue DESC;