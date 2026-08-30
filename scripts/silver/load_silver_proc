/*

Data Transformation Bronze -> Silver


*/
/*
=============================================
bronze.crm_cust_info  => silver.crm_cust_info 
=============================================
*/



CREATE OR ALTER PROCEDURE silver.load_silver as 
BEGIN
    PRINT 'TRUNCATING DATA FROM silver.crm_cust_info'
    TRUNCATE TABLE silver.crm_cust_info
    PRINT 'INSERTING DATA INTO silver.crm_cust_info'
    INSERT INTO silver.crm_cust_info (
        cst_id,
        cst_key,
        cst_firstname,
        cst_lastname,
        cst_marital_status,
        cst_gendr,
        cst_created_date
    )
    SELECT
        cst_id,
        cst_key,
        TRIM(cst_firstname) AS cst_firstname,
        TRIM(cst_lastname) AS cst_lastname,
        CASE WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'MARRIED'
            WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'SINGLE'
            ELSE 'N/A'
        END AS cst_marital_status,
        CASE WHEN UPPER(TRIM(cst_gendr)) = 'F' THEN 'FEMALE'
            WHEN UPPER(TRIM(cst_gendr)) = 'M' THEN 'MALE'
            ELSE 'N/A'
        END AS cst_gendr,
        cst_created_date
    FROM (
        SELECT *,
            ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_created_date DESC) AS flag_latest
        FROM bronze.crm_cust_info
        WHERE cst_id IS NOT NULL
    ) t
    WHERE t.flag_latest = 1;


    -- =============================================
    -- bronze.crm_prd_info  => silver.crm_prd_info 
    -- =============================================
    PRINT 'TRUNCATING DATA FROM silver.crm_prd_info'
    TRUNCATE TABLE silver.crm_prd_info
    PRINT 'INSERTING DATA INTO silver.crm_prd_info'
    INSERT INTO silver.crm_prd_info (
        prd_id,
        prd_key,
        prd_cat,
        prd_nm,
        prd_cost,
        prd_line,
        prd_start_dt,
        prd_end_dt
    )
    select p.prd_id,
    SUBSTRING(p.prd_key,7,LEN(p.prd_key)) as prd_key,
    REPLACE(SUBSTRING(p.prd_key,1,5),'-','_') as prd_cat,
    p.prd_nm,
    ISNULL(p.prd_cost,0) as prd_cost,
    CASE when UPPER(TRIM(P.prd_line)) = 'M' THEN 'MOUNTAIN'
        when UPPER(TRIM(P.prd_line)) = 'R' THEN 'ROAD'
        when UPPER(TRIM(P.prd_line)) = 'S' THEN 'OTHER SALES'
        when UPPER(TRIM(P.prd_line)) = 'T' THEN 'TOURING'
        ELSE 'N/A'
    END AS prd_line,
    p.prd_start_dt,
    DATEADD(DAY, -1, LEAD(p.prd_start_dt) OVER (PARTITION BY p.prd_key order by prd_start_dt)) as prd_end_dt_test
    from bronze.crm_prd_info p


    -- =============================================
    -- bronze.crm_sales_detail  => silver.crm_sales_detail 
    -- =============================================
    PRINT 'TRUNCATING DATA FROM silver.crm_sales_detail'
    TRUNCATE TABLE silver.crm_sales_detail
    PRINT 'INSERTING DATA INTO silver.crm_sales_detail'
    INSERT INTO 
    silver.crm_sales_detail (
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
    select 
    s.sls_ord_num,
    s.sls_prd_key,
    s.sls_cust_id,
    CASE WHEN s.sls_order_dt = 0 or LEN(s.sls_order_dt) != 8 then NULL 
        ELSE CAST(CAST(S.SLS_ORDER_DT AS VARCHAR) AS DATE) 
    END as sls_order_dt,
    CASE WHEN s.sls_ship_dt = 0 or LEN(s.sls_ship_dt) != 8 then NULL 
        ELSE CAST(CAST(S.sls_ship_dt AS VARCHAR) AS DATE)
    END as sls_ship_dt,
    CASE WHEN s.sls_due_dt = 0 or LEN(s.sls_due_dt) != 8 then NULL 
        ELSE CAST(CAST(S.sls_due_dt AS VARCHAR) AS DATE)
    END as sls_due_dt,
    CASE WHEN s.sls_sales is null or s.sls_sales <= 0 or s.sls_sales != ABS(s.sls_price) * s.sls_quantity
        THEN ABS(s.sls_price) * s.sls_quantity
        ELSE s.sls_sales
    END as sls_sales,  
    s.sls_quantity,
    CASE WHEN S.sls_price is null or s.sls_price <= 0 
        THEN s.sls_sales/ NULLIF(s.sls_quantity, 0)
        ELSE s.sls_price
    END as sls_price
    from bronze.crm_sales_detail s



    -- =============================================
    -- bronze.erp_cust_az12  => silver.erp_cust_az12 
    -- =============================================
    PRINT 'TRUNCATING DATA FROM silver.erp_cust_az12'
    TRUNCATE TABLE silver.erp_cust_az12
    PRINT 'INSERTING DATA INTO silver.erp_cust_az12'

    insert into silver.erp_cust_az12 (
        cid,
        bdate,
        gen
    )
    select 
    CASE WHEN c.cid like 'NAS%' then SUBSTRING(c.cid, 4, LEN(c.cid)) 
        ELSE C.CID
    END as cid,
    CASE WHEN c.BDATE > GETDATE() then NULL
        ELSE C.BDATE
    END as BDATE,
    CASE WHEN UPPER(TRIM(REPLACE(REPLACE(c.GEN, CHAR(13), ''), CHAR(10), ''))) IN ('F','FEMALE') then 'FEMALE'
        WHEN UPPER(TRIM(REPLACE(REPLACE(c.GEN, CHAR(13), ''), CHAR(10), ''))) IN ('M','MALE') then 'MALE'
        ELSE 'N/A'
    END as gen
    from bronze.erp_cust_az12 c



    -- =============================================
    -- bronze.erp_loc_a101  => silver.erp_loc_a101 
    -- =============================================
    PRINT 'TRUNCATING DATA FROM silver.erp_loc_a101'
    TRUNCATE TABLE silver.erp_loc_a101
    PRINT 'INSERTING DATA INTO silver.erp_loc_a101'

    insert into silver.erp_loc_a101(cid,cntry)
    select REPLACE(l.cid, '-', '') as cid, 
    CASE 
        WHEN TRIM(CHAR(13) + CHAR(10) + ' ' FROM l.cntry) = 'DE' THEN 'GERMANY'
        WHEN TRIM(CHAR(13) + CHAR(10) + ' ' FROM l.cntry) IN ('US', 'USA', 'United States') THEN 'UNITED STATES'
        WHEN TRIM(CHAR(13) + CHAR(10) + ' ' FROM l.cntry) = 'UK' THEN 'UNITED KINGDOM'
        WHEN TRIM(CHAR(13) + CHAR(10) + ' ' FROM l.cntry) = '' OR l.cntry IS NULL THEN 'N/A'
        ELSE TRIM(CHAR(13) + CHAR(10) + ' ' FROM l.cntry)
    END AS cntry
    from bronze.erp_loc_a101 l
    


    -- =============================================
    -- [bronze].[erp_px_cat_g1v2]  => [silver].[erp_px_cat_g1v2]
    -- =============================================
    PRINT 'TRUNCATING DATA FROM silver.erp_px_cat_g1v2'
    TRUNCATE TABLE silver.erp_px_cat_g1v2
    PRINT 'INSERTING DATA INTO silver.erp_px_cat_g1v2'

    insert into silver.erp_px_cat_g1v2 (id,cat,subcat,maintenance)
    select id,
    cat,
    subcat,
    CASE WHEN TRIM(CHAR(13) + CHAR(10) + ' ' FROM l.maintenance) = 'No' THEN 'No'
        when TRIM(CHAR(13) + CHAR(10) + ' ' FROM l.maintenance) = 'Yes' THEN 'Yes'
    END AS maintenance 
    from bronze.erp_px_cat_g1v2 l

END
