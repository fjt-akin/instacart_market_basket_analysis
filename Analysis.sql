-- Data analysis and insights

-- 1) MARKET BASKET ANALYSIS

-- Analysis: Identify frequently co-occurring products in orders to improve store layout and marketing strategies.
------------------------------------------------------------------------------------------------
-- a) What are the top 10 product pairs that are most frequently purchased together?
 SELECT p1.product_name AS product_1, p2.product_name AS product_2, COUNT(*) AS frequency
 FROM order_products_prior op1
 JOIN order_products_prior op2 ON op2.order_id = op1.order_id AND op1.product_id != op2.product_id
 JOIN products p1 ON p1.product_id = op1.product_id
 JOIN products p2 ON p2.product_id = op2.product_id
 GROUP BY p1.product_name, p2.product_name
 ORDER BY frequency DESC
 LIMIT 10;
 --------------------------------------------------------------------------------------------
 -- b) What are the top 5 products that are most commonly added to the cart first? 
 SELECT 
    p.product_name AS product_name, COUNT(*) AS frequency
FROM
    order_products_prior op
        JOIN
    products p ON p.product_id = op.product_id
WHERE
    op.add_to_cart_order = 1
GROUP BY p.product_name
ORDER BY frequency DESC
LIMIT 5;

-- Banana	110916
-- Bag of Organic Bananas	78988
-- Organic Whole Milk	30927
-- Organic Strawberries	27975
-- Organic Hass Avocado	24116
------------------------------------------------------------------------------------------
-- c) ●	How many  unique products are typically included in a single order?
-- To determine the average number of unique products included in a single order
SELECT 
    AVG(num_products) AS avg_unique_products_per_order
FROM
    (SELECT 
        order_id, COUNT(DISTINCT product_id) AS num_products
    FROM
        order_products_prior
    GROUP BY order_id) AS order_product_count;
    -- 10 unique products per order
-------------------------------------------------------------------------------------------------    
-- 2) CUSTOMER SEGMENTATION

-- Analysis: Group customers based on their purchasing behavior for targeted marketing efforts.
--------------------------------------------------------------------------------------------------
-- a) ●	How many orders have been placed by each customer ?
SELECT user_id, COUNT(*) AS num_orders FROM orders
GROUP BY user_id;
---------------------------------------------------------------------------------------------------------
SELECT MAX(num_orders) FROM 
(SELECT user_id, COUNT(*) AS num_orders FROM orders
GROUP BY user_id) AS order_per_customer;

SELECT MIN(num_orders) FROM 
(SELECT user_id, COUNT(*) AS num_orders FROM orders
GROUP BY user_id) AS order_per_customer;

SELECT AVG(num_orders) FROM 
(SELECT user_id, COUNT(*) AS num_orders FROM orders
GROUP BY user_id) AS order_per_customer;

-- Maximum number of orders placed by a customer is 100
-- Manimum number of orders placed by a customer  is 4
-- Average number of orders placed by a customer  is 17
-------------------------------------------------------------------------------------------------------------

-- b) ●	What are the different customer segments based on purchase frequency?
SELECT 
    user_id,
    CASE
        WHEN num_orders > 50 THEN 'Frequent Buyer'
        WHEN num_orders >= 25 AND num_orders <= 50 THEN 'Regular Buyer'
        ELSE 'Infrequent Buyer'
    END AS customer_segment
FROM
    (SELECT 
        user_id, COUNT(*) AS num_orders
    FROM
        orders
    GROUP BY user_id) AS order_counts;
    
---------------------------------------------------------------------------------------------------------------
    -- C) Number of customers per Segment
    
    SELECT 
    customer_segment, COUNT(*) AS number_of_customers
FROM
    (SELECT 
        user_id,
            CASE
                WHEN num_orders > 50 THEN 'Frequent Buyer'
                WHEN num_orders >= 25 AND num_orders <= 50 THEN 'Regular Buyer'
                ELSE 'Infrequent Buyer'
            END AS customer_segment
    FROM
        (SELECT 
        user_id, COUNT(*) AS num_orders
    FROM
        orders
    GROUP BY user_id) AS order_counts) AS customer_classification
GROUP BY customer_segment;

-- Infrequent Buyer	165998
-- Regular Buyer	29301
-- Frequent Buyer	10910
-------------------------------------------------------------------------------------------------------------------------------

-- 3) SEASONAL TREND ANALYSIS
-- Analysis : Identify seasonal patterns in customer behaviour and product sales

-- a) What is the distribution of orders placed on different days of the week
SELECT 
    order_dow, COUNT(*) AS num_orders
FROM
    orders
GROUP BY order_dow
ORDER BY num_orders DESC;
-- Order_dow	num_orders
-- 0	600905
-- 1	587478
-- 2	467260
-- 5	453368
-- 6	448761
-- 3	436972
-- 4	426339

-- 0 = Sunday, 1 = Monday

-- Customers place more orders on Sundays, while  Thursday has is the slowest day in terms of customer orders
-----------------------------------------------------------------------------------------------------------------------------

-- 4) Customer Churn Prediction
-- Analysis: Predict which customers are most likely to stop using the service in the near future.

-- a) ●	Can we identify customers who haven't placed an order in the last 30 days?
    
SELECT 
    user_id
FROM
    orders
GROUP BY user_id
HAVING MAX(days_since_prior_order) >= 30;
---------------------------------------------------------------------------------------------------------------------------------

 -- b) ●	What percentage of customers have churned in the past quarter?
SELECT 
    COUNT(DISTINCT user_id) AS total_customers,
    SUM(CASE WHEN last_order_date < DATE_SUB(CURDATE(), INTERVAL 90 DAY) THEN 1 ELSE 0 END) AS churned_customers,
    (SUM(CASE WHEN last_order_date < DATE_SUB(CURDATE(), INTERVAL 90 DAY) THEN 1 ELSE 0 END) / COUNT(DISTINCT user_id)) * 100 AS churn_percentage
FROM 
    orders;
-------------------------------------------------------------------------------------------------------------------------------    
-- 5) Product Association Rules
-- Analysis: Identify rules or patterns in customer behavior indicating which products are frequently bought together.

-- a) ●	Can we find products that are often bought together on weekends vs. weekdays?

SELECT 
	order_dow AS Week_Day,
    p1.product_name AS product_1,
    p2.product_name AS product_2
FROM
	orders o
JOIN order_products_prior op1 ON op1.order_id = o.order_id
JOIN order_products_prior op2 ON op2.order_id = op1.order_id AND op2.product_id != op1.product_id
JOIN products p1 ON p1.product_id = op1.product_id
JOIN products p2 ON p2.product_id = op2.product_id
WHERE order_dow IN (6,0) -- taking weeekends as Saturday and Sunday
GROUP BY order_dow, product_1, product_2

UNION ALL

SELECT 
	order_dow AS Week_Day,
    p1.product_name AS product_1,
    p2.product_name AS product_2
FROM
	orders o
JOIN order_products_prior op1 ON op1.order_id = o.order_id
JOIN order_products_prior op2 ON op2.order_id = op1.order_id AND op2.product_id != op1.product_id
JOIN products p1 ON p1.product_id = op1.product_id
JOIN products p2 ON p2.product_id = op2.product_id
WHERE order_dow NOT IN (6,0) -- taking weekday as Monday to Friday
GROUP BY order_dow, product_1, product_2;
