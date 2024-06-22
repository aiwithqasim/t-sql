-- verify version
SELECT @@VERSION;

-- use created database
USE BikeStores;

-- SECTION 01: Querying Data
SELECT * FROM sales.customers;
SELECT first_name FROM sales.customers;
SELECT first_name, last_name FROM sales.customers;

-- SELECT with filter
SELECT * FROM sales.customers WHERE state = 'NY';

-- SELECT with fiter & order
SELECT * 
FROM sales.customers 
WHERE state = 'NY' 
ORDER BY first_name;

-- SELECT with fiter , order, groupby
SELECT City, count(*) AS city_count
FROM sales.customers 
WHERE state = 'NY' 
GROUP BY City
HAVING count(*) > 10;

-- Execution Plan 
-- FROM >> WHERE >> GROUP BY >> HAVING >> SELECT >> ORDER BY

-- SECTION 02: SORTNG DATA

SELECT *
FROM sales.customers
ORDER BY first_name; -- by default ASC

SELECT *
FROM sales.customers
ORDER BY first_name DESC;

SELECT *
FROM sales.customers
ORDER BY first_name, last_name ;

SELECT *
FROM sales.customers
ORDER BY first_name ASC, last_name DESC;

-- FROM >> SELECT >> ORDER BY 
SELECT first_name, last_name
FROM sales.customers
ORDER BY  1, 2; -- NOT A BEST PRACTICE

SELECT *
FROM sales.customers
ORDER BY LEN(first_name);

-- SECTION-03: LIMITING DATA
-- OFFSET --> how mcuh portion e want to skip
-- FETCH --> How much rows d you want
-- FETCH is alwasy used with OFFSET, without it error will be raised
-- OFFSET/FETCH have a limitation i:e., they can be used only with ORDER BY
SELECT * 
FROM sales.customers
ORDER BY first_name
OFFSET 10 ROWS;

-- skip first 10 rows & fetch next 10 rows
SELECT * 
FROM sales.customers
ORDER BY first_name
OFFSET 10 ROWS
FETCH FIRST 10 ROWS ONLY;

-- skip 0 rows & fecth first 10 rows
SELECT * 
FROM sales.customers
ORDER BY first_name
OFFSET 0 ROWS
FETCH FIRST 10 ROWS ONLY;

-- TOP
SELECT TOP 5 * 
FROM sales.customers;

-- 1445
SELECT TOP 1 PERCENT * 
FROM sales.customers;

-- TOP
SELECT TOP 2 WITH TIES*
FROM sales.customers
ORDER BY state;