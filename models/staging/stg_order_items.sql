{{ config(materialized='view') }}

WITH order_items AS (
    SELECT
        oi.order_item_id AS order_item_id
    ,   oi.order_id AS order_id
    ,   oi.product_id AS product_id
    ,   oi.quantity AS quantity
    ,   CAST(
            TRIM(
                REGEXP_REPLACE(oi.unit_price, '[^\d.]+', '', 'g')
            ) AS NUMERIC
        ) AS unit_price
    ,   CAST(
            TRIM(oi.discount) AS NUMERIC
        ) AS discount
    FROM raw.order_items AS oi
)
SELECT
    oi.order_item_id AS order_item_id
,   oi.order_id AS order_id
,   oi.product_id AS product_id
,   CASE
        WHEN (oi.quantity IS NULL) OR (oi.quantity <= 0) THEN 0
        ELSE oi.quantity
    END AS quantity
,   CASE
        WHEN oi.unit_price IS NULL THEN 0
        ELSE oi.unit_price
    END AS unit_price
,   CASE
        WHEN oi.discount IS NULL THEN 0
        ELSE oi.discount
    END AS discount
,   CASE
        WHEN (oi.quantity IS NULL) OR (oi.quantity <= 0) THEN 1
        ELSE 0
    END AS has_quantity_problem
,   CASE
        WHEN (oi.unit_price IS NULL) OR (oi.unit_price <= 0) THEN 1
        ELSE 0
    END AS has_unit_price_problem
,   CASE
        WHEN (oi.discount < 0) OR (oi.discount > oi.unit_price) THEN 1
        ELSE 0
    END AS has_discount_problem
FROM order_items AS oi