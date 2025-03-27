DELIMITER //
CREATE PROCEDURE AverageSales(OrderMonth INT , OrderYear INT)
BEGIN
    SELECT Order_Item.Prod_Id , AVG(Order_Item.Price * Order_Item.Quantity) AS AverageSales
    FROM Order_Item JOIN Orders ON Order_Item.Order_Id = Orders.Order_Id
    WHERE MONTH(Orders.Order_Date) = OrderMonth
    AND YEAR(Orders.Order_Date) = OrderYear
    GROUP BY Order_Item.Prod_Id;
END;//
DELIMITER ;

CALL AverageSales(03,2025);

DELIMITER //
CREATE PROCEDURE Order_Details(Start_Date DATE , End_Date DATE)
BEGIN
    IF Start_Date > End_Date THEN SET Start_Date = DATE_FORMAT(NOW() , '%Y-%M-01');
    END IF;

    SELECT Order_Id , Status , Order_Date , Shopper_Id
    FROM Orders
    WHERE Order_Date BETWEEN Start_Date AND End_Date;
END;//
DELIMITER ;

CALL Order_Details('2024-11-01' , '2025-03-11');