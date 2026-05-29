--Performance Analysis : comparing the current value to a target value

-- to analyze the yearly performance of products by comparing each product's sales to both its average sales performance and the previous year's sales

SELECT *
FROM gold.dim_products;

SELECT *
FROM gold.fact_sales;

WITH yearly_product_sales AS (
SELECT 
YEAR (s.order_date) AS order_year,
p.product_name,
SUM (s.sales) AS current_sales
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products AS p
ON s.product_key = p.product_key
WHERE s.order_date IS NOT NULL
GROUP BY YEAR(s.order_date), p.product_name
)

SELECT
order_year,
product_name,
current_sales,
AVG (current_sales) OVER (PARTITION BY product_name) AS average_Sales,
current_sales - AVG (current_sales) OVER (PARTITION BY product_name) AS diff_avg,
CASE 
	WHEN current_sales - AVG (current_sales) OVER (PARTITION BY product_name) > 0 THEN 'Above Average'
	WHEN current_sales - AVG (current_sales) OVER (PARTITION BY product_name) < 0 THEN 'Below Average'
	ELSE 'Average'
END avg_change,
--Year Over Year Analysis
LAG (current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS prev_year_sales,
current_sales - LAG (current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS diff_prev_year,
CASE 
	WHEN current_sales - LAG (current_sales) OVER (PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increase'
	WHEN current_sales - LAG (current_sales) OVER (PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decrease'
	ELSE 'No change'
END  prev_year_change
FROM yearly_product_sales
ORDER BY product_name, order_year
