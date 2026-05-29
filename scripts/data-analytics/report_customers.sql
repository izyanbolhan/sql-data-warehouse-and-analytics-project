/*
=============================================================================================
Customer Report
=============================================================================================
Purpose : This report consolidates key customer metrics and behaviours

Highlights : 
1. Gather essential field such as names, ages and transaction details
2. Segment customers into categories (VIP, Regular, New) and age groups
3. Aggregate customer-level metrics:
-total orders
-total sales
-total quantity purchased
-total products
-lifespan (in months)
4. calculate value KPIs:
-recency (months since last order)
-average order value
-average monthly spend 
=============================================================================================
*/
IF OBJECT_ID('gold.report_customers', 'V') IS NOT NULL
    DROP VIEW gold.report_customers;
GO

CREATE VIEW gold.report_customers AS

WITH base_query AS (
/*
==============================================================================================
1. Base Query : retrieve core columns from tables
==============================================================================================
*/
SELECT 
s.order_num AS order_num,
s.product_key AS product_key,
s.order_date AS order_date,
s.sales AS sales,
s.quantity AS quantity,
c.customer_key AS customer_key,
c.customer_number AS customer_number,
CONCAT (c.first_name,' ', c.last_name) AS customer_name,
DATEDIFF (year, c.birthdate, GETDATE()) AS age
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_customers AS c
ON c.customer_key = s.customer_key
WHERE s.order_date IS NOT NULL 
)

/*
==============================================================================================
Customer Aggregations : summarizes key metrics at the customer level
==============================================================================================
*/

, customer_aggregation AS (
SELECT 
customer_key,
customer_number,
customer_name,
age,
COUNT (DISTINCT order_num) AS total_orders,
SUM (sales) AS total_sales,
SUM (quantity) AS total_quantity,
COUNT (DISTINCT product_key) AS total_products,
MAX (order_date) as last_order_date,
DATEDIFF (month, MIN (order_date), MAX (order_date)) AS lifespan
FROM base_query
GROUP BY 
	customer_key,
	customer_number,
	customer_name,
	age
)



/*
==============================================================================================
Customer Segmentation & Valuable KPIS
==============================================================================================
*/
SELECT
customer_key,
customer_number,
customer_name,
age,
CASE
	WHEN age <20 THEN 'Under 20'
	WHEN age BETWEEN 20 AND 29 THEN '20-29'
	WHEN age BETWEEN 30 AND 39 THEN '30-39'
	WHEN age BETWEEN 40 AND 49 THEN '40-49'
	ELSE '50 and above'
END age_group,
CASE 
	WHEN total_sales >= 5000 AND lifespan >=12 THEN 'VIP'
	WHEN total_sales <5000 AND lifespan >=12 THEN 'Regular'
	ELSE 'New'
END customer_segment,
total_orders,
total_sales,
total_quantity,
total_products,
last_order_date,
--compute recency
DATEDIFF(month, last_order_date, GETDATE ()) as recency,
lifespan,
--compute average order value (Av0)
CASE WHEN total_orders = 0 THEN 0
	ELSE total_sales/total_orders 
END AS avg_order_value,
--compute average monthly spend
CASE WHEN lifespan = 0 THEN total_sales
	ELSE total_sales/lifespan
END average_monthly_spend
FROM customer_aggregation

