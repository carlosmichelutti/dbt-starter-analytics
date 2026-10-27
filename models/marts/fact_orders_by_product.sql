SELECT
    oi.product_id AS product_id
,   p.product_name AS product_name
,   COUNT(DISTINCT oi.order_id) AS quantity_orders
,   SUM(oi.quantity) AS units_sold
,   SUM(oi.net_revenue) AS net_revenue
FROM {{ ref('int_order_items') }} AS oi
LEFT JOIN {{ ref('dim_products') }} AS p
    ON oi.product_id = p.product_id
WHERE oi.status = 'COMPLETED'
GROUP BY oi.product_id, p.product_name
