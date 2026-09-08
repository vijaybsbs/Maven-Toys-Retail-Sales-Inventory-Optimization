-- ========================================================================================================================
-- PHASE 1 - DATA UNDERSTANDING
-- ========================================================================================================================

-- ========================================================================================================================
-- 1. Table Profiling
-- Objective:  
-- Find row counts and identify the primary/key columns.
-- ========================================================================================================================

SELECT 'inventory' AS table_name, COUNT(*) AS row_count
FROM `maven.inventory`
UNION ALL
SELECT 'stores' AS table_name, COUNT(*) AS row_count
FROM `maven.stores`
UNION ALL
SELECT 'products' AS table_name, COUNT(*) AS row_count
FROM `maven.products`
UNION ALL
SELECT 'sales' AS table_name, COUNT(*) AS row_count
FROM `maven.sales`

-- ========================================================================================================================
-- 2. Date Range & Transactions
-- Find minimum/maximum sales date, number of selling days and transactions.
-- ========================================================================================================================
  
select
  min(Date) as min_sales_date,
  max(Date) as max_sales_date,
  count(distinct Date) as selling_days,
  count(distinct Sale_ID) as transactions
from `maven.sales`

-- ========================================================================================================================
-- 3. Referential Integrity
-- Check whether all sales have valid stores and products.
-- ========================================================================================================================

select distinct sale_id, st.Store_ID, p.Product_ID  from `maven.sales` s
left join `maven.stores` st
on s.store_id = st.Store_ID
left join `maven.products` p
on s.Product_ID = p.Product_ID
where st.Store_ID is null or p.Product_ID is null

-- ========================================================================================================================
-- 4. Duplicate Detection
-- Check duplicates in all four tables.
-- ========================================================================================================================
  
select
  "stores" as table_name,
  count(*) as total_rows,
  count(distinct concat(store_id, store_name, store_city, store_location, store_open_date)) as distinct_rows,
  count(*) - count(distinct concat(store_id, store_name, store_city, store_location, store_open_date)) as duplicate_rows
from `maven.stores`
union all
select 
  'inventory' as table_name,
  count(*) as total_rows,
  count (distinct concat(store_id, product_id, stock_on_hand)) as distinct_rows,
  count(*) - count (distinct concat(store_id, product_id, stock_on_hand)) as duplicate_rows
  from `maven.inventory`
union all
select 
  'sales' as table_name,
  count(*) as total_rows,
  count (distinct concat(sale_id, date, store_id, product_id, units)) as distinct_rows,
  count(*) - count (distinct concat(sale_id, date, store_id, product_id, units)) as duplicate_rows
from `maven.sales`
union all
select 
  'products'as table_name,
  count(*) as total_rows,
  count (distinct concat(product_id, product_name, product_category, product_cost, product_price))as distinct_rows,
  count(*) - count (distinct concat(product_id, product_name, product_category, product_cost, product_price)) as duplicate_rows
from `maven.products`

-- ========================================================================================================================
-- 5. Inventory Completeness
-- There are 50 × 35 = 1,750 possible store-product combinations.
-- The inventory table contains 1,593 records.
-- Find the missing combinations.
-- ========================================================================================================================

select
  s.store_id,
  p.product_id
from `maven.stores` as s
cross join `maven.products` as p
where not exists
(
  select 1
  from `maven.inventory` as i
  where i.store_id = s.store_id
  and i.product_id = p.product_id
)

-- ========================================================================================================================
-- 5a. Calculate the percentage of possible store-product combinations that are missing.
-- ========================================================================================================================

select
  count(*) as total_combinations,
  countif(i.store_id is null) as missing_combinations,
  round (
    countif(i.store_id is null) / count(*) *100, 2
  ) as missing_percentage
from `maven.stores` as s

cross join `maven.products` p

left join `maven.inventory` i
  on s.store_id = i.Store_ID and
    p.product_id  = i.product_id;

