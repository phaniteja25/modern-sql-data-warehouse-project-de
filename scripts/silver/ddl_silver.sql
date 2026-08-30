/*
===============================================================================
DDL Script: Create silver Layer Tables
===============================================================================
Purpose:
    This script creates the tables in the 'silver' schema, dropping existing
    tables if they already exist.
    Run this script to re-define the DDL structure of the silver tables,
    which hold raw, unprocessed data loaded directly from the source CRM
    and ERP systems (customer, product, sales, and location data).
===============================================================================
*/


IF OBJECT_ID('silver.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_cust_info;

CREATE TABLE silver.crm_cust_info(

    cst_id INT,
    cst_key VARCHAR(255),
    cst_firstname VARCHAR(255),
    cst_lastname VARCHAR(255),
    cst_marital_status VARCHAR(50),
    cst_gendr  VARCHAR(10),
    cst_created_date DATE,
    dwh_created_date DATETIME2 DEFAULT GETDATE()

);

IF OBJECT_ID('silver.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_prd_info;
--DROP TABLE silver.crm_prd_info;
CREATE TABLE silver.crm_prd_info(

    prd_id INT,
    prd_key VARCHAR(255),
    prd_cat VARCHAR(255),
    prd_nm VARCHAR(255),
    prd_cost INT,
    prd_line VARCHAR(100),
    prd_start_dt DATE,
    prd_end_dt DATE,
    dwh_created_date DATETIME2 DEFAULT GETDATE()

);

IF OBJECT_ID('silver.crm_sales_detail', 'U') IS NOT NULL
    DROP TABLE silver.crm_sales_detail;

CREATE TABLE silver.crm_sales_detail(

    sls_ord_num VARCHAR(255),
    sls_prd_key VARCHAR(255),
    sls_cust_id INT,
    sls_order_dt DATE, 
    sls_ship_dt DATE, 
    sls_due_dt DATE,
    sls_sales INT, 
    sls_quantity INT,
    sls_price INT,
    dwh_created_date DATETIME2 DEFAULT GETDATE()

);

IF OBJECT_ID('silver.erp_cust_az12', 'U') IS NOT NULL
    DROP TABLE silver.erp_cust_az12;

CREATE TABLE silver.erp_cust_az12(

    cid VARCHAR(255),
    BDATE DATE,
    GEN VARCHAR(10),
    dwh_created_date DATETIME2 DEFAULT GETDATE()
)

IF OBJECT_ID('silver.erp_loc_a101', 'U') IS NOT NULL
    DROP TABLE silver.erp_loc_a101;
CREATE TABLE silver.erp_loc_a101(

    cid VARCHAR(255),
    cntry VARCHAR(100),
    dwh_created_date DATETIME2 DEFAULT GETDATE()
)


IF OBJECT_ID('silver.erp_px_cat_g1v2', 'U') IS NOT NULL
    DROP TABLE silver.erp_px_cat_g1v2;
CREATE TABLE silver.erp_px_cat_g1v2(

    id VARCHAR(255),
    cat VARCHAR(255),
    subcat VARCHAR(255),
    maintenance VARCHAR(10),
    dwh_created_date DATETIME2 DEFAULT GETDATE()
)


