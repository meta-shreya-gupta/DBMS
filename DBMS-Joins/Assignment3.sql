-- Display Recent 50 Orders placed (Id, Order Date, Order Total).
SELECT Order_Id AS Id , Order_Date , 
(SELECT SUM(Price * Quantity) FROM Order_Item where Order_Id = Orders.Order_Id) AS Order_Total
FROM Orders
ORDER BY Order_Date DESC
LIMIT 50;

-- Display 10 most expensive Orders.
SELECT Orders.Order_Id , Orders.Order_Date , SUM(Order_Item.Price * Order_Item.Quantity) AS Order_Total
FROM Orders JOIN Order_Item
ON Orders.Order_Id = Order_Item.Order_Id
GROUP BY Orders.Order_Id
ORDER BY Order_Total DESC
LIMIT 10;

-- Display all the Orders which are placed more than 10 days old and one or more items from those orders are still not shipped.
SELECT Order_Id , Order_Date 
FROM Orders
WHERE Order_Date < NOW() - INTERVAL 10 DAY
AND Order_Id NOT IN(SELECT DISTINCT Order_Id FROM Order_Item WHERE status <> "Shipped");

-- Display list of shoppers which haven't ordered anything since last month.
SELECT Shopper_Id , Name
FROM Shopper
WHERE Shopper.Shopper_Id NOT IN
(SELECT DISTINCT Shopper_Id
FROM Orders
WHERE Order_Date >= DATE_SUB(CURRENT_DATE() , INTERVAL 1 MONTH));

-- Display list of shopper along with orders placed by them in last 15 days. 
SELECT Shopper.Name , Orders.Order_Id
FROM Orders JOIN Shopper
ON Orders.Shopper_Id = Shopper.Shopper_Id
WHERE Orders.Order_Date > NOW() - INTERVAL 15 DAY; 

-- Display list of order items which are in “shipped” state for particular Order Id (i.e.: 1020))
SELECT Order_Item.Item_Id , Product.Product_Title AS PRODUCT 
FROM Order_Item JOIN Product
ON Order_Item.Prod_Id = Product.Prod_Id
WHERE Order_Id = 1 AND Order_Item.Status = "SHIPPED";

-- Display list of order items along with order placed date which fall between Rs 20 to Rs 50 price.
SELECT oi.Order_Id , p.Product_Title , o.Order_Date , oi.price
FROM Order_Item oi 
JOIN Product p
ON oi.Prod_Id = p.Prod_Id
JOIN Orders o 
ON oi.Order_Id = o.Order_Id
WHERE oi.price BETWEEN 20 AND 50;