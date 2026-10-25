WITH raw_order_items AS (
    SELECT
        oi.order_item_id AS order_item_id
    ,   oi.order_id AS order_id
    ,   oi.product_id AS product_id
    ,   oi.quantity AS quantity
    ,   {{ parse_money('oi.unit_price') }} AS unit_price
    ,   {{ parse_money('oi.discount') }} AS discount
    FROM {{ source('ecom', 'order_items') }} AS oi
)
SELECT
    roi.order_item_id AS order_item_id
,   roi.order_id AS order_id
,   roi.product_id AS product_id
,   roi.quantity AS quantity
,   roi.unit_price AS unit_price
,   roi.discount AS discount
,   CASE
        WHEN (roi.quantity IS NULL) OR (roi.quantity <= 0) THEN 1
        ELSE 0
    END AS has_quantity_problem
,   CASE
        WHEN (roi.unit_price IS NULL) OR (roi.unit_price <= 0) THEN 1
        ELSE 0
    END AS has_unit_price_problem
,   CASE
        WHEN (roi.discount IS NULL)
            OR (roi.discount < 0)
            OR (roi.discount > roi.unit_price) THEN 1
        ELSE 0
    END AS has_discount_problem
FROM raw_order_items AS roi
