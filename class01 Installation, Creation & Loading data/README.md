## Install SQL Server

- We'll be using **SQL Server 2022 Developer Edition** and **SQL Server Management Studio (SSMS)**.
- To install the Microsoft SQL Server 2022 Developer Edition please follow the steps mentioned in below link
    - Note: 
        - Below attached link is of installation of SQL Server 2019 but it is same for SQL server 2022.
        - At some points whil installation you may see Azure SQL tab appear which are not covered in below link. you can simply **NEXT** those steps.
    - [Installation of Mircosoft SQL Server](https://www.sqlservertutorial.net/getting-started/install-sql-server/)
    

## Verificationof SQL Server Installation

- In this Step we'll connect to SQL Server from the SQL Server Management Studio and execute a query.
- NOTE: If Query execuation completes successfully its mean our intallation is successfull.
- Please follow the setsp mentioned in below link to connect to SQL Server from the SQL Server Management Studio and execute a query.
- [Connecting to SQL server & execuating Query](https://www.sqlservertutorial.net/getting-started/connect-to-the-sql-server/)

## Creating a Database

- In this steps we'll be getting started with database creations & cover following topics with help of BikeStore Case Study
    - Understanding the Database Diagram
    - Creating Databse, Schemas & tables
    - Concept of Forigen Key & Primary Key, Composite Keys
    - Check Constraints while creating tables
    - relationship between tables
        - one to one relationship
        - one to many relatioship
        - many to many relatioship

### Databse Diagram fron BIKESTORE Case Study

The following illustrates the BikeStores database diagram:

![bikestore Database](../img/bikstore-database.png)

Attaching references fo relatioship understanding in above diagram

![erd relation](../img/erd-notation.png)

#### OBSERVATIONS:
- The BikeStores sample database has two schemas sales and production
- These schemas have nine tables.
- one to one relatioship
    - Staffs ↔ Staffs (manager_id and staff_id)  
- one to many relatioship
    - Customers ↔ Orders
    - Stores ↔ Staffs
    - Stores ↔ Orders
    - Categories ↔ Products
    - Brands ↔ Products
- many to many relastioship
    - Products ↔ Orders (through Order_Items)
    - Stores ↔ Products (through Stocks)

#### CREATE TABLE COMMANDS

- Table `production.categories`

    ```sql
    CREATE TABLE production.categories (
	category_id INT IDENTITY (1, 1) PRIMARY KEY,
	category_name VARCHAR (255) NOT NULL
    );
    ```
- Table `production.brands`

    ```sql
    CREATE TABLE production.brands (
	brand_id INT IDENTITY (1, 1) PRIMARY KEY,
	brand_name VARCHAR (255) NOT NULL
    );
    ```
- Table `production.products`

    ```sql
    CREATE TABLE production.products (
	product_id INT IDENTITY (1, 1) PRIMARY KEY,
	product_name VARCHAR (255) NOT NULL,
	brand_id INT NOT NULL,
	category_id INT NOT NULL,
	model_year SMALLINT NOT NULL,
	list_price DECIMAL (10, 2) NOT NULL,
	FOREIGN KEY (category_id) 
        REFERENCES production.categories (category_id) 
        ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (brand_id) 
        REFERENCES production.brands (brand_id) 
        ON DELETE CASCADE ON UPDATE CASCADE
    ); 
    ```

NOE:
- **ON DELETE CASCADE:** Deletes referencing rows in the child table when a row in the parent table is deleted.
- **ON UPDATE CASCADE:** Updates referencing rows in the child table when a row in the parent table is updated.
- **ON DELETE NO ACTION:** Prevents deletion in the parent table if there are referencing rows in the child table.
- **ON UPDATE NO ACTION:** Prevents update in the parent table if there are referencing rows in the child table.

- Table `sales.stores`

    ```sql
    CREATE TABLE sales.stores (
	store_id INT IDENTITY (1, 1) PRIMARY KEY,
	store_name VARCHAR (255) NOT NULL,
	phone VARCHAR (25),
	email VARCHAR (255),
	street VARCHAR (255),
	city VARCHAR (255),
	state VARCHAR (10),
	zip_code VARCHAR (5)
    );
    ```

- Table `production.products`

    ```sql
    CREATE TABLE production.products (
	product_id INT IDENTITY (1, 1) PRIMARY KEY,
	product_name VARCHAR (255) NOT NULL,
	brand_id INT NOT NULL,
	category_id INT NOT NULL,
	model_year SMALLINT NOT NULL,
	list_price DECIMAL (10, 2) NOT NULL,
	FOREIGN KEY (category_id) 
        REFERENCES production.categories (category_id) 
        ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (brand_id) 
        REFERENCES production.brands (brand_id) 
        ON DELETE CASCADE ON UPDATE CASCADE
    ); 
    ```

- Table `sales.staffs`

    ```sql
    CREATE TABLE sales.staffs (
        staff_id INT IDENTITY (1, 1) PRIMARY KEY,
        first_name VARCHAR (50) NOT NULL,
        last_name VARCHAR (50) NOT NULL,
        email VARCHAR (255) NOT NULL UNIQUE,
        phone VARCHAR (25),
        active tinyint NOT NULL,
        store_id INT NOT NULL,
        manager_id INT,
        FOREIGN KEY (store_id) 
            REFERENCES sales.stores (store_id) 
            ON DELETE CASCADE ON UPDATE CASCADE,
        FOREIGN KEY (manager_id) 
            REFERENCES sales.staffs (staff_id) 
            ON DELETE NO ACTION ON UPDATE NO ACTION
    );
    ```

- Table `sales.customers`

    ```sql
    CREATE TABLE sales.customers (
	customer_id INT IDENTITY (1, 1) PRIMARY KEY,
	first_name VARCHAR (255) NOT NULL,
	last_name VARCHAR (255) NOT NULL,
	phone VARCHAR (25),
	email VARCHAR (255) NOT NULL,
	street VARCHAR (255),
	city VARCHAR (50),
	state VARCHAR (25),
	zip_code VARCHAR (5)
    );
    ```

- Table `sales.orders`

    ```sql
    CREATE TABLE sales.orders (
	order_id INT IDENTITY (1, 1) PRIMARY KEY,
	customer_id INT,
	order_status tinyint NOT NULL,
	-- Order status: 1 = Pending; 2 = Processing; 3 = Rejected; 4 = Completed
	order_date DATE NOT NULL,
	required_date DATE NOT NULL,
	shipped_date DATE,
	store_id INT NOT NULL,
	staff_id INT NOT NULL,
	FOREIGN KEY (customer_id) 
        REFERENCES sales.customers (customer_id) 
        ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (store_id) 
        REFERENCES sales.stores (store_id) 
        ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (staff_id) 
        REFERENCES sales.staffs (staff_id) 
        ON DELETE NO ACTION ON UPDATE NO ACTION
    );
    ```

- Table `sales.order_items`

    ```sql
    CREATE TABLE sales.order_items(
	order_id INT,
	item_id INT,
	product_id INT NOT NULL,
	quantity INT NOT NULL,
	list_price DECIMAL (10, 2) NOT NULL,
	discount DECIMAL (4, 2) NOT NULL DEFAULT 0,
	PRIMARY KEY (order_id, item_id),
	FOREIGN KEY (order_id) 
        REFERENCES sales.orders (order_id) 
        ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (product_id) 
        REFERENCES production.products (product_id) 
        ON DELETE CASCADE ON UPDATE CASCADE
    );
    ```

## Loading Data to Database

- To load data into database please download this zip file. link is attacjed below
- [BikeStore Dataset](https://www.sqlservertutorial.net/wp-content/uploads/SQL-Server-Sample-Database.zip)



