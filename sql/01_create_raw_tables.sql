DROP SCHEMA IF EXISTS raw CASCADE;
CREATE SCHEMA raw;

CREATE TABLE raw.customers (
    customer_id INTEGER,
    full_name VARCHAR(120),
    email VARCHAR(160),
    registration_date VARCHAR(30),
    city VARCHAR(80),
    state VARCHAR(30)
);

CREATE TABLE raw.products (
    product_id INTEGER,
    product_name VARCHAR(160),
    category VARCHAR(80),
    unit_price VARCHAR(30),
    is_active VARCHAR(10)
);

CREATE TABLE raw.orders (
    order_id INTEGER,
    customer_id INTEGER,
    order_date VARCHAR(30),
    status VARCHAR(30),
    payment_method VARCHAR(30)
);

CREATE TABLE raw.order_items (
    order_item_id INTEGER,
    order_id INTEGER,
    product_id INTEGER,
    quantity INTEGER,
    unit_price VARCHAR(30),
    discount VARCHAR(30)
);
