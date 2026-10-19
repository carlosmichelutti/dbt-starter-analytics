TRUNCATE TABLE raw.order_items, raw.orders, raw.products, raw.customers;

COPY raw.customers(customer_id, full_name, email, registration_date, city, state)
FROM 'D:\dbt\data/customers.csv'
DELIMITER ',' CSV HEADER;

COPY raw.products(product_id, product_name, category, unit_price, is_active)
FROM 'D:\dbt\data/products.csv'
DELIMITER ',' CSV HEADER;

COPY raw.orders(order_id, customer_id, order_date, status, payment_method)
FROM 'D:\dbt\data/orders.csv'
DELIMITER ',' CSV HEADER;

COPY raw.order_items(order_item_id, order_id, product_id, quantity, unit_price, discount)
FROM 'D:\dbt\data/order_items.csv'
DELIMITER ',' CSV HEADER;
