CREATE DATABASE AMAZON;
SELECT * FROM amazonsalesdata;
DROP Table amazonsalesdata;
SELECT * FROM amazonsalesorders;
SELECT *FROM amazonsalesprice;

 -- Add a Primary Key to table orders
 ALTER TABLE amazonsalesorders ADD PRIMARY KEY(	`Order ID`); 
 -- Add Foreign key tableprices
 ALTER TABLE amazonsalesprice ADD FOREIGN KEY(`Order ID`) REFERENCES amazonsalesorders  (`Order ID`) ON DELETE SET NULL;
 
-- Join the Tables For to get the most important columns
SELECT o.`Order ID`, o.`Item Type`, o.`Sales Channel`,
o.`Order Date`, o.Region, o.Country,
p.`Units Sold`, p.`Unit Price`, p.`Unit Cost`, p.`Total Profit`
FROM amazonsalesorders o
JOIN amazonsalesprice p
ON o.`Order ID` = p.`Order ID` 
GROUP BY  o.`Order ID`, o.`Item Type`, o.`Sales Channel`,
o.`Order Date`, o.Region, o.Country,
p.`Units Sold`, p.`Unit Price`, 
p.`Unit Cost`, p.`Total Profit` LIMIT 10;

SHOW FIELDS FROM amazonsalesprice;
DESCRIBE amazonsalesorders;

-- Create a subquery and do basic calculations for revenue cost and profit
SELECT  `Order ID`,`Units Sold`,Unit_Price,Unit_Cost, 
`Units Sold`*Unit_Price AS Revenue, `Units Sold`* Unit_Cost AS Total_Cost, 
((`Units Sold`*Unit_Price) -  (`Units Sold`* Unit_Cost) )As Profit
 FROM (
SELECT o.`Order ID`, o.`Item Type`, o.`Sales Channel`,
o.`Order Date`, o.Region, o.Country,
p.`Units Sold`, p.`Unit Price`,
-- Use the replace func to remove the dollar sign prices
-- Convert, cast changes data type to INT
CAST(REPLACE (p.`Unit Price`,'$','') AS SIGNED INT) AS Unit_Price,
CONVERT(REPLACE (p.`Unit Cost`,'$',''), UNSIGNED INTEGER) AS Unit_Cost,
CAST(REPLACE (p.`Total Profit`,'$','') AS UNSIGNED INTEGER) AS Total_Profit
FROM amazonsalesorders o
JOIN amazonsalesprice p
ON o.`Order ID` = p.`Order ID` 
GROUP BY  o.`Order ID`, o.`Item Type`, o.`Sales Channel`,
o.`Order Date`, o.Region, o.Country,
p.`Units Sold`, p.`Unit Price`, 
p.`Unit Cost`, p.`Total Profit`)
AS Sales;

-- SHOW FIELDS from amazonsalesprice;
-- ALTER TABLE `amazon`.`amazonsalesprice`
-- MODIFY COLUMN `Unit Price` BIGINT;

-- Select everything from created views
SELECT * FROM sales_view;
SELECT * FROM amazonsales_view;

SELECT  Channel, Type, sum(`Units_Sold`) AS Total_Units, COUNT(`Units_Sold`) 
FROM sales_view 
WHERE Type IN ("Cereal", "Fruits", 'Baby Food')
GROUP BY Channel, Type;

-- get the total number of order by Item
SELECT  `Item Type`,COUNT(`Order ID`) AS Total_Orders
FROM amazonsalesorders  GROUP BY `Item Type` ORDER BY Total_Orders DESC;

SELECT  `Type`, SUM(`Units_Sold`) AS Total_SoldUnits
FROM sales_view
GROUP BY  `Type`  ORDER BY Total_SoldUnits DESC ;

SELECT Channel, SUM(Revenue), SUM(Total_Cost), SUM(Profit)
FROM sales_view
GROUP BY Channel;

SELECT DISTINCT Region FROM sales_view;

SELECT `Order Priority` , Count(`Order ID`) AS `Orders` FROM amazonsalesorders 
GROUP BY `Order Priority` Order BY `Orders` DESC;

SELECT `Item Type`, COUNT(`Order ID`)  FROM amazonsalesorders 
WHERE `Order Date` LIKE '%2010' 
GROUP BY `Item Type`;

SELECT Revenue, Total_Cost, `Order Date` FROM sales_view; 

SELECT Country, AVG(Revenue), AVG(Total_Cost), AVG(Profit)
FROM sales_view
GROUP BY Country ORDER BY Profit DESC;

-- UNION Same data type to combine columns to add rows
SELECT Region AS Test, `Sales Channel` AS JustTest  From amazonsalesorders
UNION 
SELECT `Units Sold`, `Unit Cost` FROM amazonsalesprice;

-- NESTED QUERY to find the regions with > 5000 units sold
SELECT MIN(`Units Sold`), MAX(`Units Sold`) FROM amazonsalesprice;

SELECT DISTINCT o.`Region`, o.`Sales Channel`  FROM amazonsalesorders o 
WHERE o. `Order ID` IN (
	SELECT p.`Order ID` FROM amazonsalesprice p
	WHERE `Units Sold` >= 5000) ;

-- ON DELETE PK CASCADE
INSERT INTO amazonsalesorders (Country, `Order ID`) VALUES ('Kenya', 404);
SELECT *  FROM amazonsalesorders Where `Order ID` = 404;
SELECT * FROM amazonsalesprice WHERE `Order ID` = 404;
INSERT INTO amazonsalesprice (`Order ID`,`Units Sold`, `Total Profit`)
VALUES( 404, 10000, 12000000);
DELETE FROM amazonsalesorders WHERE `Order ID` = 404;

SELECT `Item Type`, `Order ID`, LEFT(`Ship Date`,4) AS Shipyear,RIGHT(`Order Date`,2)AS OrderDay, 
`Ship Date` - `Order Date` As Deliverytime,
ABS(`Order Date` - `Ship Date`) As Deliverytime1
 -- CAST(`Ship Date` AS DATE) - CAST (`Order Date`  As DATE) AS deliverytime,
-- str_to_date(`Order Date`, '%y-%m-%d') as date1,
-- str_to_date(`Order Date`, '%d-%m-%y') as date2,
-- DATE_FORMAT(STR_TO_DATE(`Order Date`, '%m/%d/%Y'), '%Y/%m/%d') AS formatted_date
-- `Ship Date`:: DATE - `Order Date`::DATE AS delivery_time
FROM amazonsalesorders
ORDER BY Deliverytime;

-- Convert column data type from str to date 
SELECT STR_TO_DATE('2/2/2012', '%m/%d/%Y');

UPDATE amazonsalesorders SET `Order Date` = STR_TO_DATE(`Order Date`, '%m/%d/%Y');
ALTER TABLE amazonsalesorders MODIFY  COLUMN `Order Date`  DATE ;
DESCRIBE amazonsalesorders;
UPDATE amazonsalesorders SET `Ship Date` = STR_TO_DATE(`Ship Date`, '%m/%d/%Y');
ALTER TABLE amazonsalesorders MODIFY  COLUMN `Ship Date`  DATE;

ALTER TABLE amazonsalesprice MODIFY COLUMN  `Unit Price` INTEGER;