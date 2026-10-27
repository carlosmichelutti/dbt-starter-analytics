SELECT
    o.customer_id AS customer_id
,   c.customer_name AS customer_name
,   COUNT(*) AS quantity_orders
,   SUM(o.quantity) AS units_sold
,   SUM(o.net_revenue) AS net_revenue
FROM {{ ref('fact_orders') }} AS o
LEFT JOIN {{ ref('dim_customers') }} AS c
    ON o.customer_id = c.customer_id
WHERE o.status = 'COMPLETED'
GROUP BY o.customer_id, c.customer_name
