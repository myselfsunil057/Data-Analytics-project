/*
===============================================================================
                  Date Range Exploration 
===============================================================================
Purpose:
    - To determine the temporal boundaries of key data points.
    - To understand the range of historical data.

SQL Functions Used:
    - MIN(), MAX(), DATEDIFF()
===============================================================================
*/

-- Find the date of first and Last date
SELECT 
	MIN(order_date)                                    AS first_OrderDate,
	MAX(order_date)                                    AS last_OrderDate,
	DATEDIFF(YEAR,MIN(order_date),MAX(order_date))     AS order_Rangeyears,
	DATEDIFF(MONTH,MIN(order_date),MAX(order_date))    AS order_Rangemonths
FROM gold.fact_sales

-- Find the Youngest and Oldest Customer
SELECT 
	MIN(birth_date)                                     AS Old_customer,
	DATEDIFF(YEAR,MIN(birth_date),GETDATE())            AS Old_customerAge,
	MAX(birth_date)                                     AS Young_customer,
	DATEDIFF(YEAR,MAX(birth_date),GETDATE())            AS Young_customerAge
FROM gold.dim_customers

