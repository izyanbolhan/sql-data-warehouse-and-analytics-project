/*
===============================================================================
Product Report
===============================================================================
Purpose:
    - This report consolidates key product metrics and behaviors.

Highlights:
    1. Gathers essential fields such as product name, category, subcategory, and cost.
    2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
    3. Aggregates product-level metrics:
       - total orders
       - total sales
       - total quantity sold
       - total customers (unique)
       - lifespan (in months)
    4. Calculates valuable KPIs:
       - recency (months since last sale)
       - average order revenue (AOR)
       - average monthly revenue
===============================================================================

=============================================================================
Create Report: gold.report_products
=============================================================================
*/
IF OBJECT_ID('gold.report_products', 'V') IS NOT NULL
    DROP VIEW gold.report_products;
GO

CREATE VIEW gold.report_products AS

WITH base_query AS (
/*
==============================================================================================
1. Base Query : retrieve core columns from tables
==============================================================================================
*/
SELECT
p.product_key,
p.product_name,
p.category,
p.subcategory,
p.cost,
s.quantity,
s.sales,
s.order_num,
s.customer_key,
s.order_date
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products AS p
ON s.product_key = p.product_key
WHERE order_date IS NOT NULL
)


/*
==============================================================================================
Customer Aggregations : summarizes key metrics at the customer level
==============================================================================================
*/
, product_aggregation AS (
SELECT 
product_key,
product_name,
category,
subcategory,
cost,
SUM(quantity) as total_quantity,
SUM (sales) AS total_sales,
COUNT (order_num) as total_orders,
COUNT (DISTINCT customer_key) as total_customers,
DATEDIFF (Month, MIN (order_date), MAX (order_date)) as lifespan,
MAX (order_date) AS last_order_date
FROM base_query
GROUP BY
    product_key,
    product_name,
    category,
    subcategory,
    cost
)

/*
==============================================================================================
Product Segmentation & Valuable KPIS
==============================================================================================
*/

SELECT
product_key,
product_name,
category,
subcategory,
cost,
total_quantity,
total_sales,
total_orders,
total_customers,
lifespan,
last_order_date,
DATEDIFF (Month, last_order_date, GETDATE()) AS recency,
CASE
	WHEN total_sales > 50000 THEN 'High-Performer'
	WHEN total_sales >= 10000 THEN 'Mid-Range'
	ELSE 'Low-Performer'
END AS product_segment,
--compute average order value (Av0)
CASE WHEN total_orders = 0 THEN 0
	ELSE total_sales/total_orders 
END AS avg_order_rev,
--compute average monthly revenue
CASE WHEN lifespan = 0 THEN total_sales
	ELSE total_sales/lifespan
END average_monthly_revenue
FROM product_aggregation
