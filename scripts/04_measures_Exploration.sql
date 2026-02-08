/*
===============================================================================
                      Measures Exploration 
===============================================================================
Script Purpose:
    - To calculate aggregated metrics (e.g., totals, averages) for quick insights.
    - To identify overall trends or spot anomalies.

SQL Functions Used:
    - COUNT(), SUM(), AVG()
===============================================================================
*/

-- Find the Total Sales
SELECT 
	SUM(sales_amount) AS Total_sales
FROM gold.fact_sales

-- Find How Many items are Sold
SELECT 
	SUM(quantity) AS Total_ItemSold
FROM gold.fact_sales

-- Find the Average selling Price
SELECT 
	AVG(sales_amount) AS Avg_sales
FROM gold.fact_sales

-- Find the Total Number of Orders
SELECT 
	COUNT(DISTINCT order_number) AS Total_Orders
FROM gold.fact_sales

-- Find the Total Number of Products
SELECT 
	COUNT(product_key) AS Total_Products
FROM gold.dim_products

-- Find the Total Number of Customers
SELECT 
	COUNT(customer_key) AS Total_Customers
FROM gold.dim_customers

-- Find the Total Number of Customers that has Placed an Order
SELECT
	COUNT(DISTINCT customer_key) AS Total_customer
FROM gold.fact_sales

-- Generate a Report that shows all key Metrics of the Business
SELECT 'Total sales' AS Measure_name, SUM(sales_amount) AS Measure_value
FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity Sold' AS Measure_name, SUM(quantity) AS Measure_value
FROM gold.fact_sales
UNION ALL
SELECT 'Avgerage Price' AS Measure_name, AVG(sales_amount) AS Measure_value
FROM gold.fact_sales
UNION ALL
SELECT 'Total Orders' AS Measure_name, COUNT(DISTINCT order_number) AS Measure_value
FROM gold.fact_sales
UNION ALL
SELECT 'Total Products' AS Measure_name, COUNT(product_key) AS Measure_value
FROM gold.dim_products
UNION ALL
SELECT 'Total Customers' AS Measure_name, COUNT(customer_key) AS Measure_value
FROM gold.dim_customers
UNION ALL
SELECT 'Total Customers Ordered' AS Measure_name, COUNT(DISTINCT customer_key) AS Measure_value
FROM gold.fact_sales

