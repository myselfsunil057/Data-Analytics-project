/*
===============================================================================
                      Magnitude Analysis
===============================================================================
Script Purpose:
    - To quantify data and group results by specific dimensions.
    - For understanding data distribution across categories.

SQL Functions Used:
    - Aggregate Functions: SUM(), COUNT(), AVG()
    - GROUP BY, ORDER BY
===============================================================================
*/

-- Find the Total Customers by Countries
SELECT 
	country,
	COUNT(customer_key) AS Total_Customers
FROM gold.dim_customers
GROUP BY country
ORDER BY Total_Customers DESC;

-- Find the Total Customers by Gender
SELECT 
	gender,
	COUNT(customer_key) AS Total_Customers
FROM gold.dim_customers
GROUP BY gender
ORDER BY Total_Customers DESC;

-- Find the Total Products by Category
SELECT 
	category,
	COUNT(product_key) AS Total_Products
FROM gold.dim_products
GROUP BY category
ORDER BY Total_Products DESC;

-- Find the Average Cost in Each Category ?
SELECT 
	category,
	AVG(cost) AS Average_Price
FROM gold.dim_products
GROUP BY category
ORDER BY Average_Price DESC;

-- Find the Total Revenue Generated in Each Category ?
SELECT 
	dp.category,
	SUM(fc.sales_amount) AS Total_Revenue
FROM gold.dim_products AS dp
LEFT JOIN gold.fact_sales AS fc
ON		dp.product_key = fc.product_key
GROUP BY category
ORDER BY Total_Revenue DESC;

-- Find the Total Revenue Generated in Each Customer ?
SELECT
	dc.customer_key,
	(first_name + last_name) AS Customer_name,
	SUM(sales_amount) AS Total_Revenue
FROM gold.dim_customers AS dc
LEFT JOIN gold.fact_sales AS fc
ON		dc.customer_key = fc.customer_key
GROUP BY dc.customer_key, first_name, last_name
ORDER BY Total_Revenue DESC;

-- Find the Distribution of sold items across countries
SELECT
	country,
	SUM(quantity) AS Quantity_sold
FROM gold.dim_customers AS dc
LEFT JOIN gold.fact_sales AS fc
ON		dc.customer_key = fc.customer_key
GROUP BY country
ORDER BY Quantity_sold DESC;
