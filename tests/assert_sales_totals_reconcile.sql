WITH line_totals AS (
    SELECT
        COUNT(DISTINCT order_id) AS quantity_orders
    ,   COUNT(*) AS quantity_order_items
    ,   COALESCE(SUM(quantity), 0) AS quantity
    ,   COALESCE(SUM(discount), 0) AS discount
    ,   COALESCE(SUM(gross_revenue), 0) AS gross_revenue
    ,   COALESCE(SUM(net_revenue), 0) AS net_revenue
    ,   COUNT(DISTINCT order_id) FILTER (WHERE status = 'COMPLETED') AS completed_orders
    ,   COALESCE(SUM(quantity) FILTER (WHERE status = 'COMPLETED'), 0) AS completed_units
    ,   COALESCE(SUM(net_revenue) FILTER (WHERE status = 'COMPLETED'), 0) AS completed_revenue
    FROM {{ ref('int_order_items') }}
), order_totals AS (
    SELECT
        COUNT(*) AS quantity_orders
    ,   COALESCE(SUM(quantity_order_items), 0) AS quantity_order_items
    ,   COALESCE(SUM(quantity), 0) AS quantity
    ,   COALESCE(SUM(discount), 0) AS discount
    ,   COALESCE(SUM(gross_revenue), 0) AS gross_revenue
    ,   COALESCE(SUM(net_revenue), 0) AS net_revenue
    FROM {{ ref('int_orders') }}
), fact_totals AS (
    SELECT
        COUNT(*) AS quantity_orders
    ,   COALESCE(SUM(quantity_order_items), 0) AS quantity_order_items
    ,   COALESCE(SUM(quantity), 0) AS quantity
    ,   COALESCE(SUM(discount), 0) AS discount
    ,   COALESCE(SUM(gross_revenue), 0) AS gross_revenue
    ,   COALESCE(SUM(net_revenue), 0) AS net_revenue
    FROM {{ ref('fact_orders') }}
), customer_totals AS (
    SELECT
        COALESCE(SUM(quantity_orders), 0) AS quantity_orders
    ,   COALESCE(SUM(units_sold), 0) AS units_sold
    ,   COALESCE(SUM(net_revenue), 0) AS net_revenue
    FROM {{ ref('fact_orders_by_customer') }}
), product_totals AS (
    SELECT
        COALESCE(SUM(units_sold), 0) AS units_sold
    ,   COALESCE(SUM(net_revenue), 0) AS net_revenue
    FROM {{ ref('fact_orders_by_product') }}
)
SELECT 'intermediate_orders' AS inconsistent_model
FROM line_totals AS l
CROSS JOIN order_totals AS o
WHERE l.quantity_orders <> o.quantity_orders
OR l.quantity_order_items <> o.quantity_order_items
OR l.quantity <> o.quantity
OR l.discount <> o.discount
OR l.gross_revenue <> o.gross_revenue
OR l.net_revenue <> o.net_revenue

UNION ALL

SELECT 'fact_orders'
FROM line_totals AS l
CROSS JOIN fact_totals AS f
WHERE l.quantity_orders <> f.quantity_orders
OR l.quantity_order_items <> f.quantity_order_items
OR l.quantity <> f.quantity
OR l.discount <> f.discount
OR l.gross_revenue <> f.gross_revenue
OR l.net_revenue <> f.net_revenue

UNION ALL

SELECT 'fact_orders_by_customer'
FROM line_totals AS l
CROSS JOIN customer_totals AS c
WHERE l.completed_orders <> c.quantity_orders
OR l.completed_units <> c.units_sold
OR l.completed_revenue <> c.net_revenue

UNION ALL

SELECT 'fact_orders_by_product'
FROM line_totals AS l
CROSS JOIN product_totals AS p
WHERE l.completed_units <> p.units_sold
OR l.completed_revenue <> p.net_revenue
