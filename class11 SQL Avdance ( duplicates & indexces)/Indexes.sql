CREATE TABLE production.parts(
    part_id  INT NOT NULL, 
    part_name VARCHAR(100),
);

INSERT INTO 
    production.parts(part_id, part_name)
VALUES
    (1,'Frame'),
    (2,'Head Tube'),
    (3,'Handlebar Grip'),
    (4,'Shock Absorber'),
    (5,'Fork');

-- No Primary Key (PK), stored rows in unordered structure called HEAP
-- So, Wheen Query  --> Query optimizer needs to scan the whole table to search.

SELECT 
    part_id, 
    part_name
FROM 
    production.parts
WHERE 
    part_id = 5; 
	
-- query fast b/c five rows only
-- Think if have 10M rows, it will ultimately be slow

/*
To resolve this issue, SQL Server provides a dedicated structure 
to speed up the retrieval of rows from a table called INDEX.
 
SQL Server provides two types of indexes: 
1- clustered index: A clustered index stores data rows in a sorted structure based on its key values.  
2- non-clustered index:
*/

-- SQL Server Clustered Index and Primary Key Constraint

CREATE TABLE production.part_prices(
    part_id int,
    valid_from date,
    price decimal(18,4) not null,
    PRIMARY KEY(part_id, valid_from) 
);

/*
If you add a primary key constraint to an existing table that 
already has a clustered index, SQL Server will enforce the 
primary key using a non-clustered index:

ALTER TABLE production.parts
ADD PRIMARY KEY(part_id);

*/

-- add above commented line here

/*
Using SQL Server CREATE CLUSTERED INDEX statement to create a clustered index

SYNTAX:
-------
CREATE CLUSTERED INDEX index_name
ON schema_name.table_name (column_list);  */

CREATE CLUSTERED INDEX ix_parts_id
ON production.parts (part_id);  

/* executing same query on clustered index table
SQL Server traverses the index (Clustered Index Seek) to locate the rows, 
which is faster than scanning the whole table
*/

SELECT 
    part_id, 
    part_name
FROM 
    production.parts
WHERE 
    part_id = 5;

----------------------------
-- SQL Server CREATE INDEX
----------------------------

-- Syntax of Non Clustered Index
--  NONCLUSTERED Optional keyword

/* CREATE [NONCLUSTERED] INDEX index_name
ON table_name(column_list); */


SELECT 
    customer_id, 
    city
FROM 
    sales.customers
WHERE
	city = 'Atwater';

CREATE INDEX ix_customers_city
ON sales.customers(city);

SELECT 
    customer_id, 
    city
FROM 
    sales.customers
WHERE 
    city = 'Atwater';



CREATE INDEX ix_customers_name 
ON sales.customers(last_name, first_name);


SELECT 
    customer_id, 
    first_name, 
    last_name
FROM 
    sales.customers
WHERE 
    last_name = 'Berg' AND 
    first_name = 'Monika';



-- Renaming an index using the system stored procedure sp_rename
/*
Syntax

EXEC sp_rename 
    index_name, 
    new_index_name, 
    N'INDEX';  
 or 

 EXEC sp_rename 
    @objname = N'index_name', 
    @newname = N'new_index_name',   
    @objtype = N'INDEX';
	
*/


EXEC sp_rename 
        @objname = N'sales.customers.ix_customers_city',
        @newname = N'ix_cust_city' ,
        @objtype = N'INDEX';


-- Disable Index statements
/* 

ALTER INDEX index_name
ON table_name
DISABLE;

*/

ALTER INDEX ix_cust_city 
ON sales.customers 
DISABLE;


SELECT    
    city
FROM    
    sales.customers
WHERE 
    city = 'San Jose';


--Enable index using ALTER INDEX and CREATE INDEX statements
/*
 This statement uses the ALTER INDEX statement to “enable” or rebuild an index on a table:

ALTER INDEX index_name 
ON table_name  
REBUILD;

This statement uses the CREATE INDEX statement to enable the disabled index and recreate it:

CREATE INDEX index_name 
ON table_name(column_list)
WITH(DROP_EXISTING=ON)
*/

-- unique index
/*
CREATE UNIQUE INDEX index_name
ON table_name(column_list);
*/

SELECT
    customer_id, 
    email 
FROM
    sales.customers
WHERE 
    email = 'caren.stephens@msn.com';

CREATE UNIQUE INDEX ix_cust_email 
ON sales.customers(email);


--DROP INDEX statement	

/*
DROP INDEX [IF EXISTS] index_name
ON table_name;
*/
DROP INDEX IF EXISTS ix_cust_email
ON sales.customers;
