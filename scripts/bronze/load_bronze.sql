/*
===============================================================================
Script: Load Bronze Layer (Source -> Bronze)
===============================================================================
Purpose:
    Loads data into the `bronze` schema from external CSV files.
    - Truncates bronze tables before loading
    - Uses `LOAD DATA INFILE` to load CSV files into bronze tables

Notes:
    - In MySQL, `LOAD DATA INFILE` is not allowed inside stored procedures.
    - Run this script directly in MySQL Workbench or the MySQL client.
    - CSV files must be located in the directory allowed by `secure_file_priv`.

Usage:
    Run the whole script.
===============================================================================
*/

SHOW VARIABLES LIKE 'secure_file_priv';

-- bronze.crm_cust_info
TRUNCATE TABLE bronze.crm_cust_info;

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\cust_info.csv'
INTO TABLE bronze.crm_cust_info
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(@cst_id, @cst_key, @cst_firstname, @cst_lastname, @cst_marital_status, @cst_gndr, @cst_create_date)
SET
    cst_id = NULLIF(TRIM(@cst_id), ''),
    cst_key = NULLIF(TRIM(@cst_key), ''),
    cst_firstname = NULLIF(TRIM(@cst_firstname), ''),
    cst_lastname = NULLIF(TRIM(@cst_lastname), ''),
    cst_marital_status = NULLIF(TRIM(@cst_marital_status), ''),
    cst_gndr = NULLIF(TRIM(@cst_gndr), ''),
    cst_create_date = NULLIF(TRIM(@cst_create_date), '');

-- bronze.crm_prd_info
TRUNCATE TABLE bronze.crm_prd_info;

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\prd_info.csv'
INTO TABLE bronze.crm_prd_info
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(@prd_id, @prd_key, @prd_nm, @prd_cost, @prd_line, @prd_start_dt, @prd_end_dt)
SET
    prd_id       = NULLIF(TRIM(@prd_id), ''),
    prd_key      = NULLIF(TRIM(@prd_key), ''),
    prd_nm       = NULLIF(TRIM(@prd_nm), ''),
    prd_cost     = NULLIF(TRIM(@prd_cost), ''),
    prd_line     = NULLIF(TRIM(@prd_line), ''),
    prd_start_dt = NULLIF(TRIM(@prd_start_dt), ''),
    prd_end_dt   = NULLIF(TRIM(@prd_end_dt), '');


-- bronze.crm_sales_details
TRUNCATE TABLE bronze.crm_sales_details;

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\sales_details.csv'
INTO TABLE bronze.crm_sales_details
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(@sls_ord_num, @sls_prd_key, @sls_cust_id, @sls_order_dt, @sls_ship_dt, @sls_due_dt, @sls_sales, @sls_quantity, @sls_price)
SET
    sls_ord_num  = NULLIF(TRIM(@sls_ord_num), ''),
    sls_prd_key  = NULLIF(TRIM(@sls_prd_key), ''),
    sls_cust_id  = NULLIF(TRIM(@sls_cust_id), ''),
    sls_order_dt = NULLIF(TRIM(@sls_order_dt), ''),
    sls_ship_dt  = NULLIF(TRIM(@sls_ship_dt), ''),
    sls_due_dt   = NULLIF(TRIM(@sls_due_dt), ''),
    sls_sales    = NULLIF(TRIM(@sls_sales), ''),
    sls_quantity = NULLIF(TRIM(@sls_quantity), ''),
    sls_price    = NULLIF(TRIM(@sls_price), '');


-- bronze.erp_loc_a101
TRUNCATE TABLE bronze.erp_loc_a101;

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\LOC_A101.csv'
INTO TABLE bronze.erp_loc_a101
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(@cid, @cntry)
SET
    cid   = NULLIF(TRIM(@cid), ''),
    cntry = NULLIF(TRIM(@cntry), '');


-- bronze.erp_cust_az12
TRUNCATE TABLE bronze.erp_cust_az12;

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\CUST_AZ12.csv'
INTO TABLE bronze.erp_cust_az12
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(@cid, @bdate, @gen)
SET
    cid   = NULLIF(TRIM(@cid), ''),
    bdate = NULLIF(TRIM(@bdate), ''),
    gen   = NULLIF(TRIM(@gen), '');


-- bronze.erp_px_cat_g1v2
TRUNCATE TABLE bronze.erp_px_cat_g1v2;

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\PX_CAT_G1V2.csv'
INTO TABLE bronze.erp_px_cat_g1v2
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(@id, @cat, @subcat, @maintenance)
SET
    id          = NULLIF(TRIM(@id), ''),
    cat         = NULLIF(TRIM(@cat), ''),
    subcat      = NULLIF(TRIM(@subcat), ''),
    maintenance = NULLIF(TRIM(@maintenance), '');