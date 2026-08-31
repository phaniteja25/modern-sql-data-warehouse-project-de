/*
===============================================================================
Stored Procedure: gold.load_gold
===============================================================================
Purpose:
    Creates/refreshes the Gold layer views for customers, products and sales
    by (re)building them from the Silver layer tables:
        - gold.dim_customers
        - gold.dim_products
        - gold.fact_sales

    Since CREATE OR ALTER VIEW must be the only statement in its batch, each
    view definition is executed via dynamic SQL (sp_executesql) so that all
    three can live inside a single stored procedure.

Error Handling:
    The whole procedure runs inside a TRY/CATCH block. On failure it prints
    the error number, severity, state, line and message, then re-throws the
    error so the caller (job/orchestrator) is also notified of the failure.

Usage Example:
    EXEC gold.load_gold;
===============================================================================
*/
CREATE OR ALTER PROCEDURE gold.load_gold AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @start_time      DATETIME;
    DECLARE @end_time        DATETIME;
    DECLARE @batch_start_time DATETIME;
    DECLARE @batch_end_time   DATETIME;
    DECLARE @sql              NVARCHAR(MAX);

    BEGIN TRY
        SET @batch_start_time = GETDATE();

        PRINT '================================================';
        PRINT 'Building Gold Layer Views';
        PRINT '================================================';

        ------------------------------------------------------------------
        -- gold.dim_customers
        ------------------------------------------------------------------
        PRINT '------------------------------------------------';
        PRINT 'Creating View: gold.dim_customers';
        PRINT '------------------------------------------------';
        SET @start_time = GETDATE();

        SET @sql = N'
        CREATE OR ALTER VIEW gold.dim_customers AS
        SELECT
            ROW_NUMBER() OVER (ORDER BY ci.cst_id) AS customer_pkey,
            ci.cst_id                              AS customer_id,
            ci.cst_key                             AS customer_key,
            ci.cst_firstname                       AS first_name,
            ci.cst_lastname                        AS last_name,
            la.cntry                               AS country,
            ci.cst_marital_status                  AS marital_status,
            CASE
                WHEN ci.cst_gendr <> ''N/A'' THEN ci.cst_gendr
                ELSE COALESCE(ca.gen, ''N/A'')
            END                                     AS gender,
            ca.bdate                               AS birth_date,
            ci.cst_created_date                    AS created_date
        FROM silver.crm_cust_info ci
        LEFT JOIN silver.erp_cust_az12 ca
            ON ci.cst_key = ca.cid
        LEFT JOIN silver.erp_loc_a101 la
            ON ci.cst_key = la.cid;';
        EXEC sp_executesql @sql;

        SET @end_time = GETDATE();
        PRINT 'View Created. Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' second(s)';

        ------------------------------------------------------------------
        -- gold.dim_products
        ------------------------------------------------------------------
        PRINT '------------------------------------------------';
        PRINT 'Creating View: gold.dim_products';
        PRINT '------------------------------------------------';
        SET @start_time = GETDATE();

        SET @sql = N'
        CREATE OR ALTER VIEW gold.dim_products AS
        SELECT
            ROW_NUMBER() OVER (ORDER BY cp.prd_start_dt, cp.prd_key) AS product_key,
            cp.prd_id                                                AS product_id,
            cp.prd_key                                                AS prd_number,
            cp.prd_nm                                                 AS product_name,
            cp.prd_cat                                                AS category_id,
            cp.prd_cost                                               AS product_cost,
            cp.prd_line                                               AS product_line,
            cp.prd_start_dt                                           AS product_start_dt,
            ep.cat                                                    AS product_category,
            ep.subcat                                                 AS product_sub_category,
            ep.maintenance                                            AS product_maintenance
        FROM silver.crm_prd_info cp
        LEFT JOIN silver.erp_px_cat_g1v2 ep
            ON cp.prd_cat = ep.id
        WHERE cp.prd_end_dt IS NULL;';
        EXEC sp_executesql @sql;

        SET @end_time = GETDATE();
        PRINT 'View Created. Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' second(s)';

        ------------------------------------------------------------------
        -- gold.fact_sales
        ------------------------------------------------------------------
        PRINT '------------------------------------------------';
        PRINT 'Creating View: gold.fact_sales';
        PRINT '------------------------------------------------';
        SET @start_time = GETDATE();

        SET @sql = N'
        CREATE OR ALTER VIEW gold.fact_sales AS
        SELECT
            cs.sls_ord_num  AS order_number,
            dp.product_key  AS product_key,
            dc.customer_pkey AS customer_pkey,
            cs.sls_order_dt AS order_date,
            cs.sls_ship_dt  AS shipping_date,
            cs.sls_due_dt   AS shipping_due_date,
            cs.sls_sales    AS sales_amount,
            cs.sls_quantity AS sales_quantity,
            cs.sls_price    AS price
        FROM silver.crm_sales_detail cs
        LEFT JOIN gold.dim_products dp
            ON cs.sls_prd_key = dp.prd_number
        LEFT JOIN gold.dim_customers dc
            ON cs.sls_cust_id = dc.customer_id;';
        EXEC sp_executesql @sql;

        SET @end_time = GETDATE();
        PRINT 'View Created. Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' second(s)';

        SET @batch_end_time = GETDATE();
        PRINT '================================================';
        PRINT 'Gold Layer Views built successfully';
        PRINT 'Total Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' second(s)';
        PRINT '================================================';

    END TRY
    BEGIN CATCH
        PRINT '================================================';
        PRINT 'ERROR OCCURRED WHILE BUILDING GOLD LAYER VIEWS';
        PRINT 'Error Message : ' + ERROR_MESSAGE();
        PRINT 'Error Number  : ' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error Severity: ' + CAST(ERROR_SEVERITY() AS NVARCHAR);
        PRINT 'Error State   : ' + CAST(ERROR_STATE() AS NVARCHAR);
        PRINT 'Error Line    : ' + CAST(ERROR_LINE() AS NVARCHAR);
        PRINT 'Error Procedure: ' + ISNULL(ERROR_PROCEDURE(), '-');
        PRINT '================================================';

        -- Re-throw so the calling job/orchestrator also sees the failure.
        THROW;
    END CATCH
END
