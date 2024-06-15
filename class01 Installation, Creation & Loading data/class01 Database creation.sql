-- Verifying Installation is Correct
SELECT @@VERSION;

-- Creating Database
-- LHS >> Databases >> New Database >> "database_name"
CREATE DATABASE BikeStores;

-- Selecting Database for Working
-- Select BikeStores from GUI above "master should be there"
USE BikeStores;

-- Creating Schema
CREATE SCHEMA production;
CREATE SCHEMA sales;

-- creating tbales

CREATE TABLE production.categories(
	category_id INT IDENTITY(1,1) PRIMARY KEY,
	category_name VARCHAR(255) NOT NULL
);

CREATE TABLE production.brands(
	brand_id INT IDENTITY(1,1) PRIMARY KEY,
	brand_name VARCHAR(255) NOT NULL
);

CREATE TABLE production.products(
	product_id INT IDENTITY(1,1) PRIMARY KEY,
	product_name VARCHAR(255) NOT NULL,
	brand_id INT NOT NULL,
	category_id INT NOT NULL,
	model_year SMALLINT NOT NULL,
	list_price DECIMAL(10,2) NOT NULL,
	FOREIGN KEY(category_id)
		REFERENCES production.categories(category_id)
		ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY(brand_id)
		REFERENCES production.brands(brand_id)
		ON DELETE CASCADE ON UPDATE CASCADE
);

-- manually setting insertion check for IDENTOTY to ON
SET IDENTITY_INSERT production.brands ON;

INSERT INTO production.brands(brand_id, brand_name) VALUES(1, 'Electra')
INSERT INTO production.brands(brand_id,brand_name) VALUES(2,'Haro')
INSERT INTO production.brands(brand_id,brand_name) VALUES(3,'Heller')
INSERT INTO production.brands(brand_id,brand_name) VALUES(4,'Pure Cycles')
INSERT INTO production.brands(brand_id,brand_name) VALUES(5,'Ritchey')
INSERT INTO production.brands(brand_id,brand_name) VALUES(6,'Strider')
INSERT INTO production.brands(brand_id,brand_name) VALUES(7,'Sun Bicycles')
INSERT INTO production.brands(brand_id,brand_name) VALUES(8,'Surly')
INSERT INTO production.brands(brand_id,brand_name) VALUES(9,'Trek')

SET IDENTITY_INSERT production.brands OFF;

-- verifying insertion
SELECT * FROM production.brands;

-- dropping tables if exists
DROP TABLE IF EXISTS production.brands;
DROP TABLE IF EXISTS production.categories;
DROP TABLE IF EXISTS production.products;