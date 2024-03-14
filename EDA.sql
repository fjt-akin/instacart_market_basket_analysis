-- EXPLORATORY DATA ANALYSIS

-- The aim of this is to conduct EDA to understand the characteristics of the data and also generate descriptive statistics to gain 
-- initial insight

-- 1) Count the number of aisles
SELECT 
    COUNT(*) AS num_aisles
FROM
    aisles;
-- number of aisles is 134

-- 2) Count the number of departments 
SELECT 
    COUNT(*) AS num_departments
FROM
    departments;
-- number of departments is 21

-- 3) Calculate the total number of orders for the different evaluation sets.
-- A) PRIOR
SELECT 
    COUNT(*)
FROM
    orders
WHERE
    eval_set = 'prior';
-- 3,214,874 prior orders

 -- B) TRAIN
SELECT 
    COUNT(*)
FROM
    orders
WHERE
    eval_set = 'train';
    -- 131,209 train orders

 -- C) TEST
SELECT 
    COUNT(*)
FROM
    orders
WHERE
    eval_set = 'test';
-- 75,000 test Orders

-- Evaluation set 'Prior' has the highest number of orders. 

-- 4) Find the top 10 most frequently re-ordered product.
SELECT 
    product_id, COUNT(*) AS num_reordered
FROM
    order_products_prior
WHERE
    reordered = 1
GROUP BY product_id
ORDER BY num_reordered DESC
LIMIT 5;
-- 0	Banana	398609
-- 1	Bag of Organic Bananas	315913
-- 2	Organic Strawberries	205845
-- 3	Organic Baby Spinach	186884
-- 4	Organic Hass Avocado	170131
-- 5	Organic Avocado	134044
-- 6	Organic Whole Milk	114510
-- 7	Large Lemon	106255
-- 8	Organic Raspberries	105409
-- 9	Strawberries	99802

-- 5) Find the average number of days since prior orders
SELECT 
    round(AVG(days_since_prior_order)) AS avg_days_since_prior_orders
FROM
    orders
WHERE
    days_since_prior_order IS NOT NULL;
-- 10 days

-- 6) Identify the busiest day of the week for placing orders
SELECT 
    order_dow, COUNT(*) AS num_orders
FROM
    orders
GROUP BY order_dow
ORDER BY num_orders
LIMIT 1;
-- Thursday is the busiest day of the week for placing orders at 426,339 orders.

-- 7) Count the number of unique users
SELECT 
    COUNT(DISTINCT (user_id)) AS num_users
FROM
    orders;
    -- we have 206,209 users.

