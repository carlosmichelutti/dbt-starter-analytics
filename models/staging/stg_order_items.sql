{{ config(materialized='view') }}

WITH raw_order_items AS (
    SELECT
        oi.order_item_id AS order_item_id
    ,   oi.order_id AS order_id
    ,   oi.product_id AS product_id
    ,   CASE
            WHEN (oi.quantity IS NULL) OR (oi.quantity <= 0) THEN 0
            ELSE oi.quantity
        END AS quantity
    ,   CAST(
            TRIM(
                REGEXP_REPLACE(oi.unit_price, '[^\d.]+', '', 'g')
            ) AS NUMERIC
        ) AS unit_price
    ,   CAST(
            TRIM(oi.discount) AS NUMERIC
        ) AS discount
    FROM {{ source('ecom', 'order_items') }} AS oi
)
SELECT
    roi.order_item_id AS order_item_id
,   roi.order_id AS order_id
,   roi.product_id AS product_id
,   roi.quantity AS quantity
,   CASE
        WHEN roi.unit_price IS NULL THEN 0
        ELSE roi.unit_price
    END AS unit_price
,   CASE
        WHEN roi.discount IS NULL THEN 0
        ELSE roi.discount
    END AS discount
,   CASE
        WHEN roi.quantity = 0 THEN 1
        ELSE 0
    END AS has_quantity_problem
,   CASE
        WHEN (roi.unit_price IS NULL) OR (roi.unit_price <= 0) THEN 1
        ELSE 0
    END AS has_unit_price_problem
,   CASE
        WHEN (roi.discount < 0) OR (roi.discount > roi.unit_price) THEN 1
        ELSE 0
    END AS has_discount_problem
FROM raw_order_items AS roi