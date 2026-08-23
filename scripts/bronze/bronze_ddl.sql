/*
===============================================================================
DDL Script: Create Bronze Layer Tables
===============================================================================
Purpose:
    This script creates the tables in the 'bronze' schema, dropping existing
    tables if they already exist.
    Run this script to re-define the DDL structure of the bronze tables,
    which hold raw, unprocessed data loaded directly from the source CRM
    and ERP systems (customer, product, sales, and location data).
===============================================================================
*/


IF OBJECT_ID('bronze.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_cust_info;

CREATE TABLE bronze.crm_cust_info(

    cst_id INT,
    cst_key VARCHAR(255),
    cst_firstname VARCHAR(255),
    cst_lastname VARCHAR(255),
    cst_marital_status VARCHAR(50),
    cst_gendr  VARCHAR(10),
    cst_created_date DATE

);

IF OBJECT_ID('bronze.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_prd_info;

CREATE TABLE bronze.crm_prd_info(

    prd_id INT,
    prd_key VARCHAR(255),
    prd_nm VARCHAR(255),
    prd_cost INT,
    prd_line VARCHAR(10),
    prd_start_dt DATE,
    prd_end_dt DATE

);

IF OBJECT_ID('bronze.crm_sales_detail', 'U') IS NOT NULL
    DROP TABLE bronze.crm_sales_detail;
CREATE TABLE bronze.crm_sales_detail(

    sls_ord_num VARCHAR(255),
    sls_prd_key VARCHAR(255),
    sls_cust_id INT,
    sls_order_dt INT, 
    sls_ship_dt INT, 
    sls_due_dt INT,
    sls_sales INT, 
    sls_quantity INT,
    sls_price INT


);

IF OBJECT_ID('bronze.erp_cust_az12', 'U') IS NOT NULL
    DROP TABLE bronze.erp_cust_az12;

CREATE TABLE bronze.erp_cust_az12(

    cid VARCHAR(255),
    BDATE DATE,
    GEN VARCHAR(10),
)

IF OBJECT_ID('bronze.erp_loc_a101', 'U') IS NOT NULL
    DROP TABLE bronze.erp_loc_a101;
CREATE TABLE bronze.erp_loc_a101(

    cid VARCHAR(255),
    cntry VARCHAR(100),
)


IF OBJECT_ID('bronze.erp_px_cat_g1v2', 'U') IS NOT NULL
    DROP TABLE bronze.erp_px_cat_g1v2;
CREATE TABLE bronze.erp_px_cat_g1v2(

    id VARCHAR(255),
    cat VARCHAR(255),
    subcat VARCHAR(255),
    maintenance VARCHAR(10),
)


