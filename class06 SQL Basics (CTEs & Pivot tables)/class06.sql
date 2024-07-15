-- Example 2: A CTE to return the sales amounts by sales staffs in 2018
SELECT 
	first_name + ' ' + last_name as staff,
	SUM(quantity * list_price) as sales,
	YEAR(order_date) as year
FROM sales.orders o
INNER JOIN sales.order_items i ON o.order_id = i.order_id
INNER JOIN sales.staffs s ON o.staff_id = s.staff_id
GROUP BY 
	first_name + ' ' + last_name,
	YEAR(order_date)
HAVING 
	YEAR(order_date) = 2018

-- SQL Server CTEs 
/*
Syntax
------
WITH expression_name[(column_name [,...])]
AS
    (CTE_definition)
SQL_statement;
*/

WITH cte_slaes_amount(staff, sales, year) AS (
	SELECT 
		first_name + ' ' + last_name,
		SUM(quantity * list_price),
		YEAR(order_date)
	FROM sales.orders o
	INNER JOIN sales.order_items i ON o.order_id = i.order_id
	INNER JOIN sales.staffs s ON o.staff_id = s.staff_id
	GROUP BY 
		first_name + ' ' + last_name,
		YEAR(order_date)
)
SELECT staff, sales, year
FROM cte_slaes_amount
WHERE year =2018;

-- Example 2: Write the CTE to return the average number of sales orders in 2018 for all sales staffs.

WITH cte_average_sales AS (
	SELECT 
		staff_id,
		COUNT(*) orders_count
	FROM sales.orders
	WHERE YEAR(order_date) = 2018
	GROUP BY staff_id
)

SELECT AVG(orders_count) average_orders_by_Staff 
FROM cte_average_sales;

/* USING multiple CTEs in single query
The following example uses two CTE cte_category_counts
and cte_category_sales to return the number of the
products and sales for each product category.
The outer query joins two CTEs using the 
category_id column.
*/
WITH cte_category_counts (
	category_id,
	category_name,
	porduct_count
) AS (
	SELECT 
		c.category_id,
		c.category_name,
		COUNT(p.product_id)
	FROM production.products p
	INNER JOIN production.categories c ON p.category_id = c.category_id
	GROUP BY c.category_id, category_name
),

cte_category_sales(category_id, sales)AS (
	SELECT 
		p.category_id,
		SUM(i.quantity * i.list_price * (1 - i.discount))
	FROM sales.order_items i
	INNER JOIN production.products p ON i.product_id = p.product_id
	INNER JOIN sales.orders o ON i.order_id = o.order_id
	GROUP BY p.category_id
)

SELECT 
	c.category_id,
	c.category_name,
	c.porduct_count,
	s.sales
FROM cte_category_counts c
INNER JOIN cte_category_sales s ON c.category_id = s.category_id
ORDER BY c.category_name;

-- SQL Server recursive CTE
/*
Syntax
-------
WITH expression_name (column_list)
AS
(
    -- Anchor member
    initial_query  
    UNION ALL
    -- Recursive member that references expression_name.
    recursive_query  
)
-- references expression name
SELECT *
FROM   expression_nam
*/

-- Example1: ecursive CTE to returns weekdays from Monday to Saturday

WITH cte_numbers(n, weekday)
AS (
	SELECT 
		0,
		DATENAME(DW,0)
	UNION ALL
	SELECT
		n+1,
		DATENAME(DW, n+1)
	FROM
		cte_numbers
	WHERE n<6
)

SELECT n, weekday
FROM cte_numbers;

-- Example2: Using a SQL Server recursive CTE to query hierarchical data

/*
In this table, a staff reports to zero or one manager.
A manager may have zero or more staffs. The top manager
has no manager. The relationship is specified in the
values of the manager_id column. If a staff does not
report to any staff (in case of the top manager), the
value in the manager_id is NULL.
*/


WITH cte_org AS (
	SELECT 
		staff_id,
		first_name,
		manager_id
	FROM sales.staffs
	WHERE manager_id IS NULL
	UNION ALL
	SELECT 
		s.staff_id,
		s.first_name,
		s.manager_id
	FROM sales.staffs s
	INNER JOIN cte_org o 
		ON o.staff_id = s.manager_id
)
SELECT * FROM cte_org;

-- PIVOT TABLE

SELECT * FROM (
	SELECT 
		category_name,
		product_id
	FROM production.products p
	INNER JOIN production.categories c
		ON c.category_id = p.product_id
) t
