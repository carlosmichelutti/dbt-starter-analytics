SELECT
    order_id
,   quantity_order_items
,   quantity
,   discount
,   gross_revenue
,   net_revenue
FROM {{ ref('fact_orders') }}
WHERE quantity_order_items IS NULL OR quantity_order_items <= 0
OR quantity IS NULL OR quantity <= 0
OR discount IS NULL OR discount < 0
OR gross_revenue IS NULL OR gross_revenue <= 0
OR net_revenue IS NULL OR net_revenue <= 0
OR discount >= gross_revenue
OR net_revenue IS DISTINCT FROM gross_revenue - discount
