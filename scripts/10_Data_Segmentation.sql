/*
===============================================================================
                      Data Segmentation Analysis
===============================================================================
Purpose:
    - To group data into meaningful categories for targeted insights.
    - For customer segmentation, product categorization, or regional analysis.

SQL Functions Used:
    - CASE: Defines custom segmentation logic.
    - GROUP BY: Groups data into segments.
===============================================================================
*/

/*
Segment Products into Cost Ranges and 
count how many Products fall into Each Segment
*/
WITH Products_Segments AS
(
SELECT 
	product_key,
	product_name,
	cost,
	CASE 
		WHEN cost < 100 THEN 'Below 100'
		WHEN cost < 500 THEN '100 - 499'
		WHEN cost < 1000 THEN '500 - 999'
		ELSE 'Above 1000'
	END Cost_Range
FROM gold.dim_products
)

SELECT 
	Cost_Range,
	COUNT(product_key) AS Total_products
FROM Products_Segments
GROUP BY Cost_Range
ORDER BY Total_products DESC;

/*
Group Customers into Three Segments based on their 'Spending Behavior':
	- VIP: At least 12 Months of History and Spending More than $5,000.
	- Regular: At least 12 Months of History But Spending $5,000 or Less.
	- New: Lifespan less than 12 Months.
and find the total number of customers by each group
*/
WITH Customer_Spending AS
(
SELECT 
	dc.customer_key,
	SUM(sales_amount) AS Cust_Spendings,
	MIN(fc.order_date) AS first_order,
	MAX(fc.order_date) AS last_order,
	DATEDIFF(MONTH,MIN(fc.order_date),MAX(fc.order_date)) AS Lifespan
FROM gold.fact_sales AS fc
LEFT JOIN gold.dim_customers AS dc
ON	fc.customer_key = dc.customer_key
GROUP BY dc.customer_key
)

SELECT 
	Customer_Segment,
	COUNT(customer_key) AS Total_Customers
FROM
	(
	SELECT 
		customer_key,
		Cust_Spendings,
		Lifespan,
		CASE
			WHEN Lifespan >= 12 AND Cust_Spendings > 5000 THEN 'VIP'
			WHEN Lifespan >= 12 AND Cust_Spendings <= 5000 THEN 'Regular'
			ELSE 'New'
		END Customer_Segment
	FROM Customer_Spending
	)t
GROUP BY Customer_Segment
ORDER BY Total_Customers DESC;
