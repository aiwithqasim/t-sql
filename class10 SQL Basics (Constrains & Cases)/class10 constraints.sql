/*
Section 14. Constraints
-------------------------
1- PRIMARY KEY
2- FOREIGN KEY
3- NOT NULL
4- UNIQUE
5- CHECK

*/

CREATE SCHEMA production;
GO

DROP TABLE IF EXISTS production.categories;
DROP TABLE IF EXISTS production.brands;
DROP TABLE IF EXISTS production.products;

CREATE TABLE production.categories (
    category_id INT IDENTITY (1, 1) PRIMARY KEY,
    category_name VARCHAR (255) NOT NULL UNIQUE
);

CREATE TABLE production.brands (
    brand_id INT IDENTITY (1, 1) PRIMARY KEY,
    brand_name VARCHAR (255) NOT NULL UNIQUE
);

CREATE TABLE production.products (
    product_id INT IDENTITY (1, 1) PRIMARY KEY,
    product_name VARCHAR (255) NOT NULL UNIQUE,
    brand_id INT NOT NULL,
    category_id INT NOT NULL,
    model_year SMALLINT NOT NULL,
    list_price DECIMAL (10, 2) NOT NULL,
    FOREIGN KEY (category_id) REFERENCES production.categories (category_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (brand_id) REFERENCES production.brands (brand_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CHECK (model_year >= 1900 AND model_year <= YEAR(GETDATE())),
    CHECK (list_price > 0)
);

/*
Section 15. Expressions

Syntax:
-------
CASE input   
    WHEN e1 THEN r1
    WHEN e2 THEN r2
    ...
    WHEN en THEN rn
    [ ELSE re ]   
END  
*/

select order_status, count(order_id) order_count
from sales.orders
where YEAR(order_date) = 2018
GROUP BY order_status;


select
	CASE order_status
		WHEN 1 THEN 'Pending'
		WHEN 2 THEN 'Processing'
		WHEN 3 THEN 'Rejected'
		WHEN 4 THEN 'Completed'
	END AS order_status,
	COUNT(order_id) as order_count
from sales.orders
where year(order_date) = 2018
group by order_status;

-- Using simple CASE expression in aggregate function example
select sum(order_status)
from sales.orders
where order_status=1;

select 
	sum(case
			when order_status = 1
			then 1
			else 0
		end) as 'Pending',
	sum(case
			when order_status = 2
			then 1
			else 0
		end) as 'Processing',
	sum(case
			when order_status = 3
			then 1
			else 0
		end) as 'Rejected',
	sum(case
			when order_status = 4
			then 1
			else 0
		end) as 'Completed',
	COUNT(*) as Total
from sales.orders
where year(order_date) = 2018;

-- Using searched CASE expression in the SELECT clause

select O.order_id,
	SUM(i.quantity * i.list_price) order_value,
	CASE 
		WHEN SUM(i.quantity * i.list_price) <= 500
		THEN 'Very Low'
		WHEN SUM(quantity * list_price) > 500 AND 
            SUM(quantity * list_price) <= 1000 
            THEN 'Low'
        WHEN SUM(quantity * list_price) > 1000 AND 
            SUM(quantity * list_price) <= 5000 
            THEN 'Medium'
        WHEN SUM(quantity * list_price) > 5000 AND 
            SUM(quantity * list_price) <= 10000 
            THEN 'High'
        WHEN SUM(quantity * list_price) > 10000 
            THEN 'Very High'
	END AS order_priority
from sales.orders O
inner join sales.order_items i
on O.order_id = i.order_id
where year(O.order_date) = 2018
group by o.order_id;

/*
SQL Server COALESCE

COALESCE expression accepts a number of arguments,
evaluates them in sequence, and returns the
first non-null argument.

syntax:
-------
COALESCE(e1,[e2,...,en])

*/

SELECT COALESCE(NULL, 'Saylani', 'Welfare', NULL) result;

SELECT COALESCE(NULL, NULL, 100, 200) result;


-- Using SQL Server COALESCE expression to substitute NULL by new values

select first_name, last_name, phone, email
from sales.customers
order by first_name, last_name;

select  first_name,
		last_name,
		COALESCE(phone, 'N/A'),
		email
from sales.customers
order by first_name, last_name;

-- Using SQL Server COALESCE expression to use the available data

create table salaries(
	staff_id int primary key,
	hourly_rate decimal,
	weekly_rate decimal,
	monthly_rate decimal,
	check(
		hourly_rate is not null or
		weekly_rate is not null or 
		monthly_rate is not null
));

insert into salaries (
	staff_id,
	hourly_rate,
	weekly_rate,
	monthly_rate)
values
    (1,20, NULL,NULL),
    (2,30, NULL,NULL),
    (3,NULL, 1000,NULL),
    (4,NULL, NULL,6000),
    (5,NULL, NULL,6500);

-- should have null values
select staff_id,
	   hourly_rate,
	   weekly_rate,
	   monthly_rate
from salaries
order by staff_id;

-- monthly salary calcualting
select staff_id,
	coalesce(
	hourly_rate*22*8,
	weekly_rate*4,
	monthly_rate) monhtly_salary
from salaries;

-- COALESCE vs. CASE expression

/*
COALESCE expression is a syntactic sugar of the CASE expression.

syntax:
-------
COALESCE(e1,e2,e3)

"""
CASE
    WHEN e1 IS NOT NULL THEN e1
    WHEN e2 IS NOT NULL THEN e2
    ELSE e3
END
"""

Note:
----
that the query optimizer may use the CASE
expression to rewrite the COALESCE expression.

SQL Server NULLIF

NULLIF expression accepts two arguments and 
returns NULL if two arguments are equal. 
Otherwise, it returns the first expression.

syntax:
--------

NULLIF(expression1, expression2)

*/

-- for numbers
select nullif(10,10) result;
select nullif(20,10) result;

-- for characters
select nullif('Hello', 'Hello') result;
select nullif('Hello', 'Hi') result;

-- Using NULLIF expression to translate a blank string to NULL
CREATE TABLE sales.leads(
    lead_id INT	PRIMARY KEY IDENTITY, 
    first_name VARCHAR(100) NOT NULL, 
    last_name VARCHAR(100) NOT NULL, 
    phone VARCHAR(20), 
    email VARCHAR(255) NOT NULL
);


INSERT INTO sales.leads(
    first_name, 
    last_name, 
    phone, 
    email)
VALUES
('John', 'Doe', '(408)-987-2345', 'john.doe@example.com'),
('Jane', 'Doe', '', 'jane.doe@example.com'),
('David', 'Doe', NULL, 'david.doe@example.com');

SELECT 
    lead_id, 
    first_name, 
    last_name, 
    phone, 
    email
FROM sales.leads
ORDER BY lead_id;

SELECT    
    lead_id, 
    first_name, 
    last_name, 
    phone, 
    email
FROM  sales.leads
WHERE phone IS NULL;

SELECT    
    lead_id, 
    first_name, 
    last_name, 
    phone, 
    email
FROM  sales.leads
WHERE NULLIF(phone, '') IS NULL;

/*
NULLIF and CASE expression

SELECT 
    NULLIF(a,b)

is equal to 

CASE 
    WHEN a=b THEN NULL 
    ELSE a 
END

CASE expression is verbose while the NULLIF expression
is much shorter and more readable.

*/


DECLARE @a int = 10, @b int = 20;
SELECT NULLIF(@a,@b) AS result;


DECLARE @c int = 10, @d int = 20;
SELECT
    CASE
        WHEN @c = @d THEN null
        ELSE 
            @c
    END AS result;

