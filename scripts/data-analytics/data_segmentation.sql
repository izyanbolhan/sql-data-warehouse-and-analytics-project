--Data Segmentation

--to segment products into cost range and count how many products fall into each segment

WITH product_segment AS (
SELECT 
product_key,
product_name,
cost,
CASE 
	WHEN cost <100 THEN 'Below 100'
	WHEN cost BETWEEN 100 AND 500 THEN '100-500'
	WHEN cost BETWEEN 500 and 1000 THEN '500-1000'
	ELSE 'Above 1000'
	END cost_range
FROM gold.dim_products
)

SELECT
cost_range,
COUNT (product_key) AS total_products
FROM product_segment
GROUP BY cost_range
ORDER BY total_products DESC

--Group bucstomers into three segments based on their spending behaviour :
--VIP : Customers with at least 12 months of history and spending more than 5000
--Regular : Customers with at least 12 months of history but sepnding 5000 or less
--New : Customers with a lifespan less than 12 months
--and find the total number of customers for each group

WITH customer_order_segment AS (
SELECT
c.customer_key as customer_key,
SUM (s.sales) as total_sales,
COUNT (order_date) as total_orders,
MIN (order_date) as first_order,
MAX (order_date) as last_order,
DATEDIFF (month, MIN (order_date), MAX (order_date)) AS lifespan
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_customers AS c
ON s.customer_key = c.customer_key
GROUP BY c.customer_key
)

SELECT 
customer_segment,
COUNT (customer_key) AS total_customers
FROM (
SELECT
customer_key,
CASE 
	WHEN total_sales >= 5000 AND lifespan >=12 THEN 'VIP'
	WHEN total_sales <5000 AND lifespan >=12 THEN 'Regular'
	ELSE 'New'
END customer_segment
FROM customer_order_segment
)t
GROUP BY customer_segment
