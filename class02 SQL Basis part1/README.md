## SQL Server Basis part-1

In this class we'll cover following topics
- Querying Data
- Sorting Data
- Limiting Data
- Filtering Data
- Joining Data
- Filtering Data

### Section1: Querying Data

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

