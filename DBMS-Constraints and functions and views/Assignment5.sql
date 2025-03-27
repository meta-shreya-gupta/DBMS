-- Create a view displaying the order information (Id, Title, Price, Shopper’s name, Email, Orderdate, Status) 
-- with latest ordered items should be displayed first for last 60 days.

CREATE VIEW OrderInformation
AS
SELECT Orders.Order_Id , Product.Product_Title AS Item_Title , 
Order_Item.price , Shopper.Name , Shopper.Email , Orders.Order_Date , Order_Item.status
FROM Orders JOIN Order_Item 
ON Orders.Order_Id = Order_Item.Order_Id
JOIN Product
ON Product.Prod_Id = Order_Item.Prod_Id
JOIN Shopper
ON Orders.Shopper_Id = Shopper.Shopper_Id
WHERE Orders.Order_Date >= NOW() - INTERVAL 60 DAY
ORDER BY Orders.Order_Date DESC;

-- Use the above view to display the Products(Items) which are in ‘shipped’ state.
SELECT Item_Title
FROM OrderInformation
WHERE Status = 'Shipped';

-- Use the above view to display the top 5 most selling products.
