-- Display the list of products (Id, Title, Count of Categories) which fall in more than one Category.
SELECT Product.Prod_Id , Product.Product_Title , COUNT(Product_Category.Cat_Id) AS count
FROM Product JOIN Product_Category
ON Product.Prod_Id = Product_Category.Prod_Id
GROUP BY Product.Prod_Id
HAVING count > 1;

-- Display Count of products as per below price range:
-- Range in Rs.        Count
-- 0 - 100
-- 101 - 500
-- Above 500
SELECT price_range, COUNT(*) AS product_count
    FROM 
    (SELECT
    CASE
    WHEN Price BETWEEN 0 AND 100 THEN '0-100'
    WHEN Price BETWEEN 101 AND 500 THEN '101-500'
    ELSE 'Above 500'
    END AS price_range
FROM Product)
AS price_groups
GROUP BY price_range
ORDER BY price_range ASC;

-- Display the Categories along with number of products under each category.
SELECT Category.Cat_Id , Category.Cat_Title , COUNT(Product_Category.Prod_Id) AS count
FROM Category LEFT JOIN Product_Category
ON Category.Cat_Id = Product_Category.Cat_Id
GROUP BY Category.Cat_Id;