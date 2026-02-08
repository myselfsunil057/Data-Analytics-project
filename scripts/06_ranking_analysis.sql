/*
===============================================================================
              Ranking Analysis
===============================================================================
Script Purpose:
    - To rank items (e.g., products, customers) based on performance or other metrics.
    - To identify top performers or laggards.

SQL Functions Used:
    - Window Ranking Functions: RANK(), DENSE_RANK(), ROW_NUMBER(), TOP
    - Clauses: GROUP BY, ORDER BY
===============================================================================
*/
-- ============================================================================
--                               Basic Ranking
-- ============================================================================
-- Find the First 5 Products generate the Highest revenue ? 
SELECT TOP 5
	product_name,
	SUM(sales_amount) AS Total_Revenue
FROM gold.dim_products AS dp
LEFT JOIN gold.fact_sales AS fc
ON		dp.product_key = fc.product_key
GROUP BY product_name
ORDER BY Total_Revenue DESC;

-- Find the 5 Worst-Performing Products in terms of sales?
SELECT TOP 5
	product_name,
	SUM(sales_amount) AS Total_Revenue
FROM gold.fact_sales AS fc
LEFT JOIN gold.dim_products AS dp
ON		dp.product_key = fc.product_key
GROUP BY product_name
ORDER BY Total_Revenue ASC;


-- Find the First 5 Sub-Category generate the Highest revenue ? 
SELECT TOP 5
	subcategory,
	SUM(sales_amount) AS Total_Revenue
FROM gold.dim_products AS dp
LEFT JOIN gold.fact_sales AS fc
ON		dp.product_key = fc.product_key
GROUP BY subcategory
ORDER BY Total_Revenue DESC;

-- Find the 5 Worst-Performing Sub-Category in terms of sales?
SELECT TOP 5
	subcategory,
	SUM(sales_amount) AS Total_Revenue
FROM gold.fact_sales AS fc
LEFT JOIN gold.dim_products AS dp
ON		dp.product_key = fc.product_key
GROUP BY subcategory
ORDER BY Total_Revenue ASC;

-- ==============================================================================================
--                                 Advance Ranking
-- ==============================================================================================
-- Find the Top 10 Customers who have generated the highest revenue 
SELECT Customer_Name,Total_Revenue,Rank_Customers
FROM (
	SELECT
		fc.customer_key,
		(first_name + ' '+ last_name) AS Customer_Name,
		SUM(sales_amount) AS Total_Revenue,
		ROW_NUMBER() OVER(ORDER BY SUM(sales_amount) DESC) AS Rank_Customers
	FROM gold.fact_sales AS fc
	LEFT JOIN gold.dim_customers AS dc
	ON		dc.customer_key = fc.customer_key
	GROUP BY fc.customer_key,first_name,last_name
	)t
WHERE Rank_Customers <= 10;

-- Find 3 Customers with Fewest Orders Placed
SELECT Customer_Name,Total_Orders,Rank_Customers
FROM (
	SELECT
		fc.customer_key,
		(first_name + ' '+ last_name) AS Customer_Name,
		COUNT(order_number) AS Total_Orders,
		ROW_NUMBER() OVER(ORDER BY COUNT(order_number)) AS Rank_Customers
	FROM gold.fact_sales AS fc
	LEFT JOIN gold.dim_customers AS dc
	ON		dc.customer_key = fc.customer_key
	GROUP BY fc.customer_key,first_name,last_name
	)t
WHERE Rank_Customers <= 3;


-- Find the First 5 Products generate the Highest revenue ? 
SELECT *
FROM (
	SELECT
		product_name,
		SUM(sales_amount) AS Total_Revenue,
		ROW_NUMBER() OVER(ORDER BY SUM(sales_amount) DESC) AS Rank_products
	FROM gold.fact_sales AS fc
	LEFT JOIN gold.dim_products AS dp
	ON		dp.product_key = fc.product_key
	GROUP BY product_name
	)t
WHERE Rank_products <= 5;

-- Find the 5 Worst-Performing Products in terms of sales?
SELECT *
FROM (
	SELECT
		product_name,
		SUM(sales_amount) AS Total_Revenue,
		ROW_NUMBER() OVER(ORDER BY SUM(sales_amount)) AS Rank_products
	FROM gold.fact_sales AS fc
	LEFT JOIN gold.dim_products AS dp
	ON		dp.product_key = fc.product_key
	GROUP BY product_name
	)t
WHERE Rank_products <= 5;

-- Find the First 5 Sub-Category generate the Highest revenue ? 
SELECT *
FROM (
	SELECT
		subcategory,
		SUM(sales_amount) AS Total_Revenue,
		ROW_NUMBER() OVER(ORDER BY SUM(sales_amount) DESC) AS Rank_products
	FROM gold.fact_sales AS fc
	LEFT JOIN gold.dim_products AS dp
	ON		dp.product_key = fc.product_key
	GROUP BY subcategory
	)t
WHERE Rank_products <= 5;

-- Find the 5 Worst-Performing Sub-Category in terms of sales?
SELECT *
FROM (
	SELECT
		subcategory,
		SUM(sales_amount) AS Total_Revenue,
		ROW_NUMBER() OVER(ORDER BY SUM(sales_amount)) AS Rank_products
	FROM gold.fact_sales AS fc
	LEFT JOIN gold.dim_products AS dp
	ON		dp.product_key = fc.product_key
	GROUP BY subcategory
	)t
WHERE Rank_products <= 5;
