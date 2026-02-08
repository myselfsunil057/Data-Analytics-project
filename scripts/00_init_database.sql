/*
==============================================================================================
   Database Setup & Initial Data Load Script
==============================================================================================
Script Purpose:
    This script automates the creation of the 'DataWarehouseAnalytics' database, including:
       1. Dropping the existing database (if it exists) to ensure a clean environment.
       2. Creating the database and schema ('gold') for analytical tables.
       3. Creating dimension and fact tables: 
            - dim_customers
            - dim_products
            - fact_sales
       4. Loading initial data from CSV files into the respective tables using BULK INSERT.

    This is intended for Exploratory Data Analysis (EDA) and testing purposes in a controlled 
    environment. Ensures reproducible results for analytics workflows.

WARNING:
     This script will permanently delete the existing 'DataWarehouseAnalytics' database 
     along with all its contents. Execute only in a non-production or development environment.
     Ensure CSV file paths are correct and accessible from the SQL Server instance.
     Running this script multiple times will reset the data.
*/


USE master;
GO

-- Drop and recreate the 'DataWarehouseAnalytics' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouseAnalytics')
BEGIN
    ALTER DATABASE DataWarehouseAnalytics SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouseAnalytics;
END;
GO

-- Create the 'DataWarehouseAnalytics' database
CREATE DATABASE DataWarehouseAnalytics;
GO

USE DataWarehouseAnalytics;
GO

-- Create Schemas

CREATE SCHEMA gold;
GO


IF OBJECT_ID('gold.dim_customers' , 'U') IS NOT NULL
	DROP TABLE gold.dim_customers;
GO

CREATE TABLE gold.dim_customers(
	customer_key int,
	customer_id int,
	customer_number nvarchar(50),
	first_name nvarchar(50),
	last_name nvarchar(50),
	country nvarchar(50),
	marital_status nvarchar(50),
	gender nvarchar(50),
	birthdate date,
	create_date date
);
GO

IF OBJECT_ID('gold.dim_products' , 'U') IS NOT NULL
	DROP TABLE gold.dim_products;
GO

CREATE TABLE gold.dim_products(
	product_key int ,
	product_id int ,
	product_number nvarchar(50) ,
	product_name nvarchar(50) ,
	category_id nvarchar(50) ,
	category nvarchar(50) ,
	subcategory nvarchar(50) ,
	maintenance nvarchar(50) ,
	cost int,
	product_line nvarchar(50),
	start_date date 
);
GO

IF OBJECT_ID('gold.fact_sales' , 'U') IS NOT NULL
	DROP TABLE gold.fact_sales;
GO

CREATE TABLE gold.fact_sales(
	order_number nvarchar(50),
	product_key int,
	customer_key int,
	order_date date,
	shipping_date date,
	due_date date,
	sales_amount int,
	quantity tinyint,
	price int 
);
GO


PRINT '>> Truncating Table: gold.dim_customers';
TRUNCATE TABLE gold.dim_customers;
GO

PRINT '>> Inserting Data Into: gold.dim_customers';
BULK INSERT gold.dim_customers
FROM 'C:\ExploratoryDataAnalysis/datasets/gold.dim_customers.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);
GO

PRINT '>> Truncating Table: gold.dim_products';
TRUNCATE TABLE gold.dim_products;
GO

PRINT '>> Inserting Data Into: gold.dim_products';
BULK INSERT gold.dim_products
FROM 'C:\ExploratoryDataAnalysis/datasets/gold.dim_products.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);
GO

PRINT '>> Truncating Table: gold.fact_sales';
TRUNCATE TABLE gold.fact_sales;
GO

PRINT '>> Inserting Data Into: gold.fact_sales';
BULK INSERT gold.fact_sales
FROM 'C:\ExploratoryDataAnalysis/datasets/gold.fact_sales.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);
GO
