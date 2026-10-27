SELECT
    oi.order_id AS order_id
,   oi.customer_id AS customer_id
,   oi.order_date AS order_date
,   oi.status AS status
,   oi.payment_method AS payment_method
,   COUNT(*) AS quantity_order_items
,   SUM(oi.quantity) AS quantity
,   SUM(oi.discount) AS discount
,   SUM(oi.gross_revenue) AS gross_revenue
,   SUM(oi.net_revenue) AS net_revenue
FROM {{ ref('int_order_items') }} AS oi
GROUP BY
    oi.order_id
,   oi.customer_id
,   oi.order_date
,   oi.status
,   oi.payment_method
