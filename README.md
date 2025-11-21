# Cafe-Sales Using SQL

# ☕ Café Sales Data Cleaning & Analysis (MySQL Project)

## 📘 Project Overview
This project focuses on cleaning, transforming, and analyzing café sales data using **MySQL**.  
The dataset contains transaction records from a café business affected by **renovations**, **economic factors**, and **customer loss**.  
The goal is to:
- Clean inconsistent and missing data.
- Generate insights into sales trends, customer behavior, and revenue.
- Demonstrate SQL data cleaning and analysis for real-world decision-making.

---

## 🧩 Dataset Description
The dataset (`dirty_cafe_sales.csv`) contains daily transaction records with the following columns:

| Column Name | Description |
|--------------|-------------|
| transaction_id | Unique transaction identifier |
| item | Product sold (coffee, snacks, bar items, etc.) |
| quantity | Number of items purchased |
| price_per_unit | Unit price of each item |
| total_spent | Total cost of the transaction |
| payment_method | Payment channel (cash, POS, transfer) |
| location | Branch location |
| transaction_date | Date of transaction |

---

## 🧹 Data Cleaning Process (Using MySQL)
The raw dataset had **null values**, **“Unknown”**, and **“Error”** entries, as well as some invalid data types.  
The cleaning was done entirely in MySQL following the steps below.

### 1️⃣ Load Data
```sql
CREATE DATABASE cafe_sales;
USE cafe_sales;

LOAD DATA INFILE 'dirty_cafe_sales.csv'
INTO TABLE cafe_sales
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;

CREATE TABLE cafe_sales_cleaned AS
SELECT 
    transaction_id,
    item,
    quantity,
    price_per_unit,
    total_spent,
    payment_method,
    location,
    transaction_date
FROM cafe_sales;

DELETE FROM cafe_sales_cleaned
WHERE 
    transaction_id IS NULL
    OR item IS NULL
    OR payment_method IS NULL
    OR location IS NULL
    OR transaction_date IS NULL
    OR payment_method IN ('Unknown', 'Error')
    OR location IN ('Unknown', 'Error');

ALTER TABLE cafe_sales_cleaned 
MODIFY COLUMN quantity DECIMAL(10,2),
MODIFY COLUMN price_per_unit DECIMAL(10,2),
MODIFY COLUMN total_spent DECIMAL(12,2),
MODIFY COLUMN transaction_date DATE;

SELECT 
  SUM(CASE WHEN transaction_id IS NULL THEN 1 ELSE 0 END) AS null_id,
  SUM(CASE WHEN payment_method IN ('Unknown', 'Error') THEN 1 ELSE 0 END) AS bad_payment,
  SUM(CASE WHEN location IN ('Unknown', 'Error') THEN 1 ELSE 0 END) AS bad_location
FROM cafe_sales_cleaned;

📊 Data Analysis & Insights

Below are some key SQL queries and their business insights.

 1. -- 🧾 Overall performance summary
SELECT
    COUNT(DISTINCT transaction_id) AS total_transactions,
    SUM(total_spent) AS total_revenue,
    AVG(total_spent) AS avg_transaction_value,
    SUM(quantity) AS total_items_sold
FROM cafe_sales_cleaned;
Insight: Provides the overall sales performance, including total transactions, revenue, and quantity sold.

2.  -- 🍩 Top 10 most popular items
SELECT
    item,
    SUM(quantity) AS total_quantity_sold,
    SUM(total_spent) AS total_revenue
FROM cafe_sales_cleaned
GROUP BY item
ORDER BY total_revenue DESC
LIMIT 10;
Insight: Identifies the top 10 best-selling items by revenue and quantity.

3. -- 💳 Payment channel performance
SELECT
    payment_method,
    COUNT(transaction_id) AS num_transactions,
    SUM(total_spent) AS total_revenue,
    ROUND(SUM(total_spent) / (SELECT SUM(total_spent) FROM cafe_sales_cleaned) * 100, 2) AS percent_share
FROM cafe_sales_cleaned
GROUP BY payment_method
ORDER BY total_revenue DESC;
Insight: Shows which payment channels contribute most to revenue and their percentage share.

4. -- 📈 Monthly revenue trend
SELECT
    DATE_FORMAT(transaction_date, '%Y-%m') AS month,
    SUM(total_spent) AS total_revenue,
    SUM(quantity) AS total_items_sold,
    COUNT(transaction_id) AS total_transactions
FROM cafe_sales_cleaned
GROUP BY DATE_FORMAT(transaction_date, '%Y-%m')
ORDER BY month;
Insight: Displays monthly revenue and transaction counts, helping identify growth or decline trends.

5. -- 🗓️ Which days are busiest?
SELECT
    DAYNAME(transaction_date) AS day_of_week,
    COUNT(transaction_id) AS total_transactions,
    ROUND(SUM(total_spent),2) AS total_revenue
FROM cafe_sales_cleaned
GROUP BY DAYNAME(transaction_date)
ORDER BY total_revenue DESC;
Insight: Highlights which days generate the highest revenue and transaction volume.

💡 Key Insights
-The café’s performance shows clear sales trends by item and period.
-Certain products dominate sales, while others contribute less to revenue.
-Payment method preference can guide POS and cash management decisions.
-Weekday and monthly trends reveal peak operating times for business planning.

🧰 Tools Used
MySQL Workbench → Data cleaning and SQL querying













