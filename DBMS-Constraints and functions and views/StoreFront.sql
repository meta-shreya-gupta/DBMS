

CREATE DATABASE StoreFront;

USE StoreFront;

CREATE TABLE Category(
    Cat_Id INT PRIMARY KEY,
    Cat_Title VARCHAR(50),
    Parent_Category INT
);

CREATE TABLE Product(
    Prod_Id INT PRIMARY KEY,
    Product_Title VARCHAR(50),
    Description VARCHAR(100),
    Price DECIMAL(10,2),
    Cat_Id INT NOT NULL,
    Quantity INT,
    Status VARCHAR(10) CHECK (Status IN ('Active' , 'Inactive')),
    FOREIGN KEY (Cat_Id) REFERENCES Category(Cat_Id),
    CHECK (Price > 0)
);


CREATE TABLE Images(
    Image_Id INT PRIMARY KEY,
    Image_url VARCHAR(200),
    Prod_Id INT,
    FOREIGN KEY (Prod_Id) REFERENCES Product(Prod_Id)
);

CREATE TABLE Users(
    User_Id INT PRIMARY KEY,
    User_Name VARCHAR(50),
    Password VARCHAR(20) UNIQUE NOT NULL,
    Role VARCHAR(15) CHECK (Role IN("SHOPPER" ,"ADMINISTRATOR"))
);

CREATE TABLE Shopper(
    Shopper_Id INT PRIMARY KEY,
    Name VARCHAR(50),
    Email VARCHAR(30) NOT NULL
);

CREATE TABLE Orders(
    Order_Id INT PRIMARY KEY,
    Status VARCHAR(10) CHECK (Status IN("SHIPPED" , "CANCELED" , "RETURNED")),
    Order_Date DATETIME,
    Shopper_Id INT NOT NULL,
    FOREIGN KEY (Shopper_Id) REFERENCES Shopper(Shopper_Id)
);

CREATE TABLE Order_Item(
    Item_Id INT PRIMARY KEY,
    Order_Id INT,
    Prod_Id INT,
    Quantity INT,
    Price DECIMAL(20,2),
    Status VARCHAR(10) CHECK (Status IN("SHIPPED" , "CANCELED" , "RETURNED")),
    FOREIGN KEY (Order_Id) REFERENCES Orders(Order_Id),
    FOREIGN KEY (Prod_Id) REFERENCES Product(Prod_Id),
    CHECK (Quantity > 0),
    CHECK (Price > 0)
);
CREATE TABLE Product_Category(
    Prod_Id INT,
    Cat_Id INT NOT NULL,
    PRIMARY KEY (Prod_Id , Cat_Id),
    FOREIGN KEY (Prod_Id) REFERENCES Product(Prod_Id),
    FOREIGN KEY (Cat_Id) REFERENCES Category(Cat_Id)
);
SHOW TABLES;

INSERT INTO Category(Cat_Id , Cat_Title , Parent_Category)
VALUES 
(1 , "Electronics" , NULL),
(2 , "Mobiles" , 1),
(3 , "Laptops" , 1),
(4 , "Accessories" , 1),
(5 , "SmartPhones" , 2);

INSERT INTO Product(Prod_Id , Product_Title , Description , Price , Cat_Id , Quantity , Status)
VALUES
(1 , "iPhone 14" , "Latest Apple iPhone" , 999.99 , 5 , 0 , 'Active'),
(2 , "Dell Laptop" , "Powerfull Laptop" , 1200.00 , 3 , 5 , 'Active'),
(3 , "Samsung galaxy" , "Flagship Phone" , 899.99 , 5 , 70 , 'Active'),
(4 , "Headphones" , "Noise cancelling" , 199.99 , 4 , 15 , 'Active'),
(5 , "charger" , "Fast charging" , 29.99 , 4 , 25 , 'Active');

INSERT INTO Images(Image_Id , Image_url , Prod_Id)
VALUES
(1 , "iphone14.jpg" , 1),
(2 , "dellLaptop.jpg" , 2),
(3 , "samsung_galaxy" , 3),
(4 , "headphones.jpg" , 4),
(5 , "charger.jpg" , 5);

INSERT INTO Users(User_Id , User_Name , Password , Role)
VALUES
(1 , "Alice" , "pass123" , "Shopper"),
(2 , "Bob" , "passBob" , "Administrator"),
(3 , "charlie" , "passCharlie" , "Shopper"),
(4 , "David" , "passDavid" , "Administrator"),
(5 , "eve" , "passEve" , "Shopper");

INSERT INTO Shopper(Shopper_Id , Name , Email)
VALUES
(1 , "Alice","alice@gmail.com"),
(2 , "Charlie","charlie@gmail.com"),
(3 , "Eve","eve@gmail.com"),
(4 , "John","john@gmail.com"),
(5 , "Sarah","sarah@gmail.com");

INSERT INTO Orders(Order_Id , Status , Order_Date , Shopper_Id)
VALUES
(1 , "Shipped" , '2024-10-12 23:52:23' , 1),
(2 , "Canceled" , '2024-11-14 12:32:32' , 2),
(3 , "Returned" , '2025-03-11 10:21:12' , 3),
(4 , "Shipped" , '2025-01-12 01:03:34' , 4),
(5 , "Shipped" , '2025-03-21 04:07:00' , 5);

INSERT INTO Order_Item(Item_Id , Order_Id , Prod_Id , Quantity , Price , Status)
VALUES
(1 , 1 , 1 , 1 , 999.99 , "Shipped"),
(2 , 2 , 3 , 1 , 899.99 , "Canceled"),
(3 , 3 , 4 , 2 , 199.99 , "Returned"),
(4 , 4 , 5 , 3 , 29.99 , "Shipped"),
(5 , 5 , 2 , 1 , 1200.00 , "Shipped"),
(6 , 1 , 2 , 3 , 899.99 , "Canceled"),
(7 , 2 , 1 , 2 , 999.99 , "Canceled"),
(8 , 3 , 1 , 2 , 999.99 , "Canceled");

INSERT INTO Product_Category(Prod_Id , Cat_Id)
VALUES
(1 , 1),
(1 , 2),
(1 , 5),
(2 , 1),
(3 , 1),
(3 , 2),
(3 , 5),
(4 , 4),
(5 , 4);