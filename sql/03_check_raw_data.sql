SELECT 'customers' AS table_name, COUNT(*) AS total_records FROM raw.customers
UNION ALL SELECT 'products', COUNT(*) FROM raw.products
UNION ALL SELECT 'orders', COUNT(*) FROM raw.orders
UNION ALL SELECT 'order_items', COUNT(*) FROM raw.order_items;

SELECT email, COUNT(*) AS total
FROM raw.customers
GROUP BY email
HAVING COUNT(*) > 1 OR email IS NULL OR email = '';

SELECT 'customers' AS table_name, customer_id AS record_id, registration_date AS original_date
FROM raw.customers
WHERE registration_date NOT LIKE '____-__-__'
UNION ALL
SELECT 'orders', order_id, order_date
FROM raw.orders
WHERE order_date NOT LIKE '____-__-__';

SELECT status, COUNT(*) AS total
FROM raw.orders
GROUP BY status
ORDER BY status;

SELECT product_id, product_name, unit_price
FROM raw.products
WHERE unit_price LIKE 'R$%' OR unit_price IS NULL OR unit_price = '';

SELECT order_item_id, order_id, product_id, unit_price, discount
FROM raw.order_items
WHERE unit_price LIKE 'R$%'
   OR unit_price IS NULL
   OR unit_price = ''
   OR discount LIKE '-%';

SELECT o.*
FROM raw.orders o
LEFT JOIN raw.customers c ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

SELECT oi.*
FROM raw.order_items oi
LEFT JOIN raw.products p ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;

SELECT oi.*
FROM raw.order_items oi
LEFT JOIN raw.orders o ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;

SELECT 'orders' AS table_name, order_id AS duplicate_id, COUNT(*) AS total
FROM raw.orders
GROUP BY order_id
HAVING COUNT(*) > 1
UNION ALL
SELECT 'order_items', order_item_id, COUNT(*)
FROM raw.order_items
GROUP BY order_item_id
HAVING COUNT(*) > 1;

SELECT *
FROM raw.order_items
WHERE quantity IS NULL OR quantity <= 0;
