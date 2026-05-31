--  SECTION A – SQL BASICS

-- Q1. Display all columns and rows from customers table
SELECT * FROM customers;

-- Q2. Retrieve first_name, last_name and city
SELECT first_name, last_name, city
FROM customers;

-- Q3. List all unique categories available in products
SELECT DISTINCT category
FROM products;

-- Q4. Primary Keys in Schema

-- customers  = customer_id
-- products   = product_id
-- orders     = order_id
-- order_items = item_id

/*
Primary Key Properties:
1. Must be UNIQUE
2. Cannot be NULL

Reason:
- Uniquely identifies each row.
- Prevents duplicate records.
- Helps establish relationships between tables.
*/

-- Q5. Constraints on email column

/*
email column constraints:
1. UNIQUE
2. NOT NULL

Duplicate email insertion example:
*/

INSERT INTO customers
VALUES (
109,
'Test',
'User',
'aarav.s@email.com',
'Delhi',
'Delhi',
'2024-09-01',
FALSE
);

/*
Result:
ERROR: Duplicate entry for UNIQUE KEY email0	44	17:33:56
Error Code: 1062. Duplicate entry 'aarav.s@email.com' for key 'customers.email'	0.031 sec
*/


-- Q6. Insert product with negative price

INSERT INTO products
VALUES (
209,
'Invalid Product',
'Electronics',
'TestBrand',
-50,
100
);

/*
Result :
17:36:43	INSERT INTO products VALUES ( 209, 'Invalid Product', 'Electronics', 'TestBrand', -50, 100 )	
Error Code: 3819. Check constraint 'products_chk_1' is violated.	0.000 sec

*/


--  SECTION B – FILTERING & OPTIMIZATION

-- Q7. Retrieve all Delivered orders

SELECT *
FROM orders
WHERE status = 'Delivered';


-- Q8. Electronics products with price > 2000

SELECT *
FROM products
WHERE category = 'Electronics'
AND unit_price > 2000;


-- Q9. Customers joined in 2024 and belong to Maharashtra

SELECT *
FROM customers
WHERE state = 'Maharashtra'
AND join_date BETWEEN '2024-01-01' AND '2024-12-31';


-- Q10. Orders between 10-Aug and 25-Aug excluding cancelled

SELECT *
FROM orders
WHERE order_date BETWEEN '2024-08-10' AND '2024-08-25'
AND status <> 'Cancelled';


-- Q11. Index Explanation

/*
idx_orders_date is created on order_date.

Purpose:
- Speeds up filtering
- Speeds up sorting
- Reduces table scanning

Example query benefiting from index:
*/

SELECT *
FROM orders
WHERE order_date BETWEEN '2024-08-01'
AND '2024-08-31';


-- Q12. SARGable Query

/*
Non-SARGable Query:
*/

SELECT *
FROM customers
WHERE YEAR(join_date) = 2024;

/*
YEAR() function forces database to calculate
YEAR for every row, preventing index usage.
*/

/* Index-Friendly Query */

SELECT *
FROM customers
WHERE join_date >= '2024-01-01'
AND join_date < '2025-01-01';


 -- SECTION C – AGGREGATION

-- Q13. Total number of orders

SELECT COUNT(*) AS total_orders
FROM orders;

-- Q14. Total revenue from Delivered orders

SELECT SUM(total_amount) AS delivered_revenue
FROM orders
WHERE status = 'Delivered';


-- Q15. Average product price by category

SELECT
    category,
    AVG(unit_price) AS average_price
FROM products
GROUP BY category;


-- Q16. Count of orders and total revenue by status

SELECT
    status,
    COUNT(*) AS order_count,
    SUM(total_amount) AS total_revenue
FROM orders
GROUP BY status
ORDER BY total_revenue DESC;


-- Q17. Most expensive and cheapest product in each category

SELECT
    category,
    MAX(unit_price) AS max_price,
    MIN(unit_price) AS min_price
FROM products
GROUP BY category;


-- Q18. Categories with average price > 2000

SELECT
    category,
    AVG(unit_price) AS avg_price
FROM products
GROUP BY category
HAVING AVG(unit_price) > 2000;


--  SECTION D – JOINS & RELATIONSHIPS


-- Q19. Orders with customer names

SELECT
    o.order_id,
    o.order_date,
    c.first_name,
    c.last_name,
    o.total_amount
FROM orders o
INNER JOIN customers c
ON o.customer_id = c.customer_id;


-- Q20. All customers and their orders

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    o.order_id,
    o.order_date,
    o.total_amount
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id;


-- Q21. Join three tables

SELECT
    o.order_id,
    p.product_name,
    oi.quantity,
    oi.unit_price,
    oi.discount_pct
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
JOIN products p
ON oi.product_id = p.product_id;


-- Q22. JOIN Explanation

/*
LEFT JOIN:
Returns all rows from left table
and matching rows from right table.

Example:
customers LEFT JOIN orders

Shows all customers even if
they never ordered.

RIGHT JOIN:
Returns all rows from right table
and matching rows from left table.

Example:
customers RIGHT JOIN orders

Shows all orders even if customer
record is missing.

FULL OUTER JOIN:
Returns all rows from both tables.

Used when you need:
- unmatched customers
- unmatched orders
in one result.
*/


-- Q23. Foreign Keys

/*
1. orders.customer_id
   -> customers.customer_id

2. order_items.order_id
   -> orders.order_id

3. order_items.product_id
   -> products.product_id

Attempt:

INSERT INTO orders
VALUES (
1011,
999,
'2024-09-01',
'Pending',
1000
);

Result:
FOREIGN KEY CONSTRAINT ERROR

Because customer_id 999
does not exist in customers table.
*/


--  SECTION E – ADVANCED CONCEPTS

-- Q24. Product price tiers using CASE

SELECT
    product_name,
    unit_price,
    CASE
        WHEN unit_price < 1000 THEN 'Budget'
        WHEN unit_price BETWEEN 1000 AND 3000 THEN 'Mid-Range'
        ELSE 'Premium'
    END AS price_tier
FROM products;


-- Q25. Delivered vs Not Delivered

SELECT
    SUM(
        CASE
            WHEN status = 'Delivered' THEN 1
            ELSE 0
        END
    ) AS delivered_orders,

    SUM(
        CASE
            WHEN status <> 'Delivered' THEN 1
            ELSE 0
        END
    ) AS not_delivered_orders
FROM orders;


-- Q26. ACID Properties

/*
A - Atomicity
All operations succeed or none succeed.

C - Consistency
Database remains valid before and after transaction.

I - Isolation
Transactions do not interfere with each other.

D - Durability
Committed data remains saved permanently.

Bank Transfer Example:

Transfer ₹5000 from Account A to Account B.

Atomicity:
Money deducted and credited together.

Consistency:
Total balance remains correct.

Isolation:
Other users cannot see incomplete transfer.

Durability:
After COMMIT, transfer remains saved
even if system crashes.
*/


-- Q27. Transaction Example

START TRANSACTION;

-- Insert Order

INSERT INTO orders
(
order_id,
customer_id,
order_date,
status,
total_amount
)
VALUES
(
1011,
102,
CURRENT_DATE,
'Pending',
1598.00
);

-- Insert Order Item 1

INSERT INTO order_items
(
item_id,
order_id,
product_id,
quantity,
unit_price,
discount_pct
)
VALUES
(
5016,
1011,
202,
1,
799.00,
0
);

-- Insert Order Item 2

INSERT INTO order_items
(
item_id,
order_id,
product_id,
quantity,
unit_price,
discount_pct
)
VALUES
(
5017,
1011,
208,
1,
599.00,
0
);

-- Update Stock

UPDATE products
SET stock_qty = stock_qty - 1
WHERE product_id = 202;

UPDATE products
SET stock_qty = stock_qty - 1
WHERE product_id = 208;

COMMIT;

/*
If any statement fails:

ROLLBACK;

This ensures the entire transaction
is either fully completed or fully cancelled.
*/
