-- SECTION - 12 DDL Data Definition Lnguage

-- method-1
CREATE DATABASE testDB;

SELECT name
FROM sys.databases
ORDER BY name;

-- method-2
--> Databases >> New Database >> <db_name> >> OK

/* SQL Server DROP DATABASE

Syntax:
-------
DROP DATABASE  [ IF EXISTS ]
    database_name 
    [,database_name2,...];
*/

DROP DATABASE sampleDB;
DROP DATABASE IF EXISTS testing;
DROP DATABASE IF EXISTS class5;

-- method-2
--> Database(db_name) >> Delete >> restore uncheck AND check close connection >> OK

-- SQL Server CREATE SCHEMA

/*
CREATE SCHEMA schema_name
    [AUTHORIZATION owner_name]
*/

CREATE SCHEMA customer_services;
GO

-- Method-1
--> Db_name >> Security >> Schema >> you'll fid name there

-- method -2

SELECT *
FROM sys.schemas

SELECT *
FROM sys.sysusers;

-- TASK: Which Schema is in which database?
select 
	s.name,
	i.name
from sys.schemas s
inner join sys.sysusers i
	on i.uid = s.principal_id
order by s.name;

CREATE TABLE customer_services.jobs(
    job_id INT PRIMARY KEY IDENTITY,
    customer_id INT NOT NULL,
    description VARCHAR(200),
    created_at DATETIME2 NOT NULL
);

-- SQL Server ALTER SCHEMA

CREATE TABLE dbo.offices(
    office_id INT PRIMARY KEY IDENTITY, 
    office_name NVARCHAR(40) NOT NULL, 
    office_address NVARCHAR(255) NOT NULL, 
    phone  VARCHAR(20),
);

/*
ALTER SCHEMA target_schema_name   
    TRANSFER [ entity_type :: ] securable_name;
*/

ALTER SCHEMA sales
TRANSFER OBJECT::dbo.offices;

INSERT INTO 
    sales.offices(office_name, office_address)
VALUES
    ('Silicon Valley','400 North 1st Street, San Jose, CA 95130'),
    ('Sacramento','1070 River Dr., Sacramento, CA 95820');

-- SQL Server DROP SCHEMA

DROP SCHEMA customer_services;

/*
Msg 3729, Level 16, State 1, Line 91
Cannot drop schema 'customer_services' because it is being referenced by object 'jobs'.
*/

DROP TABLE customer_services.jobs;
DROP SCHEMA customer_services;

/*
SQL Server CREATE TABLESQL Server CREATE TABLE

Syntax:
-------
CREATE TABLE [database_name.][schema_name.]table_name (
    pk_column data_type PRIMARY KEY,
    column_1 data_type NOT NULL,
    column_2 data_type,
    ...,
    table_constraints
);

IDENTITY[(seed,increment)]

*/

CREATE TABLE sales.visits (
    visit_id INT PRIMARY KEY IDENTITY (1, 1),
    first_name VARCHAR (50) NOT NULL,
    last_name VARCHAR (50) NOT NULL,
    visited_at DATETIME,
    phone VARCHAR(20),
    store_id INT NOT NULL,
    FOREIGN KEY (store_id) REFERENCES sales.stores (store_id)
);

-- SQL Server Sequence

/*
python: range 
sql: identity
sql: sequence

identity vs sequence
1- multiple tables --> seq otheriwse --> identity
2- The application requires to restart 
the number when a specified value is reached.

CREATE SEQUENCE [schema_name.] sequence_name  
    [ AS integer_type ]  
    [ START WITH start_value ]  
    [ INCREMENT BY increment_value ]  
    [ { MINVALUE [ min_value ] } | { NO MINVALUE } ]  
    [ { MAXVALUE [ max_value ] } | { NO MAXVALUE } ]  
    [ CYCLE | { NO CYCLE } ]  
    [ { CACHE [ cache_size ] } | { NO CACHE } ];

*/

CREATE SEQUENCE item_counter
	AS INT
	START WITH 10
	INCREMENT BY 10;

SELECT NEXT VALUE FOR item_counter;

-- EXAMPLE: Will be creating a table & 
-- then insering values using sequence

CREATE SCHEMA procurement;
GO

CREATE TABLE procurement.purchase_orders(
    order_id INT PRIMARY KEY,
    vendor_id int NOT NULL,
    order_date date NOT NULL
);

CREATE SEQUENCE procurement.order_number 
AS INT
START WITH 1
INCREMENT BY 1;

INSERT INTO procurement.purchase_orders
    (order_id,
    vendor_id,
    order_date)
VALUES
    (NEXT VALUE FOR procurement.order_number,1,'2019-04-30');

SELECT * 
FROM procurement.purchase_orders;

INSERT INTO procurement.purchase_orders
    (order_id,
    vendor_id,
    order_date)
VALUES
    (NEXT VALUE FOR procurement.order_number,2,'2019-05-01');


INSERT INTO procurement.purchase_orders
    (order_id,
    vendor_id,
    order_date)
VALUES
    (NEXT VALUE FOR procurement.order_number,3,'2019-05-02');

SELECT * 
FROM procurement.purchase_orders;

-- Example: using sequene while creating tables

CREATE SEQUENCE procurement.receipt_no
START WITH 1
INCREMENT BY 1;

CREATE TABLE procurement.invoice_receipts(
    receipt_id INT PRIMARY KEY
    DEFAULT (NEXT VALUE FOR procurement.receipt_no), 
    order_id INT NOT NULL, 
    is_late BIT NOT NULL,
    receipt_date DATE NOT NULL,
    note NVARCHAR(100)
);

INSERT INTO procurement.invoice_receipts(
    order_id, 
    is_late,
    receipt_date,
    note
)
VALUES(1,0,'2019-05-13','Invoice duly received');

INSERT INTO procurement.invoice_receipts(
    order_id, 
    is_late,
    receipt_date,
    note
)
VALUES(2,0,'2019-05-15','Invoice duly received');

SELECT * 
FROM procurement.invoice_receipts;

/*
SQL Server ALTER TABLE ADD Column

Syntax:
-------
ALTER TABLE table_name
ADD column_name data_type column_constraint
    column_name_2 data_type_2 column_constraint_2,
    ...,
    column_name_n data_type_n column_constraint_n;
*/

ALTER TABLE procurement.invoice_receipts
ADD query_date DATE;

SELECT * 
FROM procurement.invoice_receipts;

/*
SQL Server ALTER TABLE ALTER COLUMN

syntax:
-------
ALTER TABLE table_name 
ALTER COLUMN column_name new_data_type(size);
*/

ALTER TABLE procurement.invoice_receipts
ALTER COLUMN query_date DATETIME;

/*
SQL Server ALTER TABLE DROP COLUMN

syntax:
-------
ALTER TABLE table_name
DROP COLUMN column_name_1, column_name_2,...;

*/

ALTER TABLE procurement.invoice_receipts
DROP COLUMN query_date;

/*
SQL Server Computed Columns
*/

CREATE TABLE persons(
    person_id  INT PRIMARY KEY IDENTITY, 
    first_name NVARCHAR(100) NOT NULL, 
    last_name  NVARCHAR(100) NOT NULL, 
    dob        DATE
);

INSERT INTO 
    persons(first_name, last_name, dob)
VALUES
    ('John','Doe','1990-05-01'),
    ('Jane','Doe','1995-03-01');


SELECT
    person_id,
    first_name + ' ' + last_name AS full_name,
    dob
FROM
    persons
ORDER BY
    full_name;

ALTER TABLE persons
ADD full_name AS (first_name + ' ' + last_name);

ALTER TABLE persons
DROP COLUMN full_name;

ALTER TABLE persons
ADD full_name AS (first_name + ' ' + last_name) PERSISTED;

select * from persons;

ALTER TABLE persons
ADD age_in_years 
    AS (CONVERT(INT,CONVERT(CHAR(8),GETDATE(),112))-CONVERT(CHAR(8),dob,112))/10000;

/*
deterministi: those values that don't changes over time eg: full_name
non-deterministic: those values that changes over time eg: date
*/

select * from persons;

TRUNCATE TABLE persons;
DROP TABLE persons;


/*
SQL Server SELECT INTO

- Need table reference
- automatically create the DDL as per reference table

syntax:
-------
SELECT 
    select_list (columns)
INTO 
    destination -- automatically create ddl
FROM 
    source -- reference table
[WHERE condition]
*/

CREATE SCHEMA marketing;
GO

SELECT *
INTO marketing.customers
FROM sales.customers;

SELECT * FROM marketing.customers;

-- Example2: selecting data from one database & dumping it to another

SELECT    
    customer_id, 
    first_name, 
    last_name, 
    email
INTO testDB.marketing.customers -- fully qalified
FROM sales.customers -- fully qualifies path not neessary
WHERE state = 'CA';

SELECT * 
FROM testDB.marketing.customers;

/*
SQL Server Rename Table

limitation: sql server didn'y support rename directly

syntax:
-------
EXEC sp_rename 'old_table_name', 'new_table_name'
*/

CREATE TABLE sales.contr (
    contract_no INT IDENTITY PRIMARY KEY,
    start_date DATE NOT NULL,
    expired_date DATE,
    customer_id INT,
    amount DECIMAL (10, 2)
); 

-- methods -1
EXEC sp_rename 'sales.contracts', 'contr';

--methods -2 GUI
-- goto table & then rename it.

-- Caution: Changing any part of an object 
-- name could break scripts and 
-- stored procedures.

/*
SQL Server Temporary Tables

1- temporary tables
2- global temporary tables

syntax:
-------

SELECT 
    select_list
INTO 
    #temporary_table (must started with #)
FROM 
    table_name
....

*/

-- temporary tables using SELECT INTO
SELECT    
    customer_id, 
    first_name, 
    last_name, 
    email
INTO  #temporary_table
FROM sales.customers
WHERE state = 'CA';

SELECT * 
FROM #temporary_table;

-- temporary table using  CREATE STATEMENT

CREATE TABLE #haro_products (
    product_name VARCHAR(MAX),
    list_price DEC(10,2)
);

INSERT INTO #haro_products
SELECT product_name,list_price
FROM production.products
WHERE brand_id = 2;

SELECT *
FROM #haro_products;

-- Global temporary tables

CREATE TABLE ##heller_products (
    product_name VARCHAR(MAX),
    list_price DEC(10,2)
);

INSERT INTO ##heller_products
SELECT
    product_name,
    list_price
FROM 
    production.products
WHERE
    brand_id = 3;

DROP TABLE ##heller_products;

/*
SQL Server Synonym

syntax:
-------

CREATE SYNONYM [ schema_name_1. ] synonym_name 
FOR object;

object can be:

[ server_name.[ database_name ] . [ schema_name_2 ]. object_name   

*/


CREATE SYNONYM contracts
FOR [BikeStores].[sales].[contracts];

select * from contracts;

CREATE SYNONYM orders FOR sales.orders;

select * from orders;

select name, base_object_name
from sys.synonyms

DROP SYNONYM IF EXISTS orders;

/* Section 13

-- BIT ( 1 or 0)
-- VARCHAR
-- DECIMAL
-- INT
-- DATE
-- TIME
-- DATETIME
-- CHAR
*/

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

create table production.categories (
category_id int primary key not null Identity(1,1),
category_name varchar(200) Unique not null
);


create table production.brand(
brand_id int primary key Identity(1,1),
brand_name varchar(255) Unique not null
);

create table production.products(
product_id int primary key Identity(1,1),
product_name varchar(200) Unique not null,
brand_id int not null,
category_id int not null,
model_year smallint not null,
list_price decimal not null ,
Foreign key (brand_id) references production.brand (brand_id),
Foreign key (category_id) references production.categories(category_id),
check (model_year >= 1900 and model_year<= getdate()),
check(list_price > 0)
);

/*
Section 15. Expressions

SQL Server CASE

syntax:
------
CASE [input]  
    WHEN e1 THEN r1
    WHEN e2 THEN r2
    ...
    WHEN en THEN rn
    [ ELSE re ]   
END  

*/

-- Using simple CASE expression in the SELECT clause example

select 
	order_status,
	count(order_id) orders_count
from sales.orders
group by order_status
order by order_status;

select 
	CASE order_status
		WHEN 1 THEN 'Pending'
		WHEN 2 THEN 'Processing'
		WHEN 3 THEN 'Rejected'
		WHEN 4 THEN 'Completd'
	END as order_status,
	count(order_id) as order_count
from sales.orders
group by order_status
order by order_status;

-- wihtout groupby using SUM(CASE ..END)

select SUM(
	CASE 
		WHEN order_status = 1
		THEN 1
		ELSE 0
	END) as 'Pending',
	SUM(
	CASE
		WHEN order_status = 2
		THEN 1
		ELSE 0
	END) as 'Processing',
	SUM(
	CASE
		WHEN order_status = 3
		THEN 1
		ELSE 0
	END) as 'Rejected',
	SUM(
	CASE
		WHEN order_status = 4
		THEN 1
		ELSE 0
	END) as 'Completed',
	COUNT(*) as Total
from sales.orders
where year(order_date) = 2018;

-- TASK: Important order in pending or processing stage
--> year 2018
--> order _status 1 & 2
--> order_id (quantiy * list_price = Value)
--> 5000 'Very Value Low', 10000 "Fair Oder"
--> 20000 'Aerage Order', 20000> "High Value Order"

/*
1---10,000 as student_id

student_id BETWEEN 400 and 700
*/

select 
	o.order_id,
	SUM(i.quantity * i.list_price) 'order_value',
	CASE
		WHEN SUM(i.quantity * i.list_price) > 20000 THEN 'High Value Order'
		WHEN SUM(i.quantity * i.list_price) < 20000 and
			SUM(i.quantity * i.list_price) >= 10000 THEN 'Average Order'
		WHEN SUM(i.quantity * i.list_price) < 10000 and
			SUM(i.quantity * i.list_price) >= 5000 THEN 'Fair Oder'
		WHEN SUM(i.quantity * i.list_price) < 5000 THEN 'Low Value Oder'
	END as 'priority'
from sales.orders o
inner join sales.order_items i
on o.order_id = i.order_id
where year(o.order_date) = 2018 and order_status IN (1,2)
group by o.order_id
order by SUM(i.quantity * i.list_price) desc;



select 
	o.order_id,
	SUM(i.quantity * i.list_price) 'order_value',
	CASE
		WHEN SUM(i.quantity * i.list_price) >= 20000 THEN 'High Value Order'
		WHEN SUM(i.quantity * i.list_price) BETWEEN  10000 and 20000 THEN 'Average Order'
		WHEN SUM(i.quantity * i.list_price) BETWEEN 5000 and 10000 THEN 'Fair Oder'
		WHEN SUM(i.quantity * i.list_price) BETWEEN 0 and 5000 THEN 'Low Value Oder'
	END as 'priority'
from sales.orders o
inner join sales.order_items i
on o.order_id = i.order_id
where year(o.order_date) = 2018 and ((o.order_status =1) or (o.order_status = 2))
group by o.order_id
order by SUM(i.quantity * i.list_price) desc;

/*
SQL Server COALESCE

-- returns the first non-null argument.

COALESCE(e1,[e2,...,en])

*/

select coalesce(null, null, 10, 20, null);
select coalesce(null, null, 'Hello', 'Hi', null);

-- Using SQL Server COALESCE expression to substitute NULL by new values

SELECT first_name,
		last_name,
		coalesce(phone, 'N/A'),
		email
FROM sales.customers
ORDER BY first_name, last_name;

-- Using SQL Server COALESCE expression to use the available data

CREATE TABLE salaries (
    staff_id INT PRIMARY KEY,
    hourly_rate decimal,
    weekly_rate decimal,
    monthly_rate decimal,
    CHECK(
        hourly_rate IS NOT NULL OR 
        weekly_rate IS NOT NULL OR 
        monthly_rate IS NOT NULL)
);

INSERT INTO 
    salaries(
        staff_id, 
        hourly_rate, 
        weekly_rate, 
        monthly_rate
)VALUES
    (1,20, NULL,NULL),
    (2,30, NULL,NULL),
    (3,NULL, 1000,NULL),
    (4,NULL, NULL,6000),
    (5,NULL, NULL,6500);

select * from salaries;

-- TASK: we don't want null values in monthly_rate column

--COALESCE(e1,[e2,...,en])
select 
	staff_id, 
    hourly_rate, 
    weekly_rate, 
    coalesce(hourly_rate*22*8, weekly_rate*4, monthly_rate) as monthly_rates
from salaries

/*
COALESCE vs. CASE expression

COALESCE expression is a syntactic sugar of the CASE expression.

COALESCE(e1,e2,e3)

CASE
    WHEN e1 IS NOT NULL THEN e1
    WHEN e2 IS NOT NULL THEN e2
    ELSE e3
END


SQL Server NULLIF

NULLIF expression accepts two arguments and
returns NULL if two arguments are equal.
Otherwise, it returns the first expression.

syntax:
------
NULLIF(expression1, expression2)

*/

select NULLIF(10, 10) result;
select NULLIF(20, 10) result;

SELECT NULLIF('Hello', 'Hello') result;

SELECT NULLIF('Hello', 'Hi') result;

-- Using NULLIF expression to translate a blank string to NULL

CREATE TABLE sales.leads(
    lead_id    INT	PRIMARY KEY IDENTITY, 
    first_name VARCHAR(100) NOT NULL, 
    last_name  VARCHAR(100) NOT NULL, 
    phone      VARCHAR(20), 
    email      VARCHAR(255) NOT NULL
);

INSERT INTO sales.leads
(
    first_name, 
    last_name, 
    phone, 
    email
)
VALUES
(
    'John', 
    'Doe', 
    '(408)-987-2345', 
    'john.doe@example.com'
),
(
    'Jane', 
    'Doe', 
    '', 
    'jane.doe@example.com'
),
(
    'David', 
    'Doe', 
    NULL, 
    'david.doe@example.com'
);

select * from sales.leads;
select * from sales.leads where phone IS NULL;

-- NULLIF('', '') --> NULL
-- NNULLIF(NULL, '') --> NULL
select * 
from sales.leads 
where NULLIF(phone, '') IS NULL;

DECLARE @a int = 10, @b int = 10;

SELECT 
CASE 
    WHEN @a=@b THEN NULL 
    ELSE @a 
END;

DECLARE @c int = 20, @d int = 20;
SELECT
    NULLIF(@c,@d) AS result;

