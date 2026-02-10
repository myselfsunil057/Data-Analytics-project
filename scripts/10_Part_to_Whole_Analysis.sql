/*
===============================================================================
Part-to-Whole Analysis
===============================================================================
Purpose:
    - To compare performance or metrics across dimensions or time periods.
    - To evaluate differences between categories.
    - Useful for A/B testing or regional comparisons.

SQL Functions Used:
    - SUM(), AVG(): Aggregates values for comparison.
    - Window Functions: SUM() OVER() for total calculations.
===============================================================================
*/
-- ============================================================
--    Which Categories Contribute the Most to Overall Sales
-- =============================================================

SELECT
	category,
	Total_sales,
	SUM(Total_sales) OVER() AS Overall_sales,
	CONCAT(ROUND( (CAST (Total_sales AS Float) / SUM(Total_sales) OVER())*100 ,2),'%') AS Percentage_Of_Sales
FROM
	(
	SELECT 
		dp.category,
		SUM(fc.sales_amount) AS Total_sales
	FROM gold.fact_sales AS fc
	LEFT JOIN gold.dim_products AS dp
	ON	fc.product_key = dp.product_key
	GROUP BY dp.category
	)t
ORDER BY Total_sales DESC

-- =================================================================
--     Which Sub-Categories Contribute the Most to Overall Sales
-- =================================================================

SELECT
	category,
	subcategory,
	Total_sales,
	SUM(Total_sales) OVER(PARTITION BY category) AS Overall_sales,
	CONCAT(ROUND( (CAST (Total_sales AS Float) / SUM(Total_sales) OVER(PARTITION BY category))*100 ,2),'%') AS Category_Percentage_Of_Sales
FROM
	(
	SELECT 
		dp.category,
		dp.subcategory,
		SUM(fc.sales_amount) AS Total_sales
	FROM gold.fact_sales AS fc
	LEFT JOIN gold.dim_products AS dp
	ON	fc.product_key = dp.product_key
	GROUP BY dp.category,dp.subcategory
	)t
ORDER BY category,Total_sales DESC
