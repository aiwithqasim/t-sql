# SQL SERVER BASICS part-1

In this class we'll cover following topics
- Querying Data
- Sorting Data
- Limiting Data
- Filtering Data
- Joining Data
- Grouping data

## SECTION-01: QUERYING DATA

This section helps you learn how to query data from the SQL Server database. We will start with a simple query that allows you to retrieve data from a single table.

`SELECT` – show you how to query data against a single table.

```sql
-- syntax
SELECT
select_list
FROM
schema_name.table_name;
```
Examples:

```sql
-- examples
SELECT first_name FROM sales.customers; -- FROM >> SELECT
SELECT first_name, last_name FROM sales.customers;
SELECT * FROM sales.customers;
SELECT * FROM sales.customers WHERE state = 'CA'; -- FROM >> WHERE >> SELECT
SELECT * FROM sales.customers WHERE state = 'CA' ORDER BY first_name; -- FROM >> WHERE >> SELECT >> ORDER BY
SELECT * FROM sales.customers WHERE state = 'CA' GROUP BY city ORDER BY city; -- FROM >> WHERE >> GROUP BY >> SELECT >> ORDER BY
SELECT city, count(*) FROM sales.customers WHERE state = 'CA' GROUP BY city HAVING count(*) > 10 ORDER BY city; 
SELECT city, count(*) AS cnt FROM sales.customers WHERE state = 'CA' GROUP BY city HAVING cnt > 10 ORDER BY city;
```

In last example, SQL Server processes the clauses in the following sequence: `FROM`, `WHERE`, `GROUP BY`, `HAVING`, `SELECT`, and `ORDER BY`.

![order of execution](../img/order-of-execution.png)

## SECTION-02: SORTING DATA

This section helps you learn how to sort the queried data from the SQL Server database.

`ORDER BY` – sort the result set based on values in a specified list of columns

```sql
-- syntax
SELECT
    select_list
FROM
    table_name
ORDER BY 
    column_name | expression [ASC | DESC ];
```
Examples:

```sql
-- examples
SELECT first_name, last_name FROM sales.customers ORDER BY first_name; -- ASC by defualt
SELECT first_name, last_name FROM sales.customers ORDER BY first_name DESC;
SELECT city, first_name, last_name FROM sales.customers ORDER BY city, first_name; -- ASC by defualt
SELECT city, first_name, last_name FROM sales.customers ORDER BY city DESC, first_name ASC;
SELECT city, first_name, last_name FROM sales.customers ORDER BY state; -- possible to order by column that is not in select
SELECT first_name, last_name FROM sales.customers ORDER BY LEN(first_name) DESC; -- Sort a result set by an expression i:e., LEN()
SELECT first_name, last_name FROM sales.customers ORDER BY 1, 2;
-- 1 means the first_name column, and 2 means the last_name column.
```

_NOTE:_
Using the ordinal positions of columns in the ORDER BY clause is considered a bad programming practice for a couple of reasons.
- First, the columns in a table don’t have ordinal positions and need to be referenced by name.
- Second, when you modify the select list, you may forget to make the corresponding changes in the ORDER BY clause.
Therefore, it is a good practice to always specify the column names explicitly in the ORDER BY clause.

## SECTION-03: LIMITING DATA

This section helps you learn how to limit data in the SQL Server using `OFFSET` `FETCH` and `TOP`.

- `OFFSET FETCH` – limit the number of rows returned by a query.
- `SELECT TOP` – limit the number of rows or percentage of rows returned in a query’s result set.

### => `OFFSET FETCH`

```sql
-- syntax
ORDER BY column_list [ASC |DESC]
OFFSET offset_row_count {ROW | ROWS} -- OFFSET clause specifies the number of rows to skip
FETCH {FIRST | NEXT} fetch_row_count {ROW | ROWS} ONLY -- FECTH is optional & FIRST/NEXT are optional
```

_NOTE:_
- The `OFFSET` and `FETCH` clauses are the options of the `ORDER BY` clause.
- The following illustrates the OFFSET and FETCH clauses:

![fecth-offset](../img/sql-server-OFFSET-FETCH.png)

```sql
-- examples
SELECT product_name, list_price FROM production.products ORDER BY list_price, product_name; -- NOTE above point # 01
SELECT product_name, list_price FROM production.products ORDER BY list_price, product_name OFFSET 10 ROWS; -- skip first 10 rows
SELECT product_name, list_price FROM production.products ORDER BY list_price, product_name OFFSET 10 ROWS FECTH NEXT 10 ROWS; -- skip first 10 & select next next 10 rows
SELECT product_name, list_price FROM production.products ORDER BY list_price, product_name OFFSET 0 ROWS FECTH NEXT 10 ROWS; -- select first 10 rows
```

### => SELECT `TOP`

```sql
-- syntax
SELECT TOP (expression) [PERCENT]
    [WITH TIES]
FROM 
    table_name
ORDER BY 
    column_name;
```

```sql
-- examples
SELECT TOP 10 product_name, list_price FROM production.products ORDER BY list_price DESC; -- top 10 most expensive products
SELECT TOP 1 PERCENT product_name, list_price FROM production.products ORDER BY list_price DESC; -- total_rows=321, 1%=3.21 ~ 4rows
SELECT TOP 3 WITH TIES  product_name, list_price FROM production.products ORDER BY list_price DESC; -- explained below
```
Example three is explained below:

![top with ties explanation](../img/top-with-ties-examples.png)

In this example, the third expensive product has a list price of 6499.99. Because the statement uses TOP WITH TIES, it returns three more products whose list prices are the same as the third one.

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

### => SELECT `WHERE, AND, OR, IN, BETWEEN, LIKE`

```sql
-- syntax
SELECT select_list FROM table_name WHERE search_condition;
-- search_condition [AND, OR, IN, BETWEEN, LIKE]
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

```