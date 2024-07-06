/* Write a query which returns order_id,order_date & customer where city = 'New York' and Ddata should be sorted 
 on order date*/

SELECT 
	s.order_id,
	s.order_date,
	c.customer_id

FROM sales.orders s
INNER JOIN sales.customers c on c.customer_id = s.customer_id
where c.city = 'New York'
ORDER BY 
	order_date;


/* 
Subquery:
	A subquery is a query nested inside another statement such as SELECT, INSERT, UPDATE, or DELETE. 
*/


SELECT 
	order_id,
	order_date,
	customer_id

FROM sales.orders
WHERE customer_id IN (
	SELECT customer_id FROM sales.customers
	WHERE city = 'New York'
	)
ORDER BY 
	order_date;

-- Note that you must always enclose the SELECT query of a subquery in parentheses ().

-- Correlated subquery

/* A correlated subquery is a subquery that uses the values of the outer query. In other words, 
  the correlated subquery depends on the outer query for its values. */




 SELECT
    product_name,
    list_price,
    category_id
FROM
    production.products p1
WHERE
    list_price IN (
        SELECT
            MAX (p2.list_price)
        FROM
            production.products p2
        WHERE
            p2.category_id = p1.category_id
        GROUP BY
            p2.category_id
    )
ORDER BY
    category_id,
    product_name;



-- EXISTS
/* The EXISTS operator is a logical operator that allows you to check whether a subquery returns any row. 
The EXISTS operator returns TRUE if the subquery returns one or more rows.*/



/* Write a  subquery that returns customers who place more than two orders*/

SELECT
    customer_id,
    first_name,
    last_name
FROM
    sales.customers c
WHERE
    customer_id IN (
        SELECT
            customer_id
        FROM
            sales.orders o
        GROUP BY
            customer_id
        HAVING
            COUNT(customer_id) > 2
    )
ORDER BY
    first_name,
    last_name;


-- By using exists


SELECT
    customer_id,
    first_name,
    last_name
FROM
    sales.customers c
WHERE
    EXISTS (
        SELECT
            COUNT (*)
        FROM
            sales.orders o
        WHERE
            customer_id = c.customer_id
        GROUP BY
            customer_id
        HAVING
            COUNT (*) > 2
    )
ORDER BY
    first_name,
    last_name;			

-- Common Table Expression -> CTE

/* CTE stands for common table expression. A CTE allows you to define a temporary named result set that available temporarily in the 
execution scope of a statement such as SELECT, INSERT, UPDATE, DELETE, or MERGE. 


WITH expression_name[(column_name [,...])]
AS
    (CTE_definition)
SQL_statement;


*/

-- return the average number of sales orders in 2018 for all sales staffs.

WITH cte_sales AS (
    SELECT 
        staff_id, 
        COUNT(*) order_count  
    FROM
        sales.orders
    WHERE 
        YEAR(order_date) = 2018
    GROUP BY
        staff_id
)
SELECT
    AVG(order_count) average_orders_by_staff
FROM 
    cte_sales;


-- Pivot 


SELECT * FROM   
(
    SELECT 
        category_name, 
        product_id,
        model_year
    FROM 
        production.products p
        INNER JOIN production.categories c 
            ON c.category_id = p.category_id
) t 
PIVOT(
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





