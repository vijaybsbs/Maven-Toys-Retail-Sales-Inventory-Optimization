-- ========================================================================================================================
-- PHASE 3 - GEOGRAPHY & STORES
-- ========================================================================================================================


-- ========================================================================================================================
-- 11. City Revenue Ranking
-- Find:
-- Number of stores
-- Units
-- Revenue
-- Profit
-- Revenue per store
-- ========================================================================================================================

SELECT
  st.store_city,
  COUNT(DISTINCT st.store_id) AS store_count,
  sum(s.units) AS units_sold,
  format('$%.2fM', sum((s.units * p.Product_Price) / 1000000)) AS revenue_M,
  format('$%.2fM', sum((s.units * p.Product_Cost) / 1000000)) AS cost_M,
  format(
    '$%.2fM',
    (sum((s.units * p.Product_Price) - (s.units * p.Product_Cost)) / 1000000))
    AS gross_profit_M,
  format(
    '$%.2fM',
    (
      safe_divide(sum(s.units * p.Product_Price), COUNT(DISTINCT st.store_id))
      / 1000000)) AS revenue_per_store_M
FROM `maven.sales` AS s
JOIN `maven.stores` AS st
  ON s.store_id = st.store_id
JOIN `maven.products` AS p
  ON s.product_id = p.product_id
GROUP BY
  st.store_city
ORDER BY
  revenue_M DESC


-- ========================================================================================================================
-- 12. Store Location Performance
-- Compare:
-- Downtown
-- Commercial
-- Residential
-- Airport
-- ========================================================================================================================
  
SELECT
  st.store_location,
  COUNT(DISTINCT st.store_id) AS store_count,
  sum(s.units) AS units_sold,
  format('$%.2fM', sum((s.units * p.Product_Price) / 1000000)) AS revenue_M,
  format('$%.2fM', sum((s.units * p.Product_Cost) / 1000000)) AS cost_M,
  format(
    '$%.2fM',
    (sum((s.units * p.Product_Price) - (s.units * p.Product_Cost)) / 1000000))
    AS gross_profit_M
FROM `maven.sales` AS s
JOIN `maven.stores` AS st
  ON s.store_id = st.store_id
JOIN `maven.products` AS p
  ON s.product_id = p.product_id
GROUP BY
  st.store_location
ORDER BY
  revenue_M DESC

-- ========================================================================================================================
-- 13. Store Age vs Revenue
-- Calculate store age using store_open_date.
-- Then compare store age with revenue.
-- ========================================================================================================================

WITH lastest_date AS (
      SELECT
        max(store_open_date) AS max_open_date
      FROM `maven.stores`
    )
SELECT
  st.store_name,
  date_diff(l.max_open_date, st.store_open_date, day) AS store_age,
  format('$%.2fM', (sum(s.units * p.product_price)) / 100000) AS revenue_M
FROM `maven.stores` st
JOIN `maven.sales` s
  ON s.store_id = st.store_id
JOIN `maven.products` p
  ON s.product_id = p.product_id
CROSS JOIN lastest_date l
GROUP BY 1, 2
ORDER BY 3 DESC

-- ========================================================================================================================
-- 14.Store Revenue Contribution
-- Calculate each store's percentage of total company revenue.
-- ========================================================================================================================

SELECT
  store_name,
  format('$%.2fM', revenue / 1000000) AS store_revenue,
  format('%.2f%%', safe_divide(revenue, sum(revenue) OVER ()) * 100)
    AS store_rev_contribution
FROM
  (
    SELECT
      st.store_name AS store_name,
      sum(s.units * p.Product_Price) AS revenue
    FROM `maven.sales` AS s
    JOIN `maven.stores` AS st
      ON s.store_id = st.store_id
    JOIN `maven.products` AS p
      ON s.product_id = p.product_id
    GROUP BY
      st.store_name
    ORDER BY
      revenue DESC
  )
  
-- ========================================================================================================================
-- 15.Geographic Concentration
-- What percentage of company revenue comes from the top 5 cities?
-- ========================================================================================================================
  
SELECT
  store_city,
  format('$%.2fM', revenue / 1000000) AS revenue_M,
  format('%.2f%%', safe_divide(revenue, sum(revenue) OVER ()) * 100)
    AS per_rev_from_city
FROM
  (
    SELECT
      st.Store_City AS store_city,
      sum(s.units * p.Product_Price) AS revenue
    FROM `maven.sales` AS s
    JOIN `maven.stores` AS st
      ON s.store_id = st.store_id
    JOIN `maven.products` AS p
      ON s.product_id = p.product_id
    GROUP BY
      st.store_city
    ORDER BY
      revenue DESC
  )
