DELIMITER //
CREATE FUNCTION numberOfOrders(OrderMonth INT , OrderYear INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE Order_Count INT;
    SELECT COUNT(*) INTO Order_Count 
    FROM Orders
    WHERE MONTH(Order_Date) = OrderMonth
    AND YEAR(Order_Date) = OrderYear;
    RETURN Order_Count;
END;//
DELIMITER ;

SELECT storefront2.numberOfOrders(3,2025) AS Order_Count;

DELIMITER //
CREATE FUNCTION monthMaximumOrder(OrderYear INT)
RETURNS INT 
DETERMINISTIC
BEGIN
    DECLARE MaxMonth VARCHAR(10);
    SELECT MONTH(Order_Date) INTO MaxMonth
    FROM Orders
    WHERE YEAR(Order_Date) = OrderYear
    GROUP BY MONTH(Order_Date)
    ORDER BY COUNT(*) DESC
    LIMIT 1;
    RETURN MaxMonth;
END;//

DELIMITER ;

SELECT monthMaximumOrder(2025);