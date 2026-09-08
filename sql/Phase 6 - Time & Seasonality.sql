-- ========================================================================================================================
-- PHASE 6 - TIME & SEASONALITY
-- ========================================================================================================================


-- ========================================================================================================================
-- 25.Monthly Sales by Year
-- Calculate monthly:
-- Units
-- Revenue
-- Profit
-- ========================================================================================================================

SELECT
  EXTRACT(year FROM date) AS year_of_sale,
  EXTRACT(month FROM date) AS month_of_sale,
  sum(s.units) AS units_sale,
  format('$%.2fM', sum(s.units * p.product_price) / 1000000) AS revenue,
  format(
    '$%.2fM',
    sum(s.units * p.product_price - s.units * p.product_cost) / 1000000)
    AS profit
FROM `maven.sales` s
LEFT JOIN `maven.products` p
  ON s.product_id = p.product_id
GROUP BY
  year_of_sale,
  month_of_sale
ORDER BY
  year_of_sale,
  month_of_sale

-- ========================================================================================================================
-- 26. Month-over-Month Growth
-- Calculate monthly revenue growth %.
-- ========================================================================================================================
  
WITH monthly_sales AS (
      SELECT
        EXTRACT(year FROM date) AS year_of_sale,
        EXTRACT(month FROM date) AS month_of_sale,
        sum(s.units * p.product_price) AS revenue,
      FROM `maven.sales` s
      LEFT JOIN `maven.products` p
        ON s.product_id = p.product_id
      GROUP BY
        year_of_sale,
        month_of_sale
      ORDER BY
        year_of_sale,
        month_of_sale
    )
SELECT
  year_of_sale,
  month_of_sale,
  format('$%.2fM', revenue / 1000000) AS revenue_M,
  format(
    '$%.2fM',
    lag(revenue, 1) OVER (ORDER BY year_of_sale, month_of_sale) / 1000000)
    AS previous_month_revenue_M,
  format(
    '%.2f%%',
    safe_divide(
      (revenue - lag(revenue, 1) OVER (ORDER BY year_of_sale, month_of_sale)),
      lag(revenue, 1) OVER (ORDER BY year_of_sale, month_of_sale)))
    AS growth_pct
FROM monthly_sales
ORDER BY
  year_of_sale,
  month_of_sale

-- ========================================================================================================================
-- 27. Cumulative Revenue
-- ========================================================================================================================
    WITH monthly_sales AS (
      SELECT
        EXTRACT(year FROM date) AS year_of_sale,
        EXTRACT(month FROM date) AS month_of_sale,
        sum(s.units * p.product_price) AS revenue,
      FROM `maven.sales` s
      LEFT JOIN `maven.products` p
        ON s.product_id = p.product_id
      GROUP BY
        year_of_sale,
        month_of_sale
      ORDER BY
        year_of_sale,
        month_of_sale
    )
SELECT
  year_of_sale,
  month_of_sale,
  format('$%.2fM', revenue / 1000000) AS revenue_M,
  format(
    '$%.2fM',
    sum(revenue)
      OVER (
        ORDER BY year_of_sale, month_of_sale
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
      )
      / 1000000) AS cumulative_revenue_M
FROM monthly_sales
ORDER BY year_of_sale, month_of_sale
