-- Sales amounts by sales staffs in 2018
SELECT
	first_name + ' ' + last_name,
	SUM(quantity * list_price),
	YEAR(order_date)
FROM sales.orders o
INNER JOIN sales.staffs s
	ON s.staff_id = o.staff_id
INNER JOIN sales.order_items i
	ON i.order_id = o.order_id
GROUP BY
	first_name + ' ' + last_name,
	YEAR(order_date)
HAVING YEAR(order_date) = 2018

-- CTEs Stands for common table expression

/*
SYNTAX
---------
WITH expression_name[(column_name [,...])]
AS
    (CTE_definition)
SQL_statement;

*/

WITH cte_total_sales(staff, sales, year)
AS (
	SELECT
		first_name + ' ' + last_name,
		SUM(quantity * list_price),
		YEAR(order_date)
	FROM sales.orders o
	INNER JOIN sales.staffs s
		ON s.staff_id = o.staff_id
	INNER JOIN sales.order_items i
		ON i.order_id = o.order_id
	GROUP BY
		first_name + ' ' + last_name,
		YEAR(order_date)
)

SELECT * 
FROM cte_total_sales
WHERE year = 2018;

/* 
Example2: Write a  the CTE to return the
average number of sales orders in 2018 
for all sales staffs.
*/

-- query:
SELECT 
	staff_id,
	COUNT(*) orders_count
FROM sales.orders
WHERE YEAR(order_date)=2018
GROUP BY staff_id;

-- query with CTE
WITH cte_avg_orders_by_staff (staff_id, order_count)
AS(
	SELECT 
		staff_id,
		COUNT(*) orders_count
	FROM sales.orders
	WHERE YEAR(order_date)=2018
	GROUP BY staff_id
)
SELECT AVG(order_count) as average_orders
FROM cte_avg_orders_by_staff;

-- multiple SQL Server CTE in a single query example
/*
The following example uses two CTE 
cte_category_counts and cte_category_sales
to return the number of the products and 
sales for each product category. 
The outer query joins two CTEs using the 
category_id column.
*/

WITH cte_category_counts (
	category_id,
	category_name,
	product_count
)
AS (
	SELECT 
		c.category_id,
		c.category_name,
		COUNT(p.product_id)
	FROM production.products p
	INNER JOIN production.categories c
		ON p.category_id = c.category_id
	GROUP BY c.category_id, category_name
),
cte_category_sales (category_id, sales)
AS (
	SELECT
		p.category_id,
		SUM(i.quantity * i.list_price * (1- i.discount))
	FROM sales.order_items i
	INNER JOIN sales.orders o
		ON o.order_id = i.order_id
	INNER JOIN production.products p
		ON p.product_id = i.product_id
	GROUP BY p.category_id

)

SELECT 
	cc.category_id,
	cc.category_name,
	cc.product_count,
	cs.sales
FROM cte_category_counts cc
INNER JOIN cte_category_sales cs
	ON cc.category_id = cs.category_id

-- Recurive CTEs
-- ayse CTEs jo bar bar
-- khud ko call kar rhy hoon

/*
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
FROM   expression_name

Example1: Recursive CTE to returns weekdays
from Monday to Saturday

*/

WITH cte_daysName (n, weekday)
AS (
	SELECT
		0,
		DATENAME(DW,0)
	UNION ALL
	SELECT
		n+1,
		DATENAME(DW, n+1)
	FROM cte_daysName
	WHERE n<6
)

SELECT *
FROM cte_daysName;

-- Using a SQL Server recursive CTE to 
-- query hierarchical data

WITH cte_hierarchica_data (
		staff_id,
		first_name,
		manager_id
)
AS(
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
	INNER JOIN cte_hierarchica_data hd
		ON hd.staff_id = s.manager_id
)

SELECT * 
FROM cte_hierarchica_data;

-- PIVOT TBALEs
SELECT *
FROM (

	SELECT 
		category_name, 
		product_id,
		model_year
	FROM 
		production.products p
		INNER JOIN production.categories c 
			ON c.category_id = p.category_id
) t
PIVOT (
	COUNT(product_id)
	FOR category_name IN (
		[Children Bicycles],
		[Comfort Bicycles],
		[Cruisers Bicycles],
		[Cyclocross Bicycles],
		[Electric Bikes],
		[Mountain Bikes],
		[Road Bikes])

) AS pivot_table;