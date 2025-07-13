USE pizza_sales;

SELECT TOP 10 * FROM sales;
--checking the num of rows and distinct orders

SELECT COUNT(*) AS total_rows FROM sales;

SELECT COUNT(DISTINCT order_id) AS unique_orders FROM sales;
--checking for missing values
SELECT 
  SUM(CASE WHEN pizza_id IS NULL THEN 1 ELSE 0 END) AS null_pizza_id,
  SUM(CASE WHEN pizza_name_id IS NULL THEN 1 ELSE 0 END) AS null_pizza_name_id,
  SUM(CASE WHEN quantity IS NULL THEN 1 ELSE 0 END) AS null_quantity,
  SUM(CASE WHEN unit_price IS NULL THEN 1 ELSE 0 END) AS null_unit_price
FROM sales;
--checking for duplicates
SELECT pizza_id, order_id, COUNT(*) AS dup_count
FROM sales
GROUP BY pizza_id, order_id
HAVING COUNT(*) > 1;
--checking for outliers
SELECT * 
FROM sales
WHERE quantity < 0 OR quantity > 20;

SELECT * 
FROM sales
WHERE unit_price < 0 OR unit_price > 100;

--Top 5 Best Selling Pizzas
SELECT TOP 5 pizza_name, SUM(quantity) AS total_sold
FROM sales
GROUP BY pizza_name
ORDER BY total_sold DESC;

--Total revenue per pizza size
SELECT pizza_size, SUM(total_price) AS total_revenue
FROM sales
GROUP BY pizza_size
ORDER BY total_revenue DESC;

--Monthly Sales Trend (Revenue by Month)
SELECT 
  FORMAT(order_date, 'yyyy-MM') AS order_month,
  SUM(total_price) AS monthly_revenue
FROM sales
GROUP BY FORMAT(order_date, 'yyyy-MM')
ORDER BY order_month;

--Average Order Value (AOV)
SELECT 
  AVG(order_total) AS average_order_value
FROM (
  SELECT order_id, SUM(total_price) AS order_total
  FROM sales
  GROUP BY order_id
) AS sub;
--Sales by Pizza Category
SELECT 
  pizza_category,
  SUM(quantity) AS total_quantity,
  SUM(total_price) AS total_revenue
FROM sales
GROUP BY pizza_category
ORDER BY total_revenue DESC;

--Sales by Pizza Size
SELECT 
  pizza_size,
  SUM(quantity) AS total_quantity,
  SUM(total_price) AS total_revenue
FROM sales
GROUP BY pizza_size
ORDER BY total_revenue DESC;

--Sales by Hour (Peak Order Times)
SELECT 
  DATEPART(HOUR, order_time) AS order_hour,
  COUNT(*) AS total_orders,
  SUM(total_price) AS total_revenue
FROM sales
GROUP BY DATEPART(HOUR, order_time)
ORDER BY order_hour;

--Sales by Day of the Week
SELECT 
  DATENAME(WEEKDAY, order_date) AS day_of_week,
  COUNT(*) AS total_orders,
  SUM(total_price) AS total_revenue
FROM sales
GROUP BY DATENAME(WEEKDAY, order_date)
ORDER BY 
  CASE 
    WHEN DATENAME(WEEKDAY, order_date) = 'Monday' THEN 1
    WHEN DATENAME(WEEKDAY, order_date) = 'Tuesday' THEN 2
    WHEN DATENAME(WEEKDAY, order_date) = 'Wednesday' THEN 3
    WHEN DATENAME(WEEKDAY, order_date) = 'Thursday' THEN 4
    WHEN DATENAME(WEEKDAY, order_date) = 'Friday' THEN 5
    WHEN DATENAME(WEEKDAY, order_date) = 'Saturday' THEN 6
    WHEN DATENAME(WEEKDAY, order_date) = 'Sunday' THEN 7
  END;

  --Monthly Pizza Category Performance
  SELECT 
  FORMAT(order_date, 'yyyy-MM') AS order_month,
  pizza_category,
  SUM(total_price) AS revenue
FROM sales
GROUP BY FORMAT(order_date, 'yyyy-MM'), pizza_category
ORDER BY order_month, revenue DESC;
