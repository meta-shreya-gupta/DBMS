-- Display Shopper’s information along with number of orders he/she placed during last 30 days.
SELECT Shopper.Shopper_Id , Shopper.Name , COUNT(Orders.Order_Id) AS NumberOfOrders
FROM Shopper LEFT JOIN ORDERS 
ON Shopper.Shopper_Id = Orders.Shopper_Id
AND Orders.Order_Date >= NOW() - INTERVAL 30 DAY
GROUP BY Shopper.Shopper_Id;

-- Display the top 10 Shoppers who generated maximum number of revenue in last 30 days.
SELECT Shopper.Shopper_Id , Shopper.Name , SUM(Order_Item.Price * Order_Item.Quantity) AS Revenue
FROM Shopper JOIN Orders ON Orders.Shopper_Id = Shopper.Shopper_Id
JOIN Order_Item ON Orders.Order_Id = Order_Item.Order_Id
WHERE Orders.Order_Date >= NOW() -INTERVAL 30 DAY
GROUP BY Shopper.Shopper_Id
ORDER BY Revenue DESC
LIMIT 10;

-- Display top 20 Products which are ordered most in last 60 days along with numbers.
SELECT Product.Prod_Id , Product.Product_Title , count(Order_Item.Prod_Id) AS Number
FROM Product JOIN Order_Item
ON Product.Prod_Id = Order_Item.Prod_Id
JOIN Orders 
ON Orders.Order_Id = Order_Item.Order_Id
WHERE Order_Date > NOW() - INTERVAL 60 DAY
GROUP BY Prod_Id
ORDER BY Number DESC
LIMIT 20;

-- Display Monthly sales revenue of the StoreFront for last 6 months. It should display each month’s sale.
SELECT DATE_FORMAT(Orders.Order_Date, '%Y-%m') AS Month, SUM(Order_Item.Quantity * Order_Item.Price) AS Total_Revenue 
FROM Orders JOIN Order_Item ON Orders.Order_Id = Order_Item.Order_Id
WHERE Orders.Order_Date >= NOW() - INTERVAL 6 MONTH 
GROUP BY Month 
ORDER BY Month;

-- Mark the products as Inactive which are not ordered in last 90 days.
UPDATE Product 
SET Product.status = 'Inactive'
WHERE Product.Prod_Id NOT IN
(SELECT DISTINCT Order_Item.Prod_Id
FROM Order_Item JOIN Orders 
ON Orders.Order_Id = Order_Item.Order_Id
WHERE Order_Date >= NOW() - INTERVAL 90 DAY);

-- Given a category search keyword, display all the Products present in this category/categories. 
SELECT Product.Product_Title , Category.Cat_Title
FROM Product JOIN Category
ON Product.Cat_Id = Category.Cat_Id
WHERE Category.Cat_Title LIKE '%Phone%'
ORDER BY Product.Product_Title;

-- Display top 10 Items which were cancelled most.
SELECT Prod_Id , COUNT(Prod_Id) AS Canceled
FROM Order_Item
WHERE status = "Canceled"
GROUP BY Prod_Id 
ORDER BY Prod_Id DESC
LIMIT 10;