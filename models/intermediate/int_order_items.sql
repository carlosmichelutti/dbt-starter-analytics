WITH orders AS (
    SELECT DISTINCT
        o.order_id
    ,   o.customer_id
    ,   o.order_date
    ,   o.status
    ,   o.payment_method
    FROM {{ ref('stg_orders') }} AS o
    WHERE o.has_order_date_problem = 0
), order_items AS (
    SELECT DISTINCT
        oi.order_item_id
    ,   oi.order_id
    ,   oi.product_id
    ,   oi.quantity
    ,   oi.unit_price
    ,   oi.discount
    FROM {{ ref('stg_order_items') }} AS oi
    WHERE oi.has_quantity_problem = 0
    AND oi.has_unit_price_problem = 0
    AND oi.has_discount_problem = 0
)
SELECT
    oi.order_item_id AS order_item_id
,   o.order_id AS order_id
,   o.customer_id AS customer_id
,   oi.product_id AS product_id
,   o.order_date AS order_date
,   o.status AS status
,   o.payment_method AS payment_method
,   oi.quantity AS quantity
,   oi.unit_price AS unit_price
,   oi.discount AS discount
,   (oi.quantity * oi.unit_price) AS gross_revenue
,   (oi.quantity * oi.unit_price) - oi.discount AS net_revenue
FROM orders AS o
INNER JOIN order_items AS oi
    ON o.order_id = oi.order_id
