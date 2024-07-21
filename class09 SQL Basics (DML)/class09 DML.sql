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

