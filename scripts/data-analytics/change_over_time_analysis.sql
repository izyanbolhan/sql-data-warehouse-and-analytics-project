--Change Over Time Trend -- analyze how a measure evolves over time

SELECT *
FROM gold.fact_sales

--to find total sales, customers and quantity by year
SELECT
YEAR(order_date) AS year,
SUM (sales) AS total_sales,
COUNT (DISTINCT customer_key) AS total_customers,
SUM (quantity) AS total_quantity
FROM gold.fact_sales
WHERE YEAR (order_date) IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY YEAR (order_date) ASC

--to find total sales, customers and quantity by month
SELECT
MONTH (order_date) AS month,
SUM (sales) AS total_sales,
COUNT (DISTINCT customer_key) AS total_customers,
SUM (quantity) AS total_quantity
FROM gold.fact_sales
WHERE MONTH (order_date) IS NOT NULL
GROUP BY MONTH (order_date)
ORDER BY MONTH (order_date) ASC
-- december shows the highest sales and february is the worst sales

-- to find total sales,customer and quantity by month year
SELECT
YEAR(order_date) AS year,
MONTH (order_date) AS month,
SUM (sales) AS total_sales,
COUNT (DISTINCT customer_key) AS total_customers,
SUM (quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date),MONTH (order_date)
ORDER BY YEAR(order_date), MONTH (order_date) ASC

