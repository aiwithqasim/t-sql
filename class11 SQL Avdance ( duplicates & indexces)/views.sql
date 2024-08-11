-- SQL Server Views

/*
Query:Returns the product name, brand, and list price of all 
products from the products and brands tables:
*/

SELECT product_name,
	   brand_name,
	   list_price
FROM production.products p
INNER JOIN production.brands b
ON p.brand_id = b.brand_id


/*
Better approach is to create a view

SYNTAX:
-------
CREATE VIEW [OR ALTER] schema_name.view_name [(column_list)]
AS
    select_statement;
*/

CREATE VIEW sales.product_info
AS
SELECT
    product_name, 
    brand_name, 
    list_price
FROM
    production.products p
INNER JOIN production.brands b 
        ON b.brand_id = p.brand_id;

-- simple query
SELECT * FROM sales.product_info;

-- under the hood
SELECT * 
FROM (
    SELECT
        product_name, 
        brand_name, 
        list_price
    FROM
        production.products p
    INNER JOIN production.brands b 
        ON b.brand_id = p.brand_id
) AS subquery_alias;


/*
Benefits:
- A view may consist of columns from multiple tables 
  using joins or just a subset of columns of a single table. 
- This makes views useful for abstracting or 
  hiding complex queries.
*/


-- Daily sales

CREATE VIEW sales.daily_sales
AS
SELECT
	year(o.order_date) as y,
	month(o.order_date) as m,
	day(order_date) As d,
	p.product_id,
	p.product_name,
	(quantity * i.list_price) as sales
FROM sales.orders o
INNER JOIN sales.order_items i
	ON o.order_id = i.order_id
INNER JOIN production.products p
	ON p.product_id = i.product_id;

SELECT 
    * 
FROM 
    sales.daily_sales
ORDER BY
    y, m, d, product_name;

-- Redefining the view & adding customer details

CREATE OR ALTER VIEW sales.daily_sales (
    year,
    month,
    day,
    customer_name,
    product_id,
    product_name,
    sales
)
AS
SELECT
    year(order_date),
    month(order_date),
    day(order_date),
    concat(
        first_name,
        ' ',
        last_name
    ),
    p.product_id,
    product_name,
    quantity * i.list_price
FROM
    sales.orders AS o
    INNER JOIN
        sales.order_items AS i
    ON o.order_id = i.order_id
    INNER JOIN
        production.products AS p
    ON p.product_id = i.product_id
    INNER JOIN sales.customers AS c
    ON c.customer_id = o.customer_id;

SELECT 
    * 
FROM 
    sales.daily_sales
ORDER BY year, month, day, customer_name;

/*
Creating a view using aggregate functions example
--------------------------------------------------
creates a view named staff_salesthose summaries the 
sales by staffs and years using the SUM() aggregate function
*/

CREATE VIEW sales.staff_sales(
	first_name,
	last_name,
	year,
	amount
) AS 
	SELECT 
		first_name,
		last_name,
		YEAR(order_date),
		SUM(list_price * quantity) amount
	FROM sales.order_items i
	INNER JOIN sales.orders o
		ON i.order_id = o.order_id
	INNER JOIN sales.staffs s
		ON s.staff_id = o.staff_id
	GROUP BY 
		first_name,
		last_name,
		YEAR(order_date);
-- query
SELECT  
    * 
FROM 
    sales.staff_sales
ORDER BY 
	first_name,
	last_name,
	year;

-- SQL Server Rename View

-- METHOD-1 (GUI): Databases>>VIEWS>> SELECT >> RENAME

-- METHODD-2 (CODE)
EXEC sp_rename 
    @objname = 'sales.product_info',
    @newname = 'product_catalog';


-- Lisitng Views

SELECT 
	*
FROM 
	sys.views as v;

SELECT 
	OBJECT_SCHEMA_NAME(v.object_id) AS schema_name,
	v.name
FROM 
	sys.views as v;

-- Getting view information

SELECT
    definition
FROM
    sys.sql_modules
WHERE
    object_id
    = object_id(
            'sales.daily_sales'
        );

-- using stored proc
EXEC sp_helptext 'sales.product_catalog' ;

-- Using OBJECT_DEFINITION() function
SELECT 
    OBJECT_DEFINITION(
        OBJECT_ID(
            'sales.staff_sales'
        )
    ) view_info;

/*
SQL Server DROP VIEW

Syntax:
-------
DROP VIEW [IF EXISTS] 
    schema_name.view_name1, 
    schema_name.view_name2,
    ...;
*/

DROP VIEW IF EXISTS sales.daily_sales;

DROP VIEW IF EXISTS 
    sales.staff_sales, 
    sales.product_catalogs;

/*
SQL Server Indexed View


