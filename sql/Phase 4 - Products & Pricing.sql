-- ========================================================================================================================
-- PHASE 4 - PRODUCTS & PRICING
-- ========================================================================================================================


-- ========================================================================================================================
-- 16. Products Available in Every Store
-- Identify products appearing in every store's inventory.
-- Then calculate their:
-- Units sold
-- Revenue
-- Profit
-- ========================================================================================================================

SELECT
  i.store_id AS store_id,
  COUNT(DISTINCT i.product_id) AS product_count,
  sum(s.units) AS units_sold,
  format('$%.2fM', sum((s.units * p.Product_Price) / 1000000)) AS revenue_M,
  format('$%.2fM', sum((s.units * p.Product_Cost) / 1000000)) AS cost_M,
  format(
    '$%.2fM',
    (sum((s.units * p.Product_Price) - (s.units * p.Product_Cost)) / 1000000))
    AS gross_profit_M,
FROM `maven.inventory` AS i
JOIN `maven.sales` AS s
  ON i.store_id = s.store_id
JOIN `maven.products` AS p
  ON s.product_id = p.product_id
GROUP BY
  i.store_id
ORDER BY
  product_count DESC

-- ========================================================================================================================
-- 17.Product Distribution
-- Classify products:
-- Universal: 100%
-- High: 75–99%
-- Medium: 50–74%
-- Low: <50%
-- ========================================================================================================================

WITH productstorecount AS (
  SELECT
    product_id,
      COUNT(store_id) AS store_count,
    FROM `maven.inventory`
  GROUP BY product_id
    ),
  totalstores AS (
      SELECT
        COUNT(*) AS total_store_count
      FROM `maven.stores`
    )
SELECT
  psc.product_id,
  psc.store_count,
  safe_divide(psc.store_count, ts.total_store_count) * 100 AS store_pct,
  CASE
    WHEN safe_divide(psc.store_count, ts.total_store_count) = 1 THEN 'Universal'
    WHEN safe_divide(psc.store_count, ts.total_store_count) >= 0.75 THEN 'High'
    WHEN safe_divide(psc.store_count, ts.total_store_count) >= 0.5 THEN 'Medium'
    ELSE 'Low'
    END AS distribution_category
FROM productstorecount AS psc, totalstores AS ts
ORDER BY store_count DESC;

-- ========================================================================================================================
-- 18. Price Bands
-- Use exactly:
-- <5
-- 5-10
-- 11-25
-- 26-50
-- 50+
-- ========================================================================================================================

SELECT
  product_id,
  Product_Price,
  CASE
    WHEN product_price < 5 THEN '<5'
    WHEN product_price BETWEEN 5 AND 10 THEN '5-10'
    WHEN product_price BETWEEN 10 AND 25 THEN '11-25'
    WHEN product_price BETWEEN 25 AND 50 THEN '26-50'
    ELSE '50+'
    END AS price_band
FROM `maven.products`
ORDER BY product_price DESC;

-- ========================================================================================================================
-- 19. Price vs Sales
-- Show:
-- Product
-- Price
-- Units
-- Revenue
-- Profit
-- Then analyze whether expensive products generally sell fewer units.
-- ========================================================================================================================

WITH
  product_metrics AS (
    SELECT
      p.Product_id,
      p.product_price,
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
    GROUP BY p.Product_id, p.Product_Price
  ),
  pct_calculations AS (
    SELECT
      *,
      round(safe_divide(units_sold, sum(units_sold) OVER ()) * 100, 2)
        AS units_sold_pct
    FROM product_metrics
  )
SELECT
  product_id,
  product_price,
  units_sold,
  format('$%.2fM', revenue / 1000000) AS revenue_million,
  format('$%.2fM', cost / 1000000) AS cost_million,
  format('$%.2fM', gross_profit / 1000000) AS gross_profit_million,
  units_sold_pct,
  round(
    sum(units_sold_pct)
      OVER (ORDER BY units_sold DESC ROWS UNBOUNDED PRECEDING),
    2) AS units_sold_pct_cum
FROM pct_calculations
ORDER BY units_sold DESC;

-- ========================================================================================================================
-- 20. Same Price Within Category
-- Find products sharing the same price within the same category.
-- ========================================================================================================================

SELECT
  p.product_name,
  p.product_category,
  p.product_price
FROM `maven.products` p
JOIN `maven.products` pt
  ON p.product_category = pt.product_category
WHERE
  p.Product_Price = pt.product_price
  AND p.product_id
    <>
      pt.product_id

-- ========================================================================================================================
-- 21. Gross Margin Ranking
-- Rank products by gross margin %.
-- Then compare margin % against absolute gross profit.
-- ========================================================================================================================

WITH gross AS (
  SELECT
    p.product_name,
    p.product_price,
    round(
      safe_divide(
      sum(
              s.units * p.Product_Price
              - s.units * p.Product_Cost),
            sum(s.units * p.Product_Price)),
          2) AS gross_margin,
        round(sum(s.units * p.product_price - s.units * p.product_cost), 2)
          AS absolute_gross_profit
      FROM `maven.sales` s
      LEFT JOIN `maven.products` p
        ON s.product_id = p.product_id
      GROUP BY 1, 2
      ORDER BY 3 DESC
    )
SELECT *, rank() OVER (ORDER BY gross_margin DESC) AS rank_gross_margin
FROM gross
ORDER BY gross.absolute_gross_profit DESC;

-- ========================================================================================================================
-- 22.Revenue vs Profit Champions
-- Find products that appear in both:
-- Top 10 revenue
-- Top 10 gross profit
-- ========================================================================================================================

WITH
  top10revenue AS (
    SELECT
      p.product_name,
      sum(s.units * p.product_price) AS revenue,
    FROM `maven.sales` s
    LEFT JOIN `maven.products` p
      ON s.product_id = p.product_id
    GROUP BY 1
    ORDER BY 2 DESC
    LIMIT 10
  ),
  top10profit AS (
    SELECT
      p.product_name,
      round(sum(s.units * p.product_price - s.units * p.product_cost), 2)
        AS absolute_gross_profit
    FROM `maven.sales` s
    LEFT JOIN `maven.products` p
      ON s.product_id = p.product_id
    GROUP BY 1
    ORDER BY 2 DESC
    LIMIT 10
  )
SELECT
  tr.product_name,
  format('$%.2fM', tr.revenue / 100000) AS revenue_M,
  format('$%.2fM', tp.absolute_gross_profit / 1000000) AS profit_M
FROM top10revenue tr
JOIN top10profit tp
  ON tr.product_name = tp.product_name
