/*
===============================================================================
Database Exploration
===============================================================================
Script Purpose:
    - To explore the structure of the database, including the list of tables and their schemas.
    - To inspect the columns and metadata for specific tables.

Table Used:
    - INFORMATION_SCHEMA.TABLES
    - INFORMATION_SCHEMA.COLUMNS
===============================================================================
*/

-- Explore All objects in the Database
SELECT 
	TABLE_CATALOG,
	TABLE_NAME,
	TABLE_SCHEMA,
	TABLE_TYPE
FROM INFORMATION_SCHEMA.TABLES;



-- Explore All Columns  in the Database
SELECT 
	COLUMN_NAME, 
    DATA_TYPE, 
    IS_NULLABLE, 
    CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'fact_sales';

