SELECT
    order_item_id
,   quantity
,   unit_price
,   discount
,   gross_revenue
,   net_revenue
FROM {{ ref('int_order_items') }}
WHERE quantity IS NULL
OR quantity <= 0
OR unit_price IS NULL
OR unit_price <= 0
OR discount IS NULL
OR discount < 0
OR discount >= quantity * unit_price
OR gross_revenue IS NULL
OR gross_revenue <= 0
OR net_revenue IS NULL
OR net_revenue <= 0
OR gross_revenue IS DISTINCT FROM quantity * unit_price
OR net_revenue IS DISTINCT FROM gross_revenue - discount
