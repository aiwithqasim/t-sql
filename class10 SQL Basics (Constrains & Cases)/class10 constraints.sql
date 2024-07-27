/*
Section 14. Constraints
-------------------------
1- PRIMARY KEY
2- FOREIGN KEY
3- NOT NULL
4- UNIQUE
5- CHECK

*/

CREATE SCHEMA production;
GO

DROP TABLE IF EXISTS production.categories;
DROP TABLE IF EXISTS production.brands;
DROP TABLE IF EXISTS production.products;

CREATE TABLE production.categories (
    category_id INT IDENTITY (1, 1) PRIMARY KEY,
    category_name VARCHAR (255) NOT NULL UNIQUE
);

CREATE TABLE production.brands (
    brand_id INT IDENTITY (1, 1) PRIMARY KEY,
    brand_name VARCHAR (255) NOT NULL UNIQUE
);

CREATE TABLE production.products (
    product_id INT IDENTITY (1, 1) PRIMARY KEY,
    product_name VARCHAR (255) NOT NULL UNIQUE,
    brand_id INT NOT NULL,
    category_id INT NOT NULL,
    model_year SMALLINT NOT NULL,
    list_price DECIMAL (10, 2) NOT NULL,
    FOREIGN KEY (category_id) REFERENCES production.categories (category_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (brand_id) REFERENCES production.brands (brand_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CHECK (model_year >= 1900 AND model_year <= YEAR(GETDATE())),
    CHECK (list_price > 0)
);

/*
Section 15. Expressions

Syntax:
-------
CASE input   
    WHEN e1 THEN r1
    WHEN e2 THEN r2
    ...
    WHEN en THEN rn
    [ ELSE re ]   
END  
*/

select order_status, count(order_id) order_count
from sales.orders
where YEAR(order_date) = 2018
GROUP BY order_status;


select
	CASE order_status
		WHEN 1 THEN 'Pending'
		WHEN 2 THEN 'Processing'
		WHEN 3 THEN 'Rejected'
		WHEN 4 THEN 'Completed'
	END AS order_status,
	COUNT(order_id) as order_count
from sales.orders
where year(order_date) = 2018
group by order_status;

-- Using simple CASE expression in aggregate function example
select sum(order_status)
from sales.orders
where order_status=1;