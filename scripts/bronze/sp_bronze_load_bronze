/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Purpose:
    This stored procedure loads data into the 'bronze' schema from external
    CSV source files. It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the BULK INSERT command to load data from CSV files into
      bronze tables for both the CRM and ERP source systems.

Parameters:
    None.
    This stored procedure does not accept any parameters or return any
    values.

Usage Example:
    EXEC bronze.load_bronze;
===============================================================================
*/


CREATE OR ALTER PROCEDURE bronze.load_bronze AS 
BEGIN
    DECLARE @STARTTIME DATETIME, @ENDTIME DATETIME, @START_BATCH_TIME DATETIME, @END_BATCH_TIME DATETIME;
    SET @START_BATCH_TIME = GETDATE();
    BEGIN TRY

        PRINT '===============================';
        PRINT 'LOADING DATA INTO BRONZE TABLES';
        PRINT '===============================';


        /*INSERTING DATA INTO CRM TABLES */
        PRINT '===============================';
        PRINT 'LOADING DATA INTO CRM TABLES';
        PRINT '===============================';

        PRINT '==============================='; 
        PRINT 'TRUNCATING DATA INTO CRM CUSTOMER INFO TABLE';
        PRINT '===============================';
        SET @STARTTIME = GETDATE();
        TRUNCATE TABLE bronze.crm_cust_info;

        PRINT '===============================';
        PRINT 'BULK INSERTING DATA INTO CRM CUSTOMER INFO TABLE';
        PRINT '===============================';
        BULK INSERT bronze.crm_cust_info
        FROM '/data/datasets/source_crm/cust_info.csv'
        WITH (
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            FIRSTROW = 2,
            TABLOCK
        );
        SET @ENDTIME = GETDATE();
        PRINT 'TIME TAKEN TO LOAD CRM CUSTOMER INFO TABLE: ' + CAST(DATEDIFF(SECOND, @STARTTIME, @ENDTIME) AS VARCHAR(10)) + ' seconds';

        PRINT '===============================';
        PRINT 'TRUNCATING DATA INTO CRM PRODUCT INFO TABLE';
        PRINT '===============================';
        TRUNCATE TABLE bronze.crm_prd_info;
        SET @STARTTIME = GETDATE();
        PRINT '===============================';
        PRINT 'BULK INSERTING DATA INTO CRM PRODUCT INFO TABLE';
        PRINT '===============================';
        BULK INSERT bronze.crm_prd_info
        FROM '/data/datasets/source_crm/prd_info.csv'
        WITH (
            FIELDTERMINATOR = ',',
            --ROWTERMINATOR = '\n',
            FIRSTROW = 2,
            TABLOCK
        );
        SET @ENDTIME = GETDATE();
        PRINT 'TIME TAKEN TO LOAD CRM PRODUCT INFO TABLE: ' + CAST(DATEDIFF(SECOND, @STARTTIME, @ENDTIME) AS VARCHAR(10)) + ' seconds';

        PRINT '===============================';
        PRINT 'TRUNCATING DATA INTO CRM SALES DETAIL TABLE';
        PRINT '===============================';
        TRUNCATE TABLE bronze.crm_sales_detail;
        SET @STARTTIME = GETDATE();
        PRINT '===============================';
        PRINT 'BULK INSERTING DATA INTO CRM SALES DETAIL TABLE';
        PRINT '===============================';
        BULK INSERT bronze.crm_sales_detail
        FROM '/data/datasets/source_crm/sales_details.csv'
        WITH (
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            FIRSTROW = 2,
            TABLOCK
        );

        SET @ENDTIME = GETDATE();
        PRINT 'TIME TAKEN TO LOAD CRM SALES DETAIL TABLE: ' + CAST(DATEDIFF(SECOND, @STARTTIME, @ENDTIME) AS VARCHAR(10)) + ' seconds';
        
        /*
        INSERTING DATA INTO ERP TABLES 

        */
        PRINT '===============================';
        PRINT 'LOADING DATA INTO ERP TABLES';
        PRINT '===============================';

        PRINT '===============================';
        PRINT 'TRUNCATING DATA INTO ERP CUSTOMER TABLE';
        PRINT '===============================';
        TRUNCATE TABLE bronze.erp_cust_az12;
        SET @STARTTIME = GETDATE();
        PRINT '===============================';
        PRINT 'BULK INSERTING DATA INTO ERP CUSTOMER TABLE';
        PRINT '===============================';
        BULK INSERT bronze.erp_cust_az12
        FROM '/data/datasets/source_erp/CUST_AZ12.csv'
        WITH (
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            FIRSTROW = 2,
            TABLOCK
        );
        SET @ENDTIME = GETDATE();
        PRINT 'TIME TAKEN TO LOAD ERP CUSTOMER TABLE: ' + CAST(DATEDIFF(SECOND, @STARTTIME, @ENDTIME) AS VARCHAR(10)) + ' seconds';



        PRINT '===============================';
        PRINT 'TRUNCATING DATA INTO ERP LOCATION TABLE';
        PRINT '===============================';    
        TRUNCATE TABLE bronze.erp_loc_a101;
        SET @STARTTIME = GETDATE(); 
        PRINT '===============================';
        PRINT 'BULK INSERTING DATA INTO ERP LOCATION TABLE';
        PRINT '===============================';
        BULK INSERT bronze.erp_loc_a101
        FROM '/data/datasets/source_erp/LOC_A101.csv'
        WITH (
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            FIRSTROW = 2,
            TABLOCK
        );
        SET @ENDTIME = GETDATE();
        PRINT 'TIME TAKEN TO LOAD ERP LOCATION TABLE: ' + CAST(DATEDIFF(SECOND, @STARTTIME, @ENDTIME) AS VARCHAR(10)) + ' seconds'; 


        PRINT '===============================';
        PRINT 'TRUNCATING DATA INTO ERP PRODUCT CATEGORY TABLE';
        PRINT '===============================';
        TRUNCATE TABLE bronze.erp_px_cat_g1v2;
        SET @STARTTIME = GETDATE();

        PRINT '===============================';
        PRINT 'BULK INSERTING DATA INTO ERP PRODUCT CATEGORY TABLE';
        PRINT '===============================';
        BULK INSERT bronze.erp_px_cat_g1v2
        FROM '/data/datasets/source_erp/PX_CAT_G1V2.csv'
        WITH (
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            FIRSTROW = 2,
            TABLOCK
        );
        SET @ENDTIME = GETDATE();
        PRINT 'TIME TAKEN TO LOAD ERP PRODUCT CATEGORY TABLE: ' + CAST(DATEDIFF(SECOND, @STARTTIME, @ENDTIME) AS VARCHAR(10)) + ' seconds';
        
        SET @END_BATCH_TIME = GETDATE();
        PRINT '===============================';
        PRINT 'TIME TAKEN TO LOAD ALL BRONZE TABLES: ' + CAST(DATEDIFF(SECOND, @START_BATCH_TIME, @END_BATCH_TIME) AS VARCHAR(10)) + ' seconds';
        PRINT '===============================';
         
    END TRY

    BEGIN CATCH
            PRINT '===============================';
            PRINT 'ERROR OCCURRED WHILE LOADING DATA INTO BRONZE TABLES';
            PRINT '===============================';
            PRINT 'ERROR MESSAGE: ' + CAST(ERROR_MESSAGE() AS VARCHAR(255));
            PRINT 'ERROR NUMBER: ' + CAST(ERROR_NUMBER() AS VARCHAR(255));
    END CATCH

END 
