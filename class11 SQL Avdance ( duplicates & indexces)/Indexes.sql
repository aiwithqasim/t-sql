/* Indexes are special data structures associated with tables or views that help speed up the query.
 SQL Server provides two types of indexes: clustered index and non-clustered index.*/



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

SELECT 
    part_id, 
    part_name
FROM 
    production.parts
WHERE 
    part_id = 5;

CREATE TABLE production.part_prices(
    part_id int,
    valid_from date,
    price decimal(18,4) not null,
    PRIMARY KEY(part_id, valid_from) 
);


-- Syntax
/*
CREATE CLUSTERED INDEX index_name
ON schema_name.table_name (column_list);  */

CREATE CLUSTERED INDEX ix_parts_id
ON production.parts (part_id);  

SELECT 
    part_id, 
    part_name
FROM 
    production.parts
WHERE 
    part_id = 5;



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
