-- verify version
SELECT @@VERSION;

-- use created database
USE BikeStores;

-----------------------------
-- SECTION 01: Querying Data
-----------------------------

/*
SYNTAX:

SELECT
    select_list
FROM
    schema_name.table_name;
*/

-- 1.1 Using the SQL Server SELECT to retrieve all columns of a table
SELECT * 
FROM sales.customers;

-- OFE => FROM >> SELECT

-- 1.2 Using the SQL Server SELECT to retrieve speific columns
SELECT first_name 
FROM sales.customers;

SELECT first_name, last_name, email 
FROM sales.customers;

-- OFE => FROM >> SELECT

-- 1.2 Using SELECT while Filtering rows using the WHERE clause
SELECT * 
FROM sales.customers 
WHERE state = 'NY';

-- OFE => FROM >> WHERE >> SELECT

-- 1.3 Using SELECT with WHERE for filtering & ORDER BY for sorting
SELECT * 
FROM sales.customers 
WHERE state = 'NY' 
ORDER BY first_name;

-- OFE => FROM >> WHERE >> SELECT >> ORDER BY

-- 1.4 Using SELECT, WHERE, ORDER BY & GROUP BY for Grouping rows into groups
SELECT city, count(*) AS city_count
FROM sales.customers 
WHERE state = 'CA' 
GROUP BY city
ORDER BY city;

-- OFE => FROM >> WHERE >> GRPOUP BY >> SELECT >> ORDER BY

-- 1.5 Using SELECT, WHERE, ORDER BY & GROUP BY for Grouping rows into groups & HAVING Clause
SELECT city, count(*) as cnt
FROM sales.customers
WHERE state = 'NY'
GROUP BY city
HAVING count(*) > 10
ORDER BY city;

-- Execution Plan => FROM >> WHERE >> GROUP BY >> HAVING >> SELECT >> ORDER BY

---------------------------
-- SECTION 02: SORTNG DATA
---------------------------

/*
SYNTAX:

SELECT
    select_list
FROM
    table_name
ORDER BY 
    column_name | expression [ASC | DESC ];
*/

-- 2.1 Sort a result set by one column in ascending order
SELECT *
FROM sales.customers
ORDER BY first_name; -- by default ASC

-- 2.2 Sort a result set by one column in descending order
SELECT *
FROM sales.customers
ORDER BY first_name DESC;

-- 2.3 Sort a result set by multiple columns
SELECT *
FROM sales.customers
ORDER BY first_name, last_name ;

-- 2.4 Sort a result set by multiple columns and different orders
SELECT *
FROM sales.customers
ORDER BY first_name ASC, last_name DESC;

-- 2.5 Sort a result set by a column that is not in the select list

SELECT first_name, last_name, city--, state
FROM sales.customers
ORDER BY state;

-- 2.6 Sort a result set by an expression (aggregated function)
SELECT first_name, last_name
FROM sales.customers
ORDER BY LEN(first_name);

-- 2.7 Sort by ordinal positions of columns 
SELECT first_name, last_name
FROM sales.customers
ORDER BY  1, 2; -- NOT A BEST PRACTICE

-----------------------------
-- SECTION-03: LIMITING DATA
------------------------------

/*

NOTES:
OFFSET/FETCH have a LIMITATION i:e., they must be used only with ORDER BY
	1. OFFSET => How mcuh portion we want to skip
	2. FETCH => How much rows do you want
FETCH is alwasy used with OFFSET, without it error will be raised

SYNTAX:

ORDER BY column_list [ASC |DESC]
OFFSET offset_row_count {ROW | ROWS}
FETCH {FIRST | NEXT} fetch_row_count {ROW | ROWS} ONLY

*/

-- 3.1 Use OFFSET with ORDER BY  to skip first 10 rows
SELECT * 
FROM sales.customers
ORDER BY first_name
OFFSET 10 ROWS;

-- 3.2 Use OFFSET with ORDER BY  to skip first 10 rows & FETCH NEXT 10 ROWS ONLY
SELECT * 
FROM sales.customers
ORDER BY first_name
OFFSET 10 ROWS
FETCH FIRST 10 ROWS ONLY;

-- 3.3 Use OFFSET with ORDER BY  toskip 0 rows & fecth first 10 rows
SELECT * 
FROM sales.customers
ORDER BY first_name
OFFSET 0 ROWS
FETCH FIRST 10 ROWS ONLY;


/*
Syntax TOP:

SELECT TOP (expression) [PERCENT]
    [WITH TIES]
FROM 
    table_name
ORDER BY 
    column_name;

Notes: 
- Can be used without ORDER BY
- When using TOP (expression) WITH TIES, ORDER BY is required
*/

-- 3.5 Using SQL Server SELECT TOP with a constant value i:e, 5
SELECT TOP 5 * 
FROM sales.customers;

-- Using SELECT TOP to return a percentage of rows
-- Totol rows = 1445 
-- So, 1% of 1445 = 14.45 ~15 rows will be return

SELECT TOP 1 PERCENT * 
FROM sales.customers;

-- Using SELECT TOP WITH TIES to include rows that match the values in the last row
SELECT TOP 2 WITH TIES *
FROM sales.customers
ORDER BY state;

-- eg: most expensive products of same TOP price 
SELECT TOP 3 WITH TIES product_name, list_price
FROM production.products
ORDER BY list_price DESC;