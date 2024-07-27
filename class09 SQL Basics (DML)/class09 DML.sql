-- Section 12. Data definition

-- SQL Server CREATE DATABASE

CREATE DATABASE testDB;

SELECT name 
FROM master.sys.databases 
ORDER BY name;

--> Databases >> New Database >> Database Name (procide name >> OK

-- SQL Server DROP DATABASE

/*
NOTE: make sure database is not getting used other wise

Msg 3702, Level 16, State 3, Line 12
Cannot drop database "sampleDB" because it is currently in use.
*/

DROP DATABASE IF EXISTS sampleDB;

--> select DB >> Delete >> unckeck first, check second >> OK

/* SQL Server CREATE SCHEMA

Synatx:
CREATE SCHEMA schema_name
    [AUTHORIZATION owner_name]

*/

CREATE SCHEMA customer_services;
GO

--> testDB >> Security >> Schemas >> you'll have schema there

SELECT
	s.name schema_name,
	u.name schema_owner
FROM sys.schemas s
INNER JOIN sys.sysusers u
	ON u.uid = s.principal_id
ORDER BY s.name;

CREATE TABLE customer_services.jobs(
    job_id INT PRIMARY KEY IDENTITY,
    customer_id INT NOT NULL,
    description VARCHAR(200),
    created_at DATETIME2 NOT NULL
);

/*
SQL Server ALTER SCHEMA
*/

CREATE TABLE dbo.offices(
    office_id INT PRIMARY KEY IDENTITY, 
    office_name NVARCHAR(40) NOT NULL, 
    office_address NVARCHAR(255) NOT NULL, 
    phone VARCHAR(20),
);

INSERT INTO 
    dbo.offices(office_name, office_address)
VALUES
    ('Silicon Valley','400 North 1st Street, San Jose, CA 95130'),
    ('Sacramento','1070 River Dr., Sacramento, CA 95820');

/*
ALTER SCHEMA target_schema_name   
    TRANSFER [ entity_type :: ] securable_name;
*/

ALTER SCHEMA sales TRANSFER OBJECT::dbo.offices;

-- SQL Server DROP SCHEMA

CREATE SCHEMA logistics;
GO

CREATE TABLE logistics.deliveries(
    order_id INT PRIMARY KEY, 
    delivery_date DATE NOT NULL, 
    delivery_status TINYINT NOT NULL
);

-- DROP SCHEMA [IF EXISTS] schema_name;

DROP SCHEMA IF EXISTS logistics;

/*
Msg 3729, Level 16, State 1, Line 91
Cannot drop schema 'logistics' because it is being referenced by object 'deliveries'.
*/

DROP TABLE logistics.deliveries;
DROP SCHEMA IF EXISTS logistics;

/*
SQL Server CREATE TABLE
SQL Server Identity

Syntax:
-------
CREATE TABLE [database_name.][schema_name.]table_name (
    pk_column data_type PRIMARY KEY,
    column_1 data_type NOT NULL,
    column_2 data_type,
    ...,
    table_constraints
);

IDENTITY (10,10)

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

-- Creating a simple sequence example
CREATE SEQUENCE item_counter
    AS INT
    START WITH 10
    INCREMENT BY 10;

SELECT NEXT VALUE FOR item_counter;

-- Using a sequence object in a single table example

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

-- inserting data using sequence
INSERT INTO procurement.purchase_orders
    (order_id,
    vendor_id,
    order_date)
VALUES
    (NEXT VALUE FOR procurement.order_number,1,'2019-04-30');


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

SELECT 
    order_id, 
    vendor_id, 
    order_date
FROM 
    procurement.purchase_orders;

-- Using a sequence object in multiple tables example

CREATE SEQUENCE procurement.receipt_no
START WITH 1
INCREMENT BY 1;

CREATE TABLE procurement.goods_receipts(
    receipt_id INT PRIMARY KEY 
	DEFAULT (NEXT VALUE FOR procurement.receipt_no), 
    order_id INT NOT NULL, 
    full_receipt BIT NOT NULL,
    receipt_date DATE NOT NULL,
    note NVARCHAR(100),
);


CREATE TABLE procurement.invoice_receipts(
    receipt_id INT PRIMARY KEY
    DEFAULT (NEXT VALUE FOR procurement.receipt_no), 
    order_id INT NOT NULL, 
    is_late BIT NOT NULL,
    receipt_date DATE NOT NULL,
    note NVARCHAR(100)
);

-- inserting data
INSERT INTO procurement.goods_receipts(
    order_id, 
    full_receipt,
    receipt_date,
    note
)
VALUES(1,1,'2019-05-12','Goods receipt completed at warehouse');

INSERT INTO procurement.goods_receipts(
    order_id, 
    full_receipt,
    receipt_date,
    note
)
VALUES(1,0,'2019-05-12','Goods receipt has not completed at warehouse');


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

SELECT * FROM procurement.goods_receipts;
SELECT * FROM procurement.invoice_receipts;

-- getting sequence information

SELECT * 
FROM sys.sequences;

/*
SQL Server ALTER TABLE ADD Column

Syntax:
-------
ALTER TABLE table_name
ADD column_name data_type column_constraint;
    column_name_2 data_type_2 column_constraint_2,
    ...,
    column_name_n data_type_n column_constraint_n;

*/

ALTER TABLE procurement.goods_receipts
ADD expire_date DATE;

SELECT * FROM procurement.goods_receipts;

/*
SQL Server ALTER TABLE DROP COLUMN

Syntax:
-------
ALTER TABLE table_name
DROP COLUMN column_name;

*/

ALTER TABLE procurement.goods_receipts
DROP COLUMN expire_date;

SELECT * FROM procurement.goods_receipts;

-- SQL Server Computed Columns

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
FROM  persons
ORDER BY full_name

ALTER TABLE persons
ADD full_name AS (first_name + ' ' + last_name);

ALTER TABLE persons
ADD age_in_years 
    AS (CONVERT(INT,CONVERT(CHAR(8),GETDATE(),112))-CONVERT(CHAR(8),dob,112))/10000;

/*
CREATE TABLE table_name(
...,
column_name AS expression [PERSISTED],
...
);
*/

/*
deterministi (PERSISTED): those values that don't changes over time eg: full_name
non-deterministic: those values that changes over time eg: date
*/

select * from persons;

TRUNCATE TABLE persons;
DROP TABLE persons;

/*
SQL Server SELECT INTO

syntax:
-------
SELECT 
    select_list
INTO 
    destination
FROM 
    source
[WHERE condition]
*/

CREATE SCHEMA marketing;
GO

SELECT * INTO marketing.customers
FROM sales.customers;

SELECT * FROM marketing.customers;

-- Using SQL Server SELECT INTO statement to copy table across databases

SELECT * INTO testDB.dbo.customers
FROM  sales.customers;

select * from testDB.dbo.customers;

/*
SQL Server Rename Table

SQL Server does not have any statement that directly
renames a table. However, it does provide you with a
stored procedure named sp_rename that allows you to 
change the name of a table.

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

EXEC sp_rename 'sales.contr', 'contracts';

/*
Caution: Changing any part of an object name could
break scripts and stored procedures.

SQL Server Temporary Tables (# tables)

*/

SELECT
    product_name,
    list_price
INTO #trek_products --- temporary table
FROM
    production.products
WHERE
    brand_id = 9;


CREATE TABLE #haro_products (
    product_name VARCHAR(MAX),
    list_price DEC(10,2)
);

INSERT INTO #haro_products
SELECT product_name, list_price
FROM production.products
WHERE brand_id = 2;

SELECT * FROM #haro_products;

-- Global temporary tables

CREATE TABLE ##heller_products (
    product_name VARCHAR(MAX),
    list_price DEC(10,2)
);

INSERT INTO ##heller_products
SELECT product_name, list_price
FROM production.products
WHERE brand_id = 3;

DROP TABLE ##heller_products;

/*
SQL Server Synonym

syntax:
-------
CREATE SYNONYM [ schema_name_1. ] synonym_name 
FOR object;

objectform
***********
[ server_name.[ database_name ] . [ schema_name_2 ]. object_name   

*/

CREATE SYNONYM orders FOR sales.orders;

SELECT * FROM orders;

CREATE SCHEMA purchasing;
GO

CREATE TABLE purchasing.suppliers(
    supplier_id   INT
    PRIMARY KEY IDENTITY, 
    supplier_name NVARCHAR(100) NOT NULL
);

CREATE SYNONYM suppliers 
FOR testDB.purchasing.suppliers;

SELECT * FROM suppliers;

--  Listing synonyms using Transact-SQL command

select name, base_object_name
from sys.synonyms
order by name;

-- Removing a synonym
-- DROP SYNONYM [ IF EXISTS ] [schema.] synonym_name  

DROP SYNONYM IF EXISTS suppliers;





