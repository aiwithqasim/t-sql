-- SQL Server MERGE
-- Assume we have SOURCE table s 
-- from where we will pick the data
-- & we have TARGET table t 
-- to where we have to dump data

/*
syntax
-------
MERGE target_table USING source_table
ON merge_condition
WHEN MATCHED
    THEN update_statement
WHEN NOT MATCHED
    THEN insert_statement
WHEN NOT MATCHED BY SOURCE
    THEN DELETE;
*/

-- source --> staging --> target
-- (real-time)--> (temporay data holiding area) --> final destination --> 

CREATE TABLE sales.category (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(255) NOT NULL,
    amount DECIMAL(10 , 2 )
);

INSERT INTO sales.category(category_id, category_name, amount)
VALUES(1,'Children Bicycles',15000),
    (2,'Comfort Bicycles',25000),
    (3,'Cruisers Bicycles',13000),
    (4,'Cyclocross Bicycles',10000);


CREATE TABLE sales.category_staging (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(255) NOT NULL,
    amount DECIMAL(10 , 2 )
);


INSERT INTO sales.category_staging(category_id, category_name, amount)
VALUES(1,'Children Bicycles',15000),
    (3,'Cruisers Bicycles',13000),
    (4,'Cyclocross Bicycles',20000),
    (5,'Electric Bikes',10000),
    (6,'Mountain Bikes',10000);

select * from sales.category;
select * from sales.category_staging;

MERGE sales.category t
USING sales.category_staging s
ON s.category_id = t.category_id
WHEN MATCHED
	THEN UPDATE SET
		t.category_name = s.category_name,
		t.amount = s.amount
WHEN NOT MATCHED 
	THEN INSERT (category_id, category_name, amount)
		VALUES (s.category_id, s.category_name, s.amount)
WHEN NOT MATCHED BY SOURCE
	THEN DELETE;

/*
SQL Server Transaction
1- BEGIN TRANSACTION
2- COMMIT
3- ROLLBACK
-- start -----running ------> ending
*/

CREATE TABLE finance.invoices (
  id int IDENTITY PRIMARY KEY,
  customer_id int NOT NULL,
  total decimal(10, 2) NOT NULL DEFAULT 0 CHECK (total >= 0)
);

CREATE TABLE finance.invoice_items (
  id int,
  invoice_id int  NOT NULL,
  item_name varchar(100) NOT NULL,
  amount decimal(10, 2) NOT NULL CHECK (amount >= 0),
  tax decimal(4, 2) NOT NULL CHECK (tax >= 0),
  PRIMARY KEY (id, invoice_id), -- composite id
  FOREIGN KEY (invoice_id) REFERENCES finance.invoices (id)
	ON UPDATE CASCADE
	ON DELETE CASCADE
);


BEGIN TRANSACTION;

INSERT INTO finance.invoices(customer_id, total)
VALUES (100, 0);

INSERT INTO finance.invoice_items(id, invoice_id, item_name, amount, tax)
VALUES (10, 1, 'Keyboard', 70, 0.08),
       (20, 1, 'Mouse', 50, 0.08);

UPDATE finance.invoices
SET total = (SELECT
  SUM(amount * (1 + tax))
FROM finance.invoice_items
WHERE invoice_id = 1);

COMMIT;

select * from finance.invoices;
select * from finance.invoice_items;

-- rollback
BEGIN TRANSACTION;
INSERT INTO invoice_items (id, invoice_id, item_name, amount, tax)
VALUES (11, 2, 'Keys', 71, 0.01, 11)

ROLLBACK;

-- database
-- schema
-- alter schema  kar lo
-- table bnao
-- add columns using ALTER
-- alter table
-- drop column    
-- schame urao
-- databse urao

