/*
========================================================================================
                     Change Over Time Sales Performance Analysis
=========================================================================================
Script Purpose:
    Time-series analysis on gold.fact_sales to evaluate sales trends, customer activity, 
    and volume movement across daily, monthly, and yearly grains.
    This script answers one core question:
      “How is the business performing over time?”
    -> Tracks revenue growth/decline
    -> Supports trend analysis, forecasting, and YoY/MoM comparisons
    ->  Feeds Power BI / Tableau time-series visuals

SQL Functions Used:
    - Date Functions: DATEPART(), DATETRUNC(), FORMAT()
    - Aggregate Functions: SUM(), COUNT(), AVG()
===============================================================================
*/

-------------------------------------------------------------
--                Daily Performance by Sales
-------------------------------------------------------------
SELECT 
	FORMAT(order_date,'MMMM dd yyyy') AS Sales_Days,
	total_sales
FROM
	(
	SELECT
		order_date,
		SUM(sales_amount) AS total_sales
	FROM gold.fact_sales
	WHERE order_date IS NOT NULL
	GROUP BY order_date			
	)t
ORDER BY order_date;

-------------------------------------------------------------
--             Monthly Performance by Sales
-------------------------------------------------------------

SELECT 
	FORMAT(year_date,'MMMM yyyy') AS Months,
	total_sales
FROM 
	(
	SELECT
		DATEFROMPARTS(DATEPART(YEAR,order_date),DATEPART(MONTH,order_date),1) AS year_date,
		SUM(sales_amount) AS total_sales
	FROM gold.fact_sales
	WHERE order_date IS NOT NULL
	GROUP BY DATEFROMPARTS(DATEPART(YEAR,order_date),DATEPART(MONTH,order_date),1)
	)t
ORDER BY year_date;

-------------------------------------------------------------
--    Monthly Performance by Sales, Customers and Quantity
-------------------------------------------------------------

SELECT 
	FORMAT(year_date,'MMMM yyyy') AS Months,
	Total_sales,
	Total_Customers,
	Total_Quantity
FROM 
	(
	SELECT
		DATEFROMPARTS(DATEPART(YEAR,order_date),DATEPART(MONTH,order_date),1) AS year_date,
		SUM(sales_amount) AS Total_sales,
		COUNT(DISTINCT customer_key) AS Total_Customers,
		SUM(quantity) AS Total_Quantity
	FROM gold.fact_sales
	WHERE order_date IS NOT NULL
	GROUP BY DATEFROMPARTS(DATEPART(YEAR,order_date),DATEPART(MONTH,order_date),1)
	)t
ORDER BY year_date;

-------------------------------------------------------------
--               Yearly Performance by Sales
-------------------------------------------------------------

SELECT
	YEAR(order_date) Year,
	SUM(sales_amount) AS total_sales
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY Year;

-------------------------------------------------------------
--    Yearly Performance by Sales, Customers and Quantity
-------------------------------------------------------------

SELECT
	YEAR(order_date) Year,
	SUM(sales_amount) AS Total_sales,
	COUNT(DISTINCT customer_key) AS Total_Customers,
	SUM(quantity) AS Total_Quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY Year;
