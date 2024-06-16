use BikeStores;

-- SELECT CLAUSE
select * from sales.customers;
select first_name, last_name, state from sales.customers;
select first_name, last_name, state from sales.customers where state='CA';