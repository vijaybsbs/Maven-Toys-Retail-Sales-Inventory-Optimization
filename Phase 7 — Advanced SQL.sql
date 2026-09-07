-- Phase 7 — Advanced SQL

-- 28. Store Rank Within City

SELECT
  st.store_name,
  st.store_city,
  format('$%.2fM', sum((s.units * p.Product_Price) / 1000000)) AS revenue_M,
  rank()
    OVER (
      PARTITION BY st.store_city ORDER BY(sum(s.units * p.Product_Price)) DESC
    ) AS store_rank
FROM `maven.sales` AS s
JOIN `maven.stores` AS st
  ON s.store_id = st.store_id
JOIN `maven.products` AS p
  ON s.product_id = p.product_id
GROUP BY
  st.store_name,
  st.store_city
ORDER BY store_city

-- 29. Product Contribution Within Category
-- Calculate each product's percentage of its category revenue.
SELECT
  p.Product_Category,
  p.product_name,
  format('$%.2fM', sum((s.units * p.Product_Price)) / 1000000) AS revenue,
  format(
    '$%.2fM',
    sum(sum(s.units * p.product_price) / 1000000)
      OVER (PARTITION BY p.product_category)) AS cat_total_revenue,
  format(
    '%.2f%%',
    safe_divide(
      sum(s.units * p.product_price),
      sum(sum(s.units * p.product_price))
        OVER (PARTITION BY p.product_category))
      * 100) AS revenue_pct
FROM `maven.sales` AS s
JOIN `maven.products` AS p
  ON s.Product_ID = p.Product_ID
GROUP BY
  p.Product_Category,
  p.product_name
ORDER BY
  p.Product_Category,
  sum(s.units * p.product_price) DESC;

-- 30.Pareto Analysis
-- Find approximately how many products generate:
-- 50% of revenue
-- 80% of revenue

WITH
  ProductRevenue AS (
    SELECT
      p.product_name,
      sum(s.units * p.product_price) AS total_revenue
    FROM `maven.sales` AS s
    JOIN `maven.products` AS p
      ON s.product_id = p.product_id
    GROUP BY
      p.product_name
  ),
  ParetoAnalysis AS (
    SELECT
      product_name,
      total_revenue,
      sum(total_revenue)
        OVER (ORDER BY total_revenue DESC) AS running_total_revenue,
      sum(total_revenue) OVER () AS grand_total_revenue
    FROM ProductRevenue
  )
SELECT
  product_name,
  format('$%.2fM', total_revenue / 1000000) AS revenue,
  round((running_total_revenue / grand_total_revenue) * 100, 2)
    AS cum_revenue_pct,
  CASE
    WHEN (running_total_revenue / grand_total_revenue) <= 0.50 THEN 'Top 50%'
    WHEN (running_total_revenue / grand_total_revenue) <= 0.80 THEN 'Top 80%'
    ELSE 'Rest'
    END AS revenue_segment
FROM ParetoAnalysis
ORDER BY total_revenue DESC;
