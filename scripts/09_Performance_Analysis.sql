/*
===============================================================================
          Performance Analysis (Year-over-Year, Month-over-Month)
===============================================================================
Purpose:
    - To measure the performance of products, customers, or regions over time.
    - For benchmarking and identifying high-performing entities.
    - To track yearly trends and growth.

SQL Functions Used:
    - LAG(): Accesses data from previous rows.
    - AVG() OVER(): Computes average values within partitions.
    - CASE: Defines conditional logic for trend analysis.
===============================================================================
*/
------------------------------------------------------------------------------------------
/*
Analyze the Yearly Performance of Products by Comparing their Sales to both
the Average Sales Performance of the Product and the Previous Year's Sales
*/
------------------------------------------------------------------------------------------
WITH Yearly_Product_Sales AS
(
SELECT 
	YEAR(fc.order_date) AS Order_Year,
	dp.product_name,
	SUM(sales_amount) AS Total_Sales
FROM gold.fact_sales AS fc
LEFT JOIN gold.dim_products AS dp
ON	fc.product_key = dp.product_key
WHERE fc.order_date IS NOT NULL
GROUP BY YEAR(fc.order_date),dp.product_name
)

SELECT
	Order_Year,
	product_name,
	Total_Sales,
	Average_Sales,
	Total_Sales - Average_Sales AS Average_Difference,
	CASE 
		WHEN Total_Sales - Average_Sales > 0 THEN 'ABOVE Average'
		WHEN Total_Sales - Average_Sales < 0 THEN 'BELOW Average'
		ELSE 'At Average'
	END Average_Change,
	Previous_Year_Sales,
	Total_Sales - Previous_Year_Sales AS Yearly_Sales_Difference,
  --Year Over Year Analysis
	CASE 
		WHEN Total_Sales - Previous_Year_Sales > 0 THEN 'Increase'
		WHEN Total_Sales - Previous_Year_Sales < 0 THEN 'Decrease'
		ELSE 'No Change'
	END Yearly_Sales_Change
FROM
	(
	SELECT *,
		AVG(Total_Sales) OVER( PARTITION BY product_name) AS Average_Sales,
		LAG(Total_Sales) OVER( PARTITION BY product_name ORDER BY Order_Year) AS Previous_Year_Sales
	FROM Yearly_Product_Sales
	)t
ORDER BY product_name,Order_Year



------------------------------------------------------------------------------------------
/*
Analyze the Monthly Performance of Products by Comparing their Sales to both
the Average Sales Performance of the Product and the Previous Month's Sales
*/
------------------------------------------------------------------------------------------
WITH Monthly_Product_Sales AS
(
SELECT 
	DATETRUNC(MONTH,fc.order_date) AS Order_Month,
	dp.product_name,
	SUM(sales_amount) AS Total_Sales
FROM gold.fact_sales AS fc
LEFT JOIN gold.dim_products AS dp
ON	fc.product_key = dp.product_key
WHERE fc.order_date IS NOT NULL
GROUP BY DATETRUNC(MONTH,fc.order_date),dp.product_name
)

SELECT
	FORMAT(Order_Month, 'MMMM yyyy') AS Monthly_Orders,
	product_name,
	Total_Sales,
	Average_Sales,
	Total_Sales - Average_Sales AS Average_Difference,
	CASE 
		WHEN Total_Sales - Average_Sales > 0 THEN 'ABOVE Average'
		WHEN Total_Sales - Average_Sales < 0 THEN 'BELOW Average'
		ELSE 'At Average'
	END Average_Change,
	Previous_Month_Sales,
	Total_Sales - Previous_Month_Sales AS Monthly_Sales_Difference,
   --Month Over Month Analysis
	CASE 
		WHEN Total_Sales - Previous_Month_Sales > 0 THEN 'Increase'
		WHEN Total_Sales - Previous_Month_Sales < 0 THEN 'Decrease'
		ELSE 'No Change'
	END Yearly_Sales_Change
FROM
	(
	SELECT *,
		AVG(Total_Sales) OVER( PARTITION BY product_name) AS Average_Sales,
		LAG(Total_Sales) OVER( PARTITION BY product_name ORDER BY Order_Month) AS Previous_Month_Sales
	FROM Monthly_Product_Sales
	)t
ORDER BY product_name,Order_Month

