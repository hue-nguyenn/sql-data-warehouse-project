/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================
Script Purpose:
    This stored procedure performs the ETL (Extract, Transform, Load) process to 
    populate the 'silver' schema tables from the 'bronze' schema.
	Actions Performed:
		- Truncates Silver tables.
		- Inserts transformed and cleansed data from Bronze into Silver tables.
		
Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    CALL silver.load_silver();
===============================================================================
*/


DROP PROCEDURE IF EXISTS silver.load_silver;

DELIMITER $$

CREATE PROCEDURE silver.load_silver()
BEGIN
	-- Loading silver.crm_cust_info
	TRUNCATE TABLE silver.crm_cust_info;
	INSERT INTO silver.crm_cust_info (
		cst_id, 
		cst_key, 
		cst_firstname, 
		cst_lastname, 
		cst_marital_status, 
		cst_gndr,
		cst_create_date
	)

	SELECT cst_id,
		cst_key,
		cst_firstname,
		cst_lastname,
		CASE WHEN UPPER(cst_marital_status) = 'S' THEN 'Single'
			WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
			ELSE 'n/a'
		END AS cst_marital_status,  -- Normalize marital status values to readable format
		CASE WHEN UPPER(cst_gndr) = 'F' THEN 'Female'
			WHEN UPPER(cst_gndr) = 'M' THEN 'Male'
			ELSE 'n/a'
		END AS cst_gndr, -- Normalize gender values to readable format
		cst_create_date
	FROM (
	SELECT 
		*,
		ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
	FROM bronze.crm_cust_info
	WHERE cst_id IS NOT NULL
	)t WHERE flag_last = 1; -- Select the most recent record per customer


	-- Loading silver.crm_prd_info
	TRUNCATE TABLE silver.crm_prd_info;
	INSERT INTO silver.crm_prd_info (
		prd_id,
		cat_id,
		prd_key,
		prd_nm,
		prd_cost,
		prd_line,
		prd_start_dt,
		prd_end_dt
	)
	SELECT
		prd_id,
		REPLACE(SUBSTR(prd_key, 1, 5), '-', '_') AS cat_id, -- Extract category ID
		SUBSTR(prd_key, 7, LENGTH(prd_key)) AS prd_key, -- Extract product key
		prd_nm,
		IFNULL(prd_cost, 0) AS prd_cost,
		CASE WHEN UPPER(prd_line) = 'R' THEN 'Road'
			WHEN UPPER(prd_line) = 'M' THEN 'Mountain'
			WHEN UPPER(prd_line) = 'S' THEN 'Other sales'
			WHEN UPPER(prd_line) = 'T' THEN 'Touring'
			ELSE 'n/a' 
		END AS prd_line, -- Map product line codes to descriptive values
		CAST(prd_start_dt AS DATE) AS prd_start_dt,
		CAST(
			DATE_SUB(
				LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt),
				INTERVAL 1 DAY
			) AS DATE
		) AS prd_end_dt -- Calculate end date as one day before the next start date
	FROM bronze.crm_prd_info;


	-- Loading silver.crm_sales_details
	TRUNCATE TABLE silver.crm_sales_details;
	INSERT INTO silver.crm_sales_details (
		sls_ord_num,
		sls_prd_key,
		sls_cust_id,
		sls_order_dt,
		sls_ship_dt,
		sls_due_dt,
		sls_sales,
		sls_quantity,
		sls_price
	)
	SELECT
		sls_ord_num,
		sls_prd_key,
		sls_cust_id,
		CASE WHEN sls_order_dt = 0 OR LENGTH(sls_order_dt) != 8 THEN NULL
			ELSE STR_TO_DATE(sls_order_dt, '%Y%m%d')
		END AS sls_order_dt,
		CASE WHEN sls_ship_dt = 0 OR LENGTH(sls_ship_dt) != 8 THEN NULL
			ELSE STR_TO_DATE(sls_ship_dt, '%Y%m%d')
		END AS sls_ship_dt,
		CASE WHEN sls_due_dt = 0 OR LENGTH(sls_due_dt) != 8 THEN NULL
			ELSE STR_TO_DATE(sls_due_dt, '%Y%m%d')
		END AS sls_due_dt,
		CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
				THEN sls_quantity * ABS(sls_price)
			ELSE sls_sales
		END AS sls_sales,  -- Recalculate sales if original value is missing or incorrect
		 sls_quantity,
		CASE WHEN sls_price IS NULL OR sls_price <= 0
				THEN sls_sales / NULLIF(sls_quantity, 0)
			ELSE sls_price
		END AS sls_price  -- Derive price if original value is invalid
	FROM bronze.crm_sales_details;


	-- Loading silver.erp_cust_az12
	TRUNCATE TABLE silver.erp_cust_az12;
	INSERT INTO silver.erp_cust_az12 (
		cid,
		bdate,
		gen
	)
	SELECT
		CASE WHEN cid LIKE 'NAS%' THEN SUBSTR(cid, 4, LENGTH(cid))
			ELSE cid
		END AS cid, -- Remove 'NAS' prefix if present
		CASE WHEN bdate > CURRENT_DATE() THEN NULL 
			ELSE bdate
		END AS bdate, -- Set future birthdates to NULL
		CASE WHEN UPPER(gen) IN ('F', 'FEMALE') THEN 'Female'
			WHEN UPPER(gen) IN ('M', 'MALE') THEN 'Male'
			ELSE 'n/a'
		END AS gen -- Normalize gender values and handle unknown cases
	FROM bronze.erp_cust_az12;

	 -- Loading erp_loc_a101
	 TRUNCATE TABLE silver.erp_loc_a101;
	INSERT INTO silver.erp_loc_a101 (
		cid,
		cntry
	)
	SELECT
		REPLACE(cid, '-', '') AS cid,
		CASE WHEN cntry = 'DE' THEN 'Germany'
			WHEN cntry IN ('US', 'USA') THEN 'United States'
			WHEN cntry IS NULL THEN 'n/a'
			ELSE cntry
		END AS cntry  -- Normalize and handle missing or blank country codes
	FROM bronze.erp_loc_a101;

	-- Loading erp_px_cat_g1v2
	TRUNCATE TABLE silver.erp_px_cat_g1v2;
	INSERT INTO silver.erp_px_cat_g1v2 (
		id,
		cat,
		subcat,
		maintenance
	)
	SELECT
		id,
		cat,
		subcat,
		maintenance
	FROM bronze.erp_px_cat_g1v2;
END;
$$
DELIMITER ;

CALL silver.load_silver();