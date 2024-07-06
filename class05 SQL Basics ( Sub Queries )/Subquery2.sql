-- Create Database class5;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50)
);

INSERT INTO customers (customer_id, first_name, last_name) VALUES
(1, 'John', 'Doe'),
(2, 'Jane', 'Smith'),
(3, 'Alice', 'Johnson');


CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    total_amount DECIMAL(10, 2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);


INSERT INTO orders (order_id, customer_id, total_amount) VALUES
(1, 1, 500.00),
(2, 1, 1500.00),
(3, 2, 200.00),
(4, 3, 1200.00),
(5, 3, 700.00);


-- The ANY operator is a logical operator that compares a scalar value with a single-column set of values returned by a subquery.

-- scalar_expression comparison_operator ANY (subquery)


SELECT
    customer_id,
    first_name,
    last_name
FROM
    customers c
WHERE
    1000 < ANY (
        SELECT
            total_amount
        FROM
            orders o
        WHERE
            o.customer_id = c.customer_id
    );


/*
Execution Steps:

Subquery Execution for Each Customer:
For customer_id = 1: The subquery returns the set {500, 1500}.
For customer_id = 2: The subquery returns the set {200}.
For customer_id = 3: The subquery returns the set {1200, 700}.

ANY Operator Evaluation:
For customer_id = 1: 1000 < ANY ({500, 1500}) is TRUE because 1500 > 1000.
For customer_id = 2: 1000 < ANY ({200}) is FALSE because 200 is not greater than 1000.
For customer_id = 3: 1000 < ANY ({1200, 700}) is TRUE because 1200 > 1000.

Main Query Result:
Customers with customer_id = 1 and customer_id = 3 meet the condition.

*/



-- ALL 
--The SQL Server ALL operator is a logical operator that compares a scalar value with a single-column list of values returned by a subquery.



SELECT
    customer_id,
    first_name,
    last_name
FROM
    customers c
WHERE
    100 < ALL (
        SELECT
            total_amount
        FROM
            orders o
        WHERE
            o.customer_id = c.customer_id
    );

/*
Explanation of the Example:
Subquery Execution for Each Customer:

For customer_id = 1: The subquery returns the set {500, 1500}.
For customer_id = 2: The subquery returns the set {200}.
For customer_id = 3: The subquery returns the set {1200, 700}.
ALL Operator Evaluation:

For customer_id = 1: 1000 < ALL ({500, 1500}) is FALSE because 500 is not greater than 1000.
For customer_id = 2: 1000 < ALL ({200}) is FALSE because 200 is not greater than 1000.
For customer_id = 3: 1000 < ALL ({1200, 700}) is FALSE because 700 is not greater than 1000.
*/




/* Cross Apply 
SELECT
  select_list
FROM
  table1
  CROSS APPLY table_function(table1.column) AS alias;

The CROSS APPLY clause works like an INNER JOIN clause. But instead of joining two tables, the CROSS APPLY clause joins a table with
a table-valued function or a correlated subquery. */

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    o.order_id,
    o.total_amount
FROM
    customers c
CROSS APPLY (
    SELECT
        order_id,
        total_amount
    FROM
        orders o
    WHERE
        o.customer_id = c.customer_id
        AND o.total_amount > 500
) o
ORDER BY
    c.customer_id;




-- Outter Apply 


SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    o.order_id,
    o.total_amount
FROM
    customers c
OUTER APPLY (
    SELECT
        order_id,
        total_amount
    FROM
        orders o
    WHERE
        o.customer_id = c.customer_id
        AND o.total_amount > 500
) o
ORDER BY
    c.customer_id;


