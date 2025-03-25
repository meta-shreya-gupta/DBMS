-- Display Id, Title, Category Title, Price of the products which are Active and recently added products should be at top.
SELECT Prod_Id , Product_Title ,Cat_Title , Price
FROM Product AS p JOIN Category AS c
ON p.Cat_Id = c.Cat_Id
WHERE Quantity > 0
ORDER BY Prod_Id DESC;

-- Display the list of products which don't have any images.
SELECT Product_Title
FROM Product LEFT JOIN Images
ON Product.Prod_Id = Images.Prod_Id
WHERE Images.Prod_Id IS NULL;

-- Display all Id, Title and Parent Category Title for all the Categories listed, sorted by Parent Category Title and then Category Title. (If Category is top category then Parent Category Title column should display “Top Category” as value.)
SELECT c1.Cat_Id, c1.Cat_Title, IFNULL(c2.Cat_Title, 'Top Category') AS Parent_category_title
FROM Category c1
LEFT JOIN Category c2
ON c1.Parent_Category = c2.Cat_id
ORDER BY Parent_category_title, Cat_Title;

-- Display Id, Title, Parent Category Title of all the leaf Categories (categories which are not parent of any other category)
SELECT c1.Cat_id , c1.Cat_Title , c2.Cat_Title AS Parent_Category_Title 
FROM Category c1 LEFT JOIN Category c2
ON c1.Parent_Category = c2.Cat_Id
WHERE c1.Cat_Id NOT IN 
(SELECT DISTINCT Parent_Category FROM category WHERE Parent_Category IS NOT NULL);

-- Display Product Title, Price & Description which falls into particular category Title (i.e. “Mobile”)
SELECT Product_Title , Price , Description
FROM Product JOIN Category
ON Product.Cat_Id = Category.Cat_Id
WHERE Cat_Title = "Mobiles";

-- Display the list of Products whose Quantity on hand (Inventory) is under 50.
SELECT Product_Title AS List_Of_Products
FROM Product
WHERE Quantity < 50;