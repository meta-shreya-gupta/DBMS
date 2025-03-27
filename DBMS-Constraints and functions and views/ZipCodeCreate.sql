CREATE DATABASE ZipCodeData;

USE ZipCodeData;

CREATE TABLE State(
    State_Id INT PRIMARY KEY AUTO_INCREMENT,
    State_Name VARCHAR(30)
);

CREATE TABLE District(
    District_Id INT PRIMARY KEY AUTO_INCREMENT,
    State_Id INT,
    District_Name VARCHAR(30),
    FOREIGN KEY (State_Id) REFERENCES State(State_Id)
);

CREATE TABLE ZipCode(
    Zip INT PRIMARY KEY,
    District_Id INT,
    FOREIGN KEY (District_Id) REFERENCES District(District_Id)
);

INSERT INTO State(State_Name)
VALUES
('Uttar Pradesh'),
('Maharashtra'),
('Bihar'),
('West Bengal'),
('Madhya Pradesh'),
('Tamil Nadu'),
('Rajasthan'),
('Karnataka'),
('Gujarat'),
('Punjab');

INSERT INTO District(State_Id , District_Name)
VALUES
(1 , 'Lucknow'),
(1 , 'Kanpur'),
(2 , 'Mumbai'),
(2 , 'Pune'),
(3 , 'Patna'),
(4 , 'Kolkata'),
(5 , 'Bhopal'),
(6 , 'Chennai'),
(7 , 'Jaipur'),
(8 , 'Bangalore');

INSERT INTO ZipCode(Zip , District_Id)
VALUES
(226001 , 1),
(208001 , 2),
(400001 , 3),
(411001 , 4),
(800001 , 5),
(700001 , 6),
(462002 , 7),
(600001 , 8),
(302001 , 9),
(560001 , 10);

-- Create appropriate tables and relationships for the same and write a SQL
-- query for that returns a Resultset containing Zip Code, City Names and
-- States ordered by State Name and City Name.
-- (Create 3 tables to store State, District/City & Zip code separately)

SELECT ZipCode.Zip , District.District_Name , State.State_Name
FROM ZipCode JOIN District 
ON ZipCode.District_Id = District.District_Id
JOIN State
ON District.State_Id = State.State_Id
ORDER BY State.State_Name , District.District_Name;