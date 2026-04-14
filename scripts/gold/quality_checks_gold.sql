/*
===============================================================================
Quality Checks
===============================================================================
Script Purpose:
    This script performs quality checks to validate the integrity, consistency, 
    and accuracy of the Gold Layer. These checks ensure:
    - Uniqueness of surrogate keys in dimension tables.
    - Referential integrity between fact and dimension tables.
    - Validation of relationships in the data model for analytical purposes.

Usage Notes:
    - Investigate and resolve any discrepancies found during the checks.
===============================================================================
*/

-- ====================================================================
-- Creating and checking 'gold.dim_customer'
-- ====================================================================
-- Check for Uniqueness of Customer Key in gold.dim_customer
-- Expectation: No results 
SELECT cst_id, COUNT(*)
FROM (
	SELECT
		ci.cst_id, 
		ci.cst_key, 
		ci.cst_firstname, 
		ci.cst_lastname, 
		ci.cst_marital_status, 
		ci.cst_gndr,
		ci.cst_create_date,
		ca.bdate,
		ca.gen,
		la.cntry
	FROM silver.crm_cust_info ci
	LEFT JOIN silver.erp_cust_az12 ca
	ON ci.cst_key = ca.cid
	LEFT JOIN silver.erp_loc_a101 la
	ON ci.cst_key = la.cid
	)t
GROUP BY 1
HAVING COUNT(*) > 1;

-- Data integration for 2 gender columns
SELECT DISTINCT
	ci.cst_gndr,
	ca.gen,
    CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
		ELSE COALESCE(ca.gen, 'n/a')
	END AS gender
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
ON ci.cst_key = la.cid;

-- AFTER CREATING VIEW FOR GOLD LAYER
-- Perform same checks
-- Check for Uniqueness of Customer Key in gold.dim_customer
-- Expectation: No results 
SELECT 
    customer_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_customer
GROUP BY customer_key
HAVING COUNT(*) > 1;


-- ====================================================================
-- Creating and checking 'gold.dim_product'
-- ====================================================================
-- Check for Uniqueness of Product Key in gold.dim_products
-- Expectation: No results 
SELECT 
    product_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_product
GROUP BY product_key
HAVING COUNT(*) > 1;


-- ====================================================================
-- Checking 'gold.fact_sales'
-- ====================================================================
-- Check the data model connectivity between fact and dimensions
SELECT * 
FROM gold.fact_sales f
LEFT JOIN gold.dim_customer c
ON c.customer_key = f.customer_key
LEFT JOIN gold.dim_product p
ON p.product_key = f.product_key
WHERE p.product_key IS NULL OR c.customer_key IS NULL;