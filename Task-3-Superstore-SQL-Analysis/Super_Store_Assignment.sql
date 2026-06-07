/*
  SUPERSTORE SALES ANALYSIS
  Step 1 : Database Setup and Data Preparation
*/

-- Create database
CREATE DATABASE Super_Store;

-- Select database
USE Super_Store;


/*
  Raw table containing imported Superstore dataset
*/

CREATE TABLE superstore_raw (
    row_id INT,
    order_id VARCHAR(50),
    order_date VARCHAR(50),
    ship_date VARCHAR(50),
    ship_mode VARCHAR(50),
    customer_id VARCHAR(50),
    customer_name VARCHAR(100),
    segment VARCHAR(50),
    country VARCHAR(100),
    city VARCHAR(100),
    state VARCHAR(100),
    postal_code INT,
    region VARCHAR(50),
    product_id VARCHAR(50),
    category VARCHAR(50),
    sub_category VARCHAR(50),
    product_name VARCHAR(255),
    sales DECIMAL(10,2),
    quantity INT,
    discount DECIMAL(5,2),
    profit DECIMAL(10,4)
);


/*
  Customers Table
  Stores unique customer information
*/

CREATE TABLE customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_name VARCHAR(100),
    segment VARCHAR(50),
    country VARCHAR(100),
    city VARCHAR(100),
    state VARCHAR(100),
    postal_code INT,
    region VARCHAR(50)
);

/*
  The source data contains multiple records for the
  same customer because customers can place many orders.

  Since customer_id is the primary key, records are
  grouped by customer_id before insertion.
*/

INSERT INTO customers
SELECT
    customer_id,
    MAX(customer_name),
    MAX(segment),
    MAX(country),
    MAX(city),
    MAX(state),
    MAX(postal_code),
    MAX(region)
FROM superstore_raw
GROUP BY customer_id;

-- Verify customer records
SELECT COUNT(*) FROM customers;

-- View table structure
DESC customers;


/*
  Products Table
  Stores unique product information
*/

CREATE TABLE products (
    product_id VARCHAR(50) PRIMARY KEY,
    category VARCHAR(50),
    sub_category VARCHAR(50),
    product_name VARCHAR(255)
);

/*
  A product can appear in multiple orders.
  Grouping by product_id ensures only one record
  is stored for each product.
*/

INSERT INTO products
SELECT
    product_id,
    MAX(category),
    MAX(sub_category),
    MAX(product_name)
FROM superstore_raw
GROUP BY product_id;

-- Verify product records
SELECT * FROM products;


/*
  Orders Table
  Stores transaction level order data
*/

CREATE TABLE orders (
    row_id INT,
    order_id VARCHAR(50),
    order_date VARCHAR(50),
    ship_date VARCHAR(50),
    ship_mode VARCHAR(50),
    customer_id VARCHAR(50),
    product_id VARCHAR(50),
    sales DECIMAL(10,2),
    quantity INT,
    discount DECIMAL(5,2),
    profit DECIMAL(10,4)
);

/*
  Insert order records from the raw dataset.
  DISTINCT is used to avoid accidental duplicate rows.
*/

INSERT INTO orders
SELECT DISTINCT
    row_id,
    order_id,
    order_date,
    ship_date,
    ship_mode,
    customer_id,
    product_id,
    sales,
    quantity,
    discount,
    profit
FROM superstore_raw;

-- Verify order records
SELECT COUNT(*) FROM orders;



--  Check all created tables


SHOW TABLES;

/*STEP 2 : SQL Queries Using Subqueries, CTEs
           and Window Functions */



-- 1. Find all orders where sales are greater than the average sales 

SELECT *
FROM orders
WHERE sales > (
    SELECT AVG(sales)
    FROM orders
);



--  2. Find the highest sales order for each customer


SELECT *
FROM orders o
WHERE sales = (
    SELECT MAX(sales)
    FROM orders
    WHERE customer_id = o.customer_id
);


--  3. Calculate total sales for each customer


WITH customer_sales AS (
    SELECT
        customer_id,
        SUM(sales) AS total_sales
    FROM orders
    GROUP BY customer_id
)
SELECT *
FROM customer_sales;


/*
  4. Find customers whose total sales are above
     the average customer sales
*/

WITH customer_sales AS (
    SELECT
        customer_id,
        SUM(sales) AS total_sales
    FROM orders
    GROUP BY customer_id
)
SELECT *
FROM customer_sales
WHERE total_sales > (
    SELECT AVG(total_sales)
    FROM customer_sales
);


/*
  5. Rank customers based on total sales
*/

WITH customer_sales AS (
    SELECT
        customer_id,
        SUM(sales) AS total_sales
    FROM orders
    GROUP BY customer_id
)
SELECT
    customer_id,
    total_sales,
    RANK() OVER (ORDER BY total_sales DESC) AS sales_rank
FROM customer_sales;


/*
  6. Assign row numbers to orders within each customer
*/

SELECT
    customer_id,
    order_id,
    order_date,
    sales,
    ROW_NUMBER() OVER (
        PARTITION BY customer_id
        ORDER BY order_date
    ) AS order_number
FROM orders;


/*
  7. Display top 3 customers based on total sales
*/

WITH customer_sales AS (
    SELECT
        customer_id,
        SUM(sales) AS total_sales
    FROM orders
    GROUP BY customer_id
),
ranked_customers AS (
    SELECT
        customer_id,
        total_sales,
        RANK() OVER (ORDER BY total_sales DESC) AS sales_rank
    FROM customer_sales
)
SELECT *
FROM ranked_customers
WHERE sales_rank <= 3;


/*
  STEP 3 : Final Combined Query
  Show Customer Name, Total Sales and Rank
  Using JOIN + CTE + Window Function
*/

WITH customer_sales AS (
    SELECT
        customer_id,
        SUM(sales) AS total_sales
    FROM orders
    GROUP BY customer_id
)

SELECT
    c.customer_name,
    cs.total_sales,
    RANK() OVER (ORDER BY cs.total_sales DESC) AS sales_rank
FROM customer_sales cs
JOIN customers c
    ON cs.customer_id = c.customer_id
ORDER BY sales_rank;


/*
  STEP 4 : Mini Project - Customer Sales Insights
*/



--  1. Top 5 customers based on total sales


SELECT
    c.customer_id,
    c.customer_name,
    SUM(o.sales) AS total_sales
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_sales DESC
LIMIT 5;


/*
  2. Bottom 5 customers based on total sales
*/

SELECT
    c.customer_id,
    c.customer_name,
    SUM(o.sales) AS total_sales
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_sales ASC
LIMIT 5;


/*
  3. Customers who made only one order
*/

SELECT
    c.customer_id,
    c.customer_name,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(DISTINCT o.order_id) = 1;


/*
  4. Customers with above-average sales
*/

WITH customer_sales AS (
    SELECT
        customer_id,
        SUM(sales) AS total_sales
    FROM orders
    GROUP BY customer_id
)

SELECT
    c.customer_id,
    c.customer_name,
    cs.total_sales
FROM customer_sales cs
JOIN customers c
    ON cs.customer_id = c.customer_id
WHERE cs.total_sales > (
    SELECT AVG(total_sales)
    FROM customer_sales
)
ORDER BY cs.total_sales DESC;


/*
  5. Highest order value for each customer
*/

SELECT
    c.customer_id,
    c.customer_name,
    MAX(o.sales) AS highest_order_value
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY highest_order_value DESC;