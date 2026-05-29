--Cumulative Analysis

--to calculate the total sales per month
--the running total of sales over time
--the moving average of price
SELECT
order_date,
total_sales,
average_price,
SUM (total_sales) OVER (ORDER BY order_date) AS running_total_sales,
AVG (average_price)  OVER (ORDER BY order_date) AS moving_average_price
FROM (
SELECT 
DATETRUNC (month, order_date) AS order_date,
SUM (sales) AS total_sales,
AVG (price) AS average_price
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC (month, order_date)
)t

--to calculate the total sales per month and the running total of sales for each year
SELECT
order_date,
total_sales,
SUM (total_sales) OVER (PARTITION BY order_date ORDER BY order_date) AS running_total_sales
FROM (
SELECT 
DATETRUNC (month, order_date) AS order_date,
SUM (sales) AS total_sales
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC (month, order_date)
)t
