SELECT
    o.order_id AS order_id
,   o.customer_id AS customer_id
,   o.order_date AS order_date
,   o.status AS status
,   o.payment_method AS payment_method
,   o.quantity_order_items AS quantity_order_items
,   o.quantity AS quantity
,   o.discount AS discount
,   o.gross_revenue AS gross_revenue
,   o.net_revenue AS net_revenue
FROM {{ ref('int_orders') }} AS o
