# SQL SERVER BASICS part-1

In this class we'll cover following topics
- Filtering Data
- Joining Data
- Grouping data

## SECTION-03: FILTERING DATA

- `DISTINCT`  – select distinct values in one or more columns of a table.
- `WHERE` – filter rows in the output of a query based on one or more conditions.
- `AND` – combine two Boolean expressions and return true if all expressions are true.
- `OR`–  combine two Boolean expressions and return true if either of conditions is true.
- `IN` – check whether a value matches any value in a list or a subquery.
- `BETWEEN` – test if a value is between a range of values.
- `LIKE`  –  check if a character string matches a specified pattern.
- `Column & table aliases` – show you how to use column aliases to change the heading of the query output and table alias to improve the readability of a query.

### => SELECT `DISTINCT`

```sql
-- syntax
SELECT DISTINCT column_name FROM table_name; -- single columns
SELECT DISTINCT column_name1, column_name2 , ... FROM table_name; -- multiple columns
```

```sql
-- examples
-- 1) Using the SELECT DISTINCT with one column
SELECT city FROM sales.customers ORDER BY city; -- suppose we have this query
SELECT DISTINCT city FROM sales.customers ORDER BY city; -- same above query with distinct cities
-- 2) Using SELECT DISTINCT with multiple columns
SELECT city, state FROM sales.customers ORDER BY city, state; -- retrieve the cities and states of all customers
SELECT DISTINCT city, state FROM sales.customers -- uses the combination of values in both city and state columns to evaluate the duplicate
-- 3) Using SELECT DISTINCT with NULL
-- DISTINCT clause keeps only one NULL in the phone column and removes other NULLs.
SELECT DISTINCT phone FROM sales.customers ORDER BY phone;
```

#### DISTINCT vs. GROUP BY

The following statement uses the `GROUP BY` clause to return distinct `cities` together with `state` and `zip` code from the `sales.customers` table:

```sql
SELECT city, state, zip_code FROM sales.customers GROUP BY city, state, zip_code ORDER BY city, state, zip_code;
-- It is equivalent to the following query that uses the DISTINCT operator :
SELECT DISTINCT city, state, zip_code FROM sales.customers;
```

Both `DISTINCT` and `GROUP BY` clause reduces the number of returned rows in the result set by removing the duplicates.

However, you should use the `GROUP BY` clause when you want to apply an aggregate function to one or more columns.

### => SELECT `WHERE, AND, OR, IN, BETWEEN, LIKE, AS`

```sql
-- syntax
SELECT select_list FROM table_name WHERE search_condition; -- search_condition [AND, OR, IN, BETWEEN, LIKE]
column_name | expression  AS column_alias -- AS is optional
column_name | expression column_alias
```

```sql
-- examples
-- 1) Using the WHERE clause with a simple equality operator
SELECT product_id, product_name, category_id, model_year, list_price FROM production.products WHERE category_id = 1 ORDER BY list_price DESC;
-- 2) Using the WHERE clause with the AND operator
SELECT product_id, product_name, category_id, model_year, list_price FROM production.products WHERE category_id = 1 AND model_year = 2018 ORDER BY list_price DESC;
-- 3) Using WHERE to filter rows using a comparison operator
SELECT product_id, product_name, category_id, model_year, list_price FROM production.products WHERE list_price > 300 AND model_year = 2018 ORDER BY list_price DESC;
-- 4) Using the WHERE clause to filter rows that meet any of two conditions
SELECT product_id, product_name, category_id, model_year, list_price FROM production.products WHERE list_price > 3000 OR model_year = 2018 ORDER BY list_price DESC;
-- 5) Using the WHERE clause to filter rows with the value between two values
SELECT product_id, product_name, category_id, model_year, list_price FROM production.products WHERE list_price BETWEEN 1800.00 AND 1999.99 ORDER BY list_price DESC;
-- 6) Using the WHERE clause to filter rows that have a value in a list of values
SELECT product_id, product_name, category_id, model_year, list_price FROM production.products WHERE list_price IN (299.99, 369.99, 489.99) ORDER BY list_price DESC;
-- 7) Finding rows whose values contain a string
SELECT product_id, product_name, category_id, model_year, list_price FROM production.products WHERE product_name LIKE '%Cruiser%' ORDER BY list_price DESC;
-- 8) Column alias ()
SELECT first_name + ' ' + last_name AS full_name FROM sales.customers ORDER BY first_name;
SELECT first_name + ' ' + last_name AS 'Full Name' FROM sales.customers ORDER BY first_name;
```