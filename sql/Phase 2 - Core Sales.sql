-- ========================================================================================================================
-- PHASE 2 - CORE SALES
-- ========================================================================================================================

-- ========================================================================================================================
-- 6. Total Business Performance
-- Calculate:
-- Units sold
-- Revenue
-- Product cost
-- Gross profit
-- Gross margin %
-- ========================================================================================================================

SELECT
  sum(s.units) AS units_sold,
  format('$%.2fM', sum((s.units * p.Product_Price) / 1000000))
    AS revenue_million,
  format('$%.2fM', sum((s.units * p.Product_Cost) / 1000000)) AS cost_million,
  format(
    '$%.2fM',
    (sum((s.units * p.Product_Price) - (s.units * p.Product_Cost))) / 1000000)
    AS gross_profit_million,
  CAST(
    round(
      safe_divide(
        sum(
          s.units * p.Product_Price
          - s.units * p.Product_Cost),
        sum(s.units * p.Product_Price))
        * 100,
      2)
    AS string)
    || '%' AS gross_margin_perc
FROM `maven.sales` AS s
JOIN `maven.products` AS p
  ON s.Product_ID = p.Product_ID

-- ========================================================================================================================
-- 7. Top 10 Products by Revenue
-- ========================================================================================================================
SELECT
  p.Product_Name,
  format('$%.2fM', sum((s.units * p.Product_Price) / 1000000))
    AS revenue_million
FROM `maven.sales` AS s
JOIN `maven.products` AS p
  ON s.Product_ID = p.Product_ID
GROUP BY
  p.Product_Name
ORDER BY revenue_million DESC
LIMIT 10;

-- ========================================================================================================================
-- 8. Top 10 Products by Units Sold
-- ========================================================================================================================

SELECT
  p.Product_Name,
  sum(s.units) AS units_sold
FROM `maven.sales` AS s
JOIN `maven.products` AS p
  ON s.Product_ID = p.Product_ID
GROUP BY
  p.Product_Name
ORDER BY units_sold DESC
LIMIT 10;

-- ========================================================================================================================
-- 9. Category Performance
-- For each category:
-- Units
-- Revenue
-- Profit
-- Margin %
-- Revenue contribution %
-- ========================================================================================================================

SELECT
  Product_Category,
  units_sold,
  format('$%.2fM', revenue / 1000000) AS revenue_million,
  format('$%.2fM', cost / 1000000) AS cost_million,
  format('$%.2fM', gross_profit / 1000000) AS gross_profit_million,
  CAST(gross_margin AS string) || '%' AS gross_margin_perc,
  format('%.2f%%', safe_divide(revenue, sum(revenue) OVER ()) * 100)
    AS revenue_contribution_perc
FROM
  (
    SELECT
      p.Product_Category,
      sum(s.units) AS units_sold,
      sum((s.units * p.Product_Price)) AS revenue,
      sum((s.units * p.Product_Cost)) AS cost,
      (sum((s.units * p.Product_Price) - (s.units * p.Product_Cost)))
        AS gross_profit,
      round(
        safe_divide(
          sum(
            s.units * p.Product_Price
            - s.units * p.Product_Cost),
          sum(s.units * p.Product_Price))
          * 100,
        2) AS gross_margin
    FROM `maven.sales` AS s
    JOIN `maven.products` AS p
      ON s.Product_ID = p.Product_ID
    GROUP BY p.Product_Category
  )

-- ========================================================================================================================
-- 10. Store Performance
-- For each store:
-- Units
-- Revenue
-- Profit
-- Margin %
-- Average revenue per transaction
-- ========================================================================================================================
  
SELECT
  st.store_name,
  sum(s.units) AS units_sold,
  format('$%.2fM', sum((s.units * p.Product_Price) / 1000000)) AS revenue_M,
  format('$%.2fM', sum((s.units * p.Product_Cost) / 1000000)) AS cost_M,
  format(
    '$%.2fM',
    (sum((s.units * p.Product_Price) - (s.units * p.Product_Cost)) / 1000000))
    AS gross_profit,
  format(
    '%.2f%%',
    safe_divide(
      sum(
        s.units * p.Product_Price
        - s.units * p.Product_Cost),
      sum(s.units * p.Product_Price))
      * 100) AS gross_margin,
  format(
    '%.2f%%', safe_divide(sum((s.units * p.Product_Price)), COUNT(s.Sale_ID)))
    AS avg_revenue_per_transactions,
FROM `maven.sales` AS s
JOIN `maven.stores` AS st
  ON s.store_id = st.store_id
JOIN `maven.products` AS p
  ON s.product_id = p.product_id
GROUP BY
  st.store_name
ORDER BY
  revenue_M DESC,
  avg_revenue_per_transactions DESC
