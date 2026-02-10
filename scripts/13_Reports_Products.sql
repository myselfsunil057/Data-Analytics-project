/*
=========================================================================
                    Product Report
=========================================================================
Purpose:
 - This report consolidates key Product metrics and behaviors

Highlights:
 * Gathers essential fields such as Product names, category, subcategory and cost
 * Segments Product by Revenue to Identify High-Performer, Mid-Performer or Low-Performer
 * Aggregates Product-level metrics:
   * total orders
   * total sales
   * total quantity sold
   * total customers (unique)
   * lifespan (in months)
 * Calculates valuable KPIs:
   * recency (months since last sale)
   * average order Revenue (AOV = Total Revenue / Total No.of Orders)
   * average monthly Revenue (AMS = Total Revenue / No.of Months)
     =========================================================================
*/

--------------------------------------------------------------------------------
--        Base Query: Retrieves Core Columns from Tables
--------------------------------------------------------------------------------
CREATE VIEW gold.report_product AS

WITH base_query AS
(
SELECT 
    fc.order_number,
    fc.customer_key,
    fc.order_date,
    fc.sales_amount,
    fc.quantity,
    dp.product_key,
    dp.product_name,
    dp.category,
    dp.subcategory,
    dp.cost
FROM gold.fact_sales AS fc
LEFT JOIN  gold.dim_products AS dp
ON     fc.product_key = dp.product_key
WHERE fc.order_date IS NOT NULL
)
--------------------------------------------------------------------------------
--     Products Aggregations: Summarizes key metrics at the Product Level
--------------------------------------------------------------------------------
, product_aggregation AS
(
SELECT 
    product_key,
    product_name,
    category,
    subcategory,
    cost,
    COUNT(DISTINCT order_number) AS Total_Orders,
    SUM(sales_amount) AS Total_Revenue,
    COUNT(DISTINCT customer_key) AS Total_Customers,
    SUM(quantity) AS Total_Quantity,
    MIN(order_date) AS First_Order,
    MAX(order_date) AS Last_Order,
    DATEDIFF(MONTH,MIN(order_date),MAX(order_date)) AS Lifespan,
    ROUND(AVG(CAST(sales_amount AS FLOAT) / NULLIF (quantity,0)),1) AS avg_selling_price
FROM base_query
GROUP BY  
    product_key,
    product_name,
    category,
    subcategory,
    cost
)

SELECT
    product_key,
    product_name,
    category,
    subcategory,
    cost,
    CASE
		WHEN Total_Revenue > 50000 THEN 'High-Performer'
		WHEN Total_Revenue > 10000 THEN 'Mid-Performer'
		ELSE 'Low-Performer'
	END Product_Segment,
    Last_Order,
    DATEDIFF(MONTH,Last_Order,GETDATE()) AS Recency,
    Total_Orders,
    Total_Revenue,
    Total_Customers,
    Total_Quantity,
    Lifespan,
    avg_selling_price,
    CASE             
        WHEN Total_Revenue = 0 OR Total_Orders = 0 THEN 0
        ELSE Total_Revenue / Total_Orders
    END Average_order_Revenue,       -- Compute Average Order Revenue (AVO)                                     
    CASE             
        WHEN Total_Revenue = 0 OR Lifespan = 0 THEN Total_Revenue
        ELSE Total_Revenue / Lifespan
    END Average_Month_Revenue  -- Compute Average Month Revenue  (AMS)    
FROM product_aggregation

