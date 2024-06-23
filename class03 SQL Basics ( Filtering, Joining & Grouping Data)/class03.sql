USE BikeStores;

-- section4: filtering data
-- distinct always takes first value of duplicates records
-- distinct always take NULL values in column as one entity.

SELECT city
FROM sales.customers
ORDER BY city;

SELECT DISTINCT city
FROM sales.customers
ORDER BY city;

SELECT city, state
FROM sales.customers
ORDER BY city, state;

SELECT DISTINCT city, state
FROM sales.customers
ORDER BY city, state;

SELECT DISTINCT phone
FROM sales.customers
ORDER BY phone;

-- DISTINCT vs. GROUP BY

SELECT city, state
FROM sales.customers
GROUP BY city, state
ORDER BY city, state;

SELECT DISTINCT city, state
FROM sales.customers

-- Single line comment
/*
SELECT
    select_list
FROM
    table_name
WHERE
    search_condition;

 NOTE: search_condition can have 
 1. OPERAToR LIKE <,>, <>/!=, IN, LIKE
 2. LOGICAL OPERATORS AND, OR, NOT,
*/

SELECT 
	product_id,
	product_name,
	model_year,
	list_price,
	category_id
FROM production.products
WHERE list_price IN (2799.99, 1799.99, 899.99) 
ORDER BY list_price DESC


SELECT 
	product_id,
	product_name,
	model_year,
	list_price,
	category_id
FROM production.products
WHERE product_name LIKE '%Electra%' 
ORDER BY list_price DESC

/*
Symbol	Description
%	Represents zero or more characters
_	Represents a single character
[]	Represents any single character within the brackets *
^	Represents any character not in the brackets *
-	Represents any single character within the specified range *
{}	Represents any escaped character **

Link: https://www.w3schools.com/sql/sql_wildcards.asp
*/

-- alias 

SELECT 
	product_id,
	product_name,
	model_year AS year,
	list_price Product_Price,
	category_id 'Product Category'
FROM production.products

-- OFE --> FROM >>WHERE >>SELECT >> ORDE BY

-- section5: Joining tables

CREATE SCHEMA hr;
go

CREATE TABLE hr.candidates(
	id INT IDENTITY(1,1) PRIMARY KEY,
	fullname VARCHAR(100) NOT NULL
);

CREATE TABLE hr.employees(
	id INT IDENTITY(1,1) PRIMARY KEY,
	fullname VARCHAR(100) NOT NULL
);

INSERT INTO hr.candidates(fullname)
VALUES 
	('John Doe'),
    ('Lily Bush'),
    ('Peter Drucker'),
    ('Jane Doe');

SELECT * FROM hr.candidates;

INSERT INTO 
    hr.employees(fullname)
VALUES
    ('John Doe'),
    ('Jane Doe'),
    ('Michael Scott'),
    ('Jack Sparrow');

SELECT * FROM hr.employees;

-- INNER join

-- LEFT TABLE ==> candidates
-- RIGHT TABLE ==> employees

SELECT 
	c.id,
	c.fullname,
	e.id,
	e.fullname
FROM hr.candidates c
INNER JOIN hr.employees e
ON c.fullname = e.fullname;

-- left join

SELECT 
	c.id,
	c.fullname,
	e.id,
	e.fullname
FROM hr.candidates c
LEFT JOIN hr.employees e
ON c.fullname = e.fullname;

-- right join

SELECT 
	c.id,
	c.fullname,
	e.id,
	e.fullname
FROM hr.candidates c
RIGHT JOIN hr.employees e
ON c.fullname = e.fullname;

-- outer/full join

SELECT 
	c.id,
	c.fullname,
	e.id,
	e.fullname
FROM hr.candidates c
FULL JOIN hr.employees e
ON c.fullname = e.fullname;

-- left anti join
SELECT 
	c.id,
	c.fullname,
	e.id,
	e.fullname
FROM hr.candidates c
LEFT JOIN hr.employees e
ON c.fullname = e.fullname
WHERE e.id IS NULL;

-- right anti join
SELECT 
	c.id,
	c.fullname,
	e.id,
	e.fullname
FROM hr.candidates c
RIGHT JOIN hr.employees e
ON c.fullname = e.fullname
WHERE c.id IS NULL;

-- cross jon
-- a = (1,2,3,)
-- b = (a,b,c)
-- axb = (1,a)(1,b)(1,c).....

CREATE DATABASE testing;
go

USE testing;
go

CREATE SCHEMA cross_join;
go

CREATE TABLE cross_join.Meals(MealName VARCHAR(100));
CREATE TABLE cross_join.Drinks(DrinkName VARCHAR(100));

INSERT INTO cross_join.Drinks
VALUES('Orange Juice'), ('Tea'), ('Cofee');

INSERT INTO cross_join.Meals
VALUES('Omlet'), ('Fried Egg'), ('Sausage');

SELECT *
FROM cross_join.Meals;

SELECT *
FROM cross_join.Drinks;

SELECT *
FROM cross_join.Meals
CROSS JOIN cross_join.Drinks;

/*
HOMEWORK
1- Wild cards -- PPT
2- SELF JOIN
3- JOINS practice on pandas joins tables
*/
