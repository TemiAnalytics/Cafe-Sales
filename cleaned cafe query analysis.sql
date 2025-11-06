SELECT * FROM cafe_sales_cleaned

-- 🧾 Overall performance summary
SELECT
    COUNT(DISTINCT transaction_id) AS total_transactions,
    SUM(total_spent) AS total_revenue,
    AVG(total_spent) AS avg_transaction_value,
    SUM(quantity) AS total_items_sold
FROM cafe_sales_cleaned;

-- 🍩 Top 10 most popular items
SELECT
    item,
    SUM(quantity) AS total_quantity_sold,
    SUM(total_spent) AS total_revenue
FROM cafe_sales_cleaned
GROUP BY item
ORDER BY total_revenue DESC
LIMIT 10;

-- 🏠 Revenue distribution across branches
SELECT
    location,
    COUNT(transaction_id) AS num_transactions,
    SUM(total_spent) AS total_revenue,
    ROUND(SUM(total_spent) / (SELECT SUM(total_spent) FROM cafe_sales_cleaned) * 100, 2) AS percent_share
FROM cafe_sales_cleaned
GROUP BY location
ORDER BY total_revenue DESC;

-- 💳 Payment channel performance
SELECT
    payment_method,
    COUNT(transaction_id) AS num_transactions,
    SUM(total_spent) AS total_revenue,
    ROUND(SUM(total_spent) / (SELECT SUM(total_spent) FROM cafe_sales_cleaned) * 100, 2) AS percent_share
FROM cafe_sales_cleaned
GROUP BY payment_method
ORDER BY total_revenue DESC;

-- 📈 Monthly revenue trend
SELECT
    DATE_FORMAT(transaction_date, '%Y-%m') AS month,
    SUM(total_spent) AS total_revenue,
    SUM(quantity) AS total_items_sold,
    COUNT(transaction_id) AS total_transactions
FROM cafe_sales_cleaned
GROUP BY DATE_FORMAT(transaction_date, '%Y-%m')
ORDER BY month;

-- 🗓️ Which days are busiest?
SELECT
    DAYNAME(transaction_date) AS day_of_week,
    COUNT(transaction_id) AS total_transactions,
    ROUND(SUM(total_spent),2) AS total_revenue
FROM cafe_sales_cleaned
GROUP BY DAYNAME(transaction_date)
ORDER BY total_revenue DESC;



























