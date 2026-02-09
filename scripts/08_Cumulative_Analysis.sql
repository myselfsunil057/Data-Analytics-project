/*
===============================================================================
                       Cumulative Analysis
===============================================================================
Purpose:
    - To calculate running totals or moving averages for key metrics.
    - To track performance over time cumulatively.
    - Useful for growth analysis or identifying long-term trends.

SQL Functions Used:
    - Window Functions: SUM() OVER(), AVG() OVER()
    - Date & Time Functions: FORMAT(), DATETRUNC()
===============================================================================
*/

--------------------------------------------------------------------------------
-- Calculate the total Sales Per Month 
-- and the running total of sales Over Time
--------------------------------------------------------------------------------
SELECT
	FORMAT(order_date,' MMMM yyyy') AS Sales_Month,
	Total_sales,
	SUM(Total_sales) OVER( PARTITION BY YEAR(order_date) ORDER BY order_date) AS Running_Total
FROM
	(
	SELECT
		DATETRUNC(MONTH,order_date) AS order_date,
		SUM(sales_amount) AS Total_sales
	FROM gold.fact_sales
	WHERE order_date IS NOT NULL
	GROUP BY DATETRUNC(MONTH,order_date)
	)t

	
--------------------------------------------------------------------------------
-- Calculate the Total Sales and Average Price Per Year
-- and the Moving Average and Running Total of sales Over Time
--------------------------------------------------------------------------------
SELECT
	YEAR(order_date) AS Sales_Year,
	Total_sales,
	SUM(Total_sales) OVER(ORDER BY order_date) AS Running_Total,
	Average_price,
	AVG(Average_price) OVER(ORDER BY order_date) AS Moving_Average
FROM
	(
	SELECT
		DATETRUNC(YEAR,order_date) AS order_date,
		SUM(sales_amount) AS Total_sales,
		AVG(price) AS Average_price
	FROM gold.fact_sales
	WHERE order_date IS NOT NULL
	GROUP BY DATETRUNC(YEAR,order_date)
	)t
