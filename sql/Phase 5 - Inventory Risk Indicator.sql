-- ========================================================================================================================
-- PHASE 5 - INVENTORY RISK INDICATOR
-- ========================================================================================================================

-- ========================================================================================================================
-- 23. Inventory Risk Indicator
-- Compare current stock with historical average monthly sales.
-- Create categories such as:
-- High Risk
-- Normal
-- Potential Reorder
-- ========================================================================================================================

WITH
  sales_summary AS (
    SELECT
      store_id,
      product_id,
      SUM(units) AS total_units_sold
    FROM `maven-toys-case-study`.`maven`.`sales`
    GROUP BY
      store_id,
      product_id
  ),
  sales_period AS (
    SELECT
      DATE_DIFF(
        DATE_TRUNC(MAX(Date), MONTH),
        DATE_TRUNC(MIN(Date), MONTH),
        MONTH)
      + 1 AS total_months
    FROM `maven-toys-case-study`.`maven`.`sales`
  )
SELECT
  s.store_id,
  s.store_name,
  p.product_id,
  p.product_name,
  i.stock_on_hand,
  ss.total_units_sold,
  ROUND(
    SAFE_DIVIDE(
      ss.total_units_sold,
      sp.total_months),
    2) AS avg_monthly_sales,
  ROUND(
    SAFE_DIVIDE(
      i.stock_on_hand,
      SAFE_DIVIDE(
        ss.total_units_sold,
        sp.total_months)),
    2) AS months_of_stock,
  CASE
    WHEN
      ss.total_units_sold IS NULL
      OR ss.total_units_sold = 0
      THEN 'No Historical Sales'
    WHEN
      i.stock_on_hand
      < SAFE_DIVIDE(
        ss.total_units_sold,
        sp.total_months)
        * 0.5
      THEN 'High Risk'
    WHEN
      i.stock_on_hand < SAFE_DIVIDE(
        ss.total_units_sold,
        sp.total_months)
      THEN 'Potential Reorder'
    ELSE 'Normal'
    END AS inventory_risk_indicator
FROM `maven-toys-case-study`.`maven`.`inventory` AS i
JOIN `maven-toys-case-study`.`maven`.`stores` AS s
  ON i.store_id = s.store_id
JOIN `maven-toys-case-study`.`maven`.`products` AS p
  ON i.product_id = p.product_id
LEFT JOIN sales_summary AS ss
  ON
    i.store_id = ss.store_id
    AND i.product_id = ss.product_id
CROSS JOIN sales_period AS sp
ORDER BY
  CASE
    WHEN
      ss.total_units_sold IS NULL
      OR ss.total_units_sold = 0
      THEN 1
    WHEN
      i.stock_on_hand
      < SAFE_DIVIDE(ss.total_units_sold, sp.total_months) * 0.5
      THEN 2
    WHEN i.stock_on_hand < SAFE_DIVIDE(ss.total_units_sold, sp.total_months)
      THEN 3
    ELSE 4
    END,
  s.store_name,
  p.product_name;

-- ========================================================================================================================
-- 24. Inventory Risk Indicator Count and Percentage
-- ========================================================================================================================

WITH
  sales_summary AS (
    SELECT
      store_id,
      product_id,
      SUM(units) AS total_units_sold
    FROM `maven-toys-case-study`.`maven`.`sales`
    GROUP BY
      store_id,
      product_id
  ),
  sales_period AS (
    SELECT
      DATE_DIFF(
        DATE_TRUNC(MAX(Date), MONTH),
        DATE_TRUNC(MIN(Date), MONTH),
        MONTH)
      + 1 AS total_months
    FROM `maven-toys-case-study`.`maven`.`sales`
  ),
  inventory_risk AS (
    SELECT
      s.store_id,
      s.store_name,
      p.product_id,
      p.product_name,
      i.stock_on_hand,
      CASE
        WHEN
          ss.total_units_sold IS NULL
          OR ss.total_units_sold = 0
          THEN 'No Historical Sales'
        WHEN
          i.stock_on_hand
          < SAFE_DIVIDE(
            ss.total_units_sold,
            sp.total_months)
            * 0.5
          THEN 'High Risk'
        WHEN
          i.stock_on_hand < SAFE_DIVIDE(
            ss.total_units_sold,
            sp.total_months)
          THEN 'Potential Reorder'
        ELSE 'Normal'
        END AS inventory_risk_indicator,
    FROM `maven-toys-case-study`.`maven`.`inventory` AS i
    JOIN `maven-toys-case-study`.`maven`.`stores` AS s
      ON i.store_id = s.store_id
    JOIN `maven-toys-case-study`.`maven`.`products` AS p
      ON i.product_id = p.product_id
    LEFT JOIN sales_summary AS ss
      ON
        i.store_id = ss.store_id
        AND i.product_id = ss.product_id
    CROSS JOIN sales_period AS sp
  )
SELECT
  store_id,
  store_name,
  COUNTIF(inventory_risk_indicator = 'High Risk')
    AS high_risk_products,
  COUNTIF(inventory_risk_indicator = 'Potential Reorder')
    AS potential_reorder_products,
  COUNTIF(inventory_risk_indicator = 'Normal')
    AS normal_products,
  COUNTIF(inventory_risk_indicator = 'No Historical Sales')
    AS no_historical_sales_products,
  COUNT(*) AS total_inventory_products,
  FORMAT(
    '%.2f%%',
    SAFE_DIVIDE(
      COUNTIF(inventory_risk_indicator = 'High Risk'),
      COUNT(*))
      * 100) AS high_risk_percentage
FROM inventory_risk
GROUP BY
  store_id,
  store_name
ORDER BY
  no_historical_sales_products DESC,
  store_name
