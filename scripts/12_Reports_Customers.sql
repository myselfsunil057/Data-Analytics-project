/*
=========================================================================
                            Customer Report
=========================================================================
Purpose:
 * This report consolidates key customer metrics and behaviors
Highlights:
 * Gathers essential fields such as names, ages, and transaction details.
 * Segments customers into categories (VIP, Regular, New) and age groups.
 * Aggregates customer-level metrics:
   * total orders
   * total sales
   * total quantity purchased
   * total products
   * lifespan (in months)
 * Calculates valuable KPIs:
   * recency (months since last order)
   * average order value (AOV = Total Sales / Total No.of Orders)
   * average monthly spend (AMS = Total Sales / No.of Months)
     =========================================================================
*/

--------------------------------------------------------------------------------
--        Base Query: Retrieves Core Columns from Tables
--------------------------------------------------------------------------------

CREATE VIEW gold.report_customer AS

WITH base_query AS
(
SELECT 
    fc.order_number,
    fc.product_key,
    fc.order_date,
    fc.sales_amount,
    fc.quantity,
    dc.customer_key,
    dc.customer_number,
    CONCAT(dc.first_name,' ',dc.last_name) AS Customer_Name,
    DATEDIFF(YEAR,dc.birthdate,GETDATE()) AS Age
FROM gold.fact_sales AS fc
LEFT JOIN  gold.dim_customers AS dc
ON     fc.customer_key = dc.customer_key
WHERE fc.order_date IS NOT NULL
)
--------------------------------------------------------------------------------
--     Customer Aggregations: Summarizes key metrics at the Customer Level
--------------------------------------------------------------------------------
, customer_aggregation AS
(
SELECT 
    customer_key,
    customer_number,
    Customer_Name,
    Age,
    COUNT(DISTINCT order_number) AS Total_Orders,
    SUM(sales_amount) AS Total_Sales,
    COUNT(DISTINCT product_key) AS Total_Products,
    SUM(quantity) AS Total_Quantity,
    MIN(order_date) AS First_Order,
    MAX(order_date) AS Last_Order,
    DATEDIFF(MONTH,MIN(order_date),MAX(order_date)) AS Lifespan
FROM base_query
GROUP BY  
    customer_key,
    customer_number,
    Customer_Name,
    Age
)

SELECT
    customer_key,
    customer_number,
    Customer_Name,
    Age,
    CASE
		WHEN Age < 20  THEN 'Under 20'
		WHEN Age BETWEEN 20 AND 29  THEN '20 - 29'
        WHEN Age BETWEEN 30 AND 39  THEN '30 - 39'
        WHEN Age BETWEEN 40 AND 49  THEN '40 - 49'
		ELSE '50 and Above'
	END Age_Group,
    CASE
		WHEN Lifespan >= 12 AND Total_Sales > 5000 THEN 'VIP'
		WHEN Lifespan >= 12 AND Total_Sales <= 5000 THEN 'Regular'
		ELSE 'New'
	END Customer_Segment,
    Last_Order,
    DATEDIFF(MONTH,Last_Order,GETDATE()) AS Recency,
    Total_Orders,
    Total_Sales,
    Total_Products,
    Total_Quantity,
    Lifespan,
    CASE             
        WHEN Total_Sales = 0 OR Total_Orders = 0 THEN 0
        ELSE Total_Sales / Total_Orders
    END Average_order_value,       -- Compute Average Order Value (AVO)                                     
    CASE             
        WHEN Total_Sales = 0 OR Lifespan = 0 THEN Total_Sales
        ELSE Total_Sales / Lifespan
    END Average_Month_Spend -- Compute Average Month Spend (AMS)    
FROM customer_aggregation



