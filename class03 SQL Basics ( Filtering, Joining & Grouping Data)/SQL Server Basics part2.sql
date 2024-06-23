USE BikeStores;

-------------------------------
-- SECTION 04: FILTERING DATA
-------------------------------

/* SYNTAX:

SELECT DISTINCT
	column_name1,
	column_name2 ,
	...
FROM
	table_name;

NOTE: 
- Can be used for single columns or multiple columns
- DISTINCT sorts the values by defualt

*/

-- 4.1 Using the SELECT DISTINCT with one column
SELECT city
FROM sales.customers
ORDER BY city;

SELECT DISTINCT city
FROM sales.customers
ORDER BY city;

-- 4.1 Using SELECT DISTINCT with multiple columns
SELECT city, state
FROM sales.customers
ORDER BY city, state;

SELECT DISTINCT city, state
FROM sales.customers
-- ORDER BY city, state;

-- 4.3 Using SELECT DISTINCT with column having NULL
SELECT DISTINCT phone
FROM sales.customers
ORDER BY phone;

-- NOTE: DISTINCT clause keeps only one NULL in the phone column and removes other NULLs.

-- 4.4 DISTINCT vs. GROUP BY

SELECT city, state
FROM sales.customers
GROUP BY city, state
ORDER BY city, state;

SELECT DISTINCT city, state
FROM sales.customers;

-- NOTE: Both DISTINCT and GROUP BY clause reduces the number of returned rows in the result set by removing the duplicates.

/*
SYNTAX:

SELECT
    select_list
FROM
    table_name
WHERE
    search_condition;

NOTE: Searching condition can have multiple operators
1. AND
2. OR
3. BETWEEN
4. IN
5. LIKES
*/

SELECT 
	   product_id,
	   product_name,
	   category_id,
	   model_year,
	   list_price
FROM production.products;

-- 4.5 Using the WHERE clause with a simple equality operator

SELECT 
	   product_id,
	   product_name,
	   category_id,
	   model_year,
	   list_price
FROM production.products
WHERE category_id = 1
ORDER BY list_price;

-- 4.6 Using the WHERE clause with the AND operator

SELECT 
	   product_id,
	   product_name,
	   category_id,
	   model_year,
	   list_price
FROM production.products
WHERE category_id = 1 AND model_year = 2018
ORDER BY list_price ;

-- 4.7 Using WHERE to filter rows using a comparison operator

SELECT 
	   product_id,
	   product_name,
	   category_id,
	   model_year,
	   list_price
FROM production.products
WHERE list_price > 279.99 AND model_year = 2018
ORDER BY list_price ;

-- 4.7 Using the WHERE clause to filter rows that meet any of two conditions

SELECT 
	   product_id,
	   product_name,
	   category_id,
	   model_year,
	   list_price
FROM production.products
WHERE list_price > 279.99 OR model_year = 2018
ORDER BY list_price ;

-- 4.8 Using the WHERE clause to filter rows with the value between two values

SELECT 
	   product_id,
	   product_name,
	   category_id,
	   model_year,
	   list_price
FROM production.products
WHERE list_price BETWEEN 1259.99 AND 1999.99
ORDER BY list_price ;

-- 4.9 Using the WHERE clause to filter rows that have a value in a list of values

SELECT 
	   product_id,
	   product_name,
	   category_id,
	   model_year,
	   list_price
FROM production.products
WHERE list_price IN (1299.99, 1320.99, 1349.00, 1409.99)
ORDER BY list_price ;

-- 4.10 Finding rows whose values contain a string

SELECT 
	   product_id,
	   product_name,
	   category_id,
	   model_year,
	   list_price
FROM production.products
WHERE product_name LIKE '%Cruiser%'
ORDER BY list_price ;

-- 4.11 SQL Server column alias

/*
SYNTAX:

table_name AS table_alias
table_name table_alias

*/

SELECT category_name 'Product Category'
FROM production.categories
ORDER BY category_name;  

SELECT category_name 'Product Category'
FROM production.categories
ORDER BY 'Product Category';

SELECT category_name AS 'Product Category'
FROM production.categories
ORDER BY category_name;  

-------------------------------
-- SECTION 05: JOINING DATA
-------------------------------

CREATE SCHEMA hr;
go

CREATE TABLE hr.candidates(
	id INT IDENTITY(1,1) PRIMARY KEY,
	fullname VARCHAR(100) NOT NULL
)

CREATE TABLE hr.employees(
	id INT IDENTITY(1,1) PRIMARY KEY,
	fullname VARCHAR(100) NOT NULL
)

INSERT INTO hr.candidates(fullname)
VALUES
    ('John Doe'),
    ('Lily Bush'),
    ('Peter Drucker'),
    ('Jane Doe');

INSERT INTO hr.employees(fullname)
VALUES
    ('John Doe'),
    ('Jane Doe'),
    ('Michael Scott'),
    ('Jack Sparrow');

/*
Suppose,

1. candidates == LEFTTABLE
2. employees == RIGHT TABLE

*/

-- 5.1 SQL Server Inner Join

SELECT 
	c.id, c.fullname,
	e.id, e.fullname
FROM hr.candidates c
INNER JOIN hr.employees e
ON c.fullname = e.fullname;

-- 5.2 SQL Server Left Join

SELECT 
	c.id, c.fullname,
	e.id, e.fullname
FROM hr.candidates c
LEFT JOIN hr.employees e
ON c.fullname = e.fullname;


SELECT 
	c.id, c.fullname,
	e.id, e.fullname
FROM hr.candidates c
LEFT JOIN hr.employees e
ON c.fullname = e.fullname
WHERE e.id IS NULL;

-- 5.3 SQL Server Right Join

SELECT 
	c.id, c.fullname,
	e.id, e.fullname
FROM hr.candidates c
RIGHT JOIN hr.employees e
ON c.fullname = e.fullname;

SELECT 
	c.id, c.fullname,
	e.id, e.fullname
FROM hr.candidates c
RIGHT JOIN hr.employees e
ON c.fullname = e.fullname
WHERE c.id IS NULL;

-- 5.4 SQL Server FULL Join

SELECT 
	c.id, c.fullname,
	e.id, e.fullname
FROM hr.candidates c
FULL JOIN hr.employees e
ON c.fullname = e.fullname;

SELECT 
	c.id, c.fullname,
	e.id, e.fullname
FROM hr.candidates c
FULL JOIN hr.employees e
ON c.fullname = e.fullname
WHERE c.id IS NULL or e.id IS NULL;

-- 5.4 SQL Server Cross Join

CREATE TABLE Meals(MealName VARCHAR(100));
CREATE TABLE Drinks(DrinkName VARCHAR(100));

INSERT INTO Drinks
VALUES('Orange Juice'), ('Tea'), ('Cofee');

INSERT INTO Meals
VALUES('Omlet'), ('Fried Egg'), ('Sausage');

SELECT *
FROM Meals;

SELECT *
FROM Drinks

-- 5.4 SQL Server SELF Join


-------------------------------
-- SECTION 05: GROUPING DATA
-------------------------------