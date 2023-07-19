-- OVERALL SALES TRENDS
-- Question 1: What are the monthly and quarterly sales trends for Macbooks sold in North America across all years?

-- separate time periods using purchase_ts from the orders table
-- sales metrics: find the order count, total sales, and aov by quarter
-- filter to product for macbooks and region for NA (North America)
-- clean up product name
-- round for readability

WITH monthly_trends AS (
SELECT DATE_TRUNC(orders.purchase_ts, month) as purchase_month,
  geo_lookup.region AS region,
  COUNT(DISTINCT orders.id) AS order_count,
  ROUND(SUM(orders.usd_price),2) AS total_sales,
  ROUND(AVG(orders.usd_price),2) AS aov
FROM `elist-390902.elist.orders` AS orders
INNER JOIN `elist-390902.elist.customers` AS customers
  ON orders.customer_id = customers.id
LEFT JOIN `elist-390902.elist.geo_lookup` AS geo_lookup
  ON customers.country_code = geo_lookup.country
WHERE lower(orders.product_name) LIKE '%macbook%'
  AND geo_lookup.region = 'NA'
GROUP BY 1,2
ORDER BY 1 DESC, 2),

quarterly_trends AS (
SELECT DATE_TRUNC(orders.purchase_ts, quarter) as purchase_quarter,
  geo_lookup.region AS region,
  COUNT(DISTINCT orders.id) AS order_count,
  ROUND(SUM(orders.usd_price),2) AS total_sales,
  ROUND(AVG(orders.usd_price),2) AS aov
FROM `elist-390902.elist.orders` AS orders
INNER JOIN `elist-390902.elist.customers` AS customers
  ON orders.customer_id = customers.id
LEFT JOIN `elist-390902.elist.geo_lookup` AS geo_lookup
  ON customers.country_code = geo_lookup.country
WHERE lower(orders.product_name) LIKE '%macbook%'
  AND geo_lookup.region = 'NA'
GROUP BY 1,2
ORDER BY 1 DESC, 2)

-- summary stats
SELECT ROUND(AVG(monthly_trends.order_count),2) AS monthly_order_count,
  ROUND(AVG(monthly_trends.total_sales),2) AS monthly_total_sales,
  ROUND(AVG(monthly_trends.aov)) AS monthly_aov,
  ROUND(AVG(quarterly_trends.order_count),2) AS quarterly_order_count,
  ROUND(AVG(quarterly_trends.total_sales),2) AS quarterly_total_sales,
  ROUND(AVG(quarterly_trends.aov),2) AS quarterly_aov
FROM monthly_trends
INNER JOIN quarterly_trends
  ON monthly_trends.region = quarterly_trends.region;

-- Question 2: What was the monthly refund rate for purchases made in 2020? How many refunds did we have each month in 2021 for Apple products? 

-- refund rate = total refunds / total orders
-- label refunds (1) and not refunds (0) using CASE WHEN

-- filter to 2020
WITH refunds_2020 AS (
  SELECT DATE_TRUNC(orders.purchase_ts, month) AS month,
    SUM(CASE WHEN order_status.refund_ts IS NOT NULL THEN 1 ELSE 0 END) AS refunds,
    (SUM(CASE WHEN order_status.refund_ts IS NOT NULL THEN 1 ELSE 0 END))/(COUNT(DISTINCT orders.id)) AS refund_rate
  FROM `elist-390902.elist.orders` AS orders
  LEFT JOIN `elist-390902.elist.order_status` AS order_status
    ON orders.id = order_status.order_id
  WHERE EXTRACT(year FROM orders.purchase_ts) = 2020
  GROUP BY 1
  ORDER BY 1 DESC)

SELECT AVG(refunds_2020.refund_rate) AS monthly_refund_rate,
  MIN(refunds_2020.refund_rate) AS min_refund_rate,
  MAX(refunds_2020.refund_rate) AS max_refund_rate
FROM refunds_2020;

-- filter to 2021 and Apple products (including Macbooks)
WITH refunds_apple AS(
  SELECT DATE_TRUNC(order_status.refund_ts, month) AS month,
    SUM(CASE WHEN order_status.refund_ts IS NOT NULL THEN 1 ELSE 0 END) AS refunds
  FROM `elist-390902.elist.orders` AS orders
  LEFT JOIN `elist-390902.elist.order_status` AS order_status
    ON orders.id = order_status.order_id
  WHERE EXTRACT(year FROM order_status.refund_ts) = 2021
    AND (lower(orders.product_name) LIKE '%apple%'
    OR lower(orders.product_name) LIKE '%macbook%')
  GROUP BY 1
  ORDER BY 1 DESC)

SELECT MIN(refunds_apple.refunds) AS min_refunds,
  MAX(refunds_apple.refunds) AS max_refunds,
  AVG(refunds_apple.refunds) AS average_refunds
FROM refunds_apple;

-- Question 3: Are there certain products that are getting refunded more frequently than others? What are the top 3 most frequently refunded products across all years? What are the top 3 products that have the highest count of refunds?

-- clean product name, remove duplicate name
-- order by refund rate (frequency) descending

SELECT CASE WHEN orders.product_name = '27in"" 4k gaming monitor' THEN '27in 4K gaming monitor' ELSE orders.product_name END as product_name_cleaned,
  SUM(CASE WHEN order_status.refund_ts IS NOT NULL THEN 1 ELSE 0 END) AS refunds,
  (SUM(CASE WHEN order_status.refund_ts IS NOT NULL THEN 1 ELSE 0 END))/(COUNT(DISTINCT orders.id)) AS refund_rate
FROM `elist-390902.elist.orders` AS orders
LEFT JOIN `elist-390902.elist.order_status` AS order_status
  ON orders.id = order_status.order_id
GROUP BY 1
ORDER BY 3 DESC;

-- order by refund count descending
SELECT CASE WHEN orders.product_name = '27in"" 4k gaming monitor' THEN '27in 4K gaming monitor' ELSE orders.product_name END as product_name_cleaned,
  SUM(CASE WHEN order_status.refund_ts IS NOT NULL THEN 1 ELSE 0 END) AS refunds,
  (SUM(CASE WHEN order_status.refund_ts IS NOT NULL THEN 1 ELSE 0 END))/(COUNT(DISTINCT orders.id)) AS refund_rate
FROM `elist-390902.elist.orders` AS orders
LEFT JOIN `elist-390902.elist.order_status` AS order_status
  ON orders.id = order_status.order_id
GROUP BY 1
ORDER BY 2 DESC;

-- Question 4: What’s the average order value across different account creation methods in the first two months of 2022? Which method had the most new customers in this time?

-- filter created_on to first two months
-- order by customer count
SELECT customers.account_creation_method AS account_creation_method,
  AVG(orders.usd_price) AS aov,
  COUNT(DISTINCT orders.id) AS customer_count
FROM `elist-390902.elist.orders` AS orders
INNER JOIN `elist-390902.elist.customers` AS customers
  ON orders.customer_id = customers.id
WHERE customers.created_on BETWEEN '2022-01-01' AND '2022-02-28'
GROUP BY 1
ORDER BY 3 DESC;

-- Question 5: What’s the average time between customer registration and placing an order?

-- find days to purchase through date difference
-- determine the average of the days to purchase

WITH days_to_purchase_cte AS (
SELECT customers.id AS customers_id,
  orders.id AS orders_id,
  customers.created_on,
  orders.purchase_ts,
  DATE_DIFF(orders.purchase_ts, customers.created_on, day) AS days_to_purchase
FROM `elist-390902.elist.customers` AS customers
INNER JOIN `elist-390902.elist.orders` AS orders
  ON customers.id = orders.customer_id
ORDER BY 1,2,3)

SELECT AVG(days_to_purchase_cte.days_to_purchase) AS avg_days_to_purchase,
  AVG(days_to_purchase_cte.days_to_purchase)/30 AS avg_months 
FROM days_to_purchase_cte;

-- delivery time
WITH days_to_deliver_cte AS (
SELECT order_status.order_id AS order_id,
  DATE_DIFF(order_status.delivery_ts, order_status.purchase_ts, day) AS days_to_deliver
FROM `elist-390902.elist.order_status` AS order_status
)

SELECT AVG(days_to_deliver_cte.days_to_deliver) AS avg_days_to_deliver 
FROM days_to_deliver_cte;

-- Question 6: Which marketing channels perform the best in each region? Does the top channel differ across regions?

-- in this case best is defined as total sales
WITH region_orders AS (
  SELECT geo_lookup.region AS region,
    customers.marketing_channel AS marketing_channel,
    COUNT(DISTINCT orders.id) as order_count,
    (ROUND(SUM(orders.usd_price),2)) AS total_sales,
    (ROUND(AVG(orders.usd_price),2)) AS aov
  FROM `elist-390902.elist.customers` AS customers
  LEFT JOIN `elist-390902.elist.geo_lookup` AS geo_lookup
    ON customers.country_code = geo_lookup.country
  INNER JOIN `elist-390902.elist.orders` AS orders
    ON customers.id = orders.customer_id
GROUP BY 1,2
ORDER BY 1,2)

SELECT *,
  ROW_NUMBER() OVER (PARTITION BY region_orders.region ORDER BY region_orders.total_sales DESC) AS ranking
FROM region_orders
ORDER BY 6 ASC;
