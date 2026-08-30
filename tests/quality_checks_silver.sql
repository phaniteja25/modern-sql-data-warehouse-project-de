/*

Checking Data Quality in Bronze Layer before loading into Silver Layer


*/

-- 1) Checking for duplicate or null values in the primary key of bronze.crm_cust_info table
-- Expectation : No records should be returned

select cst_id, count(*) as record_count
from bronze.crm_cust_info
group by bronze.crm_cust_info.cst_id
having count(*) > 1 OR cst_id is NULL;

-- 2) Checking for unwanted spaces in string cols 
-- Expectation : No records 

select c.cst_firstname
from bronze.crm_cust_info c
where c.cst_firstname != TRIM(c.cst_firstname) -- 15 rows 

select c.cst_lastname
from bronze.crm_cust_info c
where c.cst_lastname != TRIM(c.cst_lastname) -- 17 rows 

select c.cst_gendr
from bronze.crm_cust_info c
where c.cst_gendr != TRIM(c.cst_gendr) -- 0 rows 

select c.cst_marital_status
from bronze.crm_cust_info c
where c.cst_marital_status != TRIM(c.cst_marital_status) -- 0 rows 


-- 3) Data standardization for Gender AND MARITAL_STATUS Column 

select distinct c.cst_gendr
from bronze.crm_cust_info c
-- cst_gendr
-- NULL
-- F
-- M

select distinct c.cst_marital_status
from bronze.crm_cust_info c


-- 4) Checking if the date column is actually DATE datatype and not varchar or int 
SELECT c.cst_created_date
FROM bronze.crm_cust_info c
WHERE TRY_CONVERT(date, c.cst_created_date) IS  NULL; -- 0 records 

/*********************

VALIDATING THE DATA QUALITY OF SILVER.crm_cust_info

**********************/


-- 1) Checking for duplicate or null values in the primary key of bronze.crm_cust_info table
-- Expectation : No records should be returned

select cst_id, count(*) as record_count
from SILVER.crm_cust_info
group by silver.crm_cust_info.cst_id
having count(*) > 1 OR cst_id is NULL; -- 0 records 

-- 2) Checking for unwanted spaces in string cols 
-- Expectation : No records 

select c.cst_firstname
from SILVER.crm_cust_info c
where c.cst_firstname != TRIM(c.cst_firstname) -- 0 rows 

select c.cst_lastname
from SILVER.crm_cust_info c
where c.cst_lastname != TRIM(c.cst_lastname) -- 0 rows 

select c.cst_gendr
from SILVER.crm_cust_info c
where c.cst_gendr != TRIM(c.cst_gendr) -- 0 rows 

select c.cst_marital_status
from SILVER.crm_cust_info c
where c.cst_marital_status != TRIM(c.cst_marital_status) -- 0 rows 



/*********************
Checking Data quality of bronze.crm_prd_info
***********************/

-- 1) Checking for duplicate or null values in the primary key of bronze.crm_prd_info table
-- Expectation : No records should be returned

select p.prd_id, count(*)
from bronze.crm_prd_info p 
group by p.prd_id
having count(*) >1 or p.prd_id is NULL
-- 0 records 

-- 2) Checking for negative  or null values in  prd_cost bronze.crm_prd_info table
-- Expectation : No records should be returned


select p.prd_cost
from bronze.crm_prd_info p 
where p.prd_cost < 0 or p.prd_cost is null 


-- 3) Data standardization for Gender AND MARITAL_STATUS SILVERlumn 

select distinct p.prd_line
from bronze.crm_prd_info p
-- cst_gendr
-- NULL
-- F
-- M

--- 4) DFata quality check for date column

select * 
from bronze.crm_prd_info p
where p.prd_start_dt > p.prd_end_dt

-- Replacing End Date of a product with next rows start date - 1 using LEAD window fucntion 

select p.prd_id,
p.prd_key,
p.prd_nm,
prd_cost,
prd_line,
p.prd_start_dt,
DATEADD(DAY, -1, LEAD(p.prd_start_dt) OVER (PARTITION BY p.prd_key order by prd_start_dt)) as prd_end_dt_test
from bronze.crm_prd_info p
where p.prd_key = 'CO-RF-FR-R92B-58'


/*********************

VALIDATING THE DATA QUALITY OF SILVER.crm_prd_info

*********************/

select p.prd_id, count(*)
from SILVER.crm_prd_info p 
group by p.prd_id
having count(*) >1 or p.prd_id is NULL
-- 0 records 

-- 2) Checking for negative  or null values in  prd_cost bronze.crm_prd_info table
-- Expectation : No records should be returned


select p.prd_cost
from SILVER.crm_prd_info p 
where p.prd_cost < 0 or p.prd_cost is null -- 0 records


-- 3) Data standardization for Gender AND MARITAL_STATUS Column 

select distinct p.prd_line
from SILVER.crm_prd_info p
-- cst_gendr
-- NULL
-- F
-- M

--- 4) DFata quality check for date column

select * 
from SILVER.crm_prd_info p
where p.prd_start_dt > p.prd_end_dt -- 0 records

-- Replacing End Date of a product with next rows start date - 1 using LEAD window fucntion 


/*********************
Checking Data quality of bronze.crm_sales_detail
***********************/

select * from bronze.crm_sales_detail s
where s.sls_ord_num != trim(s.sls_ord_num) -- 0 recordfs 


select * from bronze.crm_sales_detail s
where s.sls_prd_key not in (select p.prd_key from silver.crm_prd_info p) -- 0 records

select * from bronze.crm_sales_detail s
where s.sls_cust_id not in (select c.cst_id from silver.crm_cust_info c) -- 0 records

SELECT * 
FROM BRONZE.crm_sales_detail S
WHERE S.sls_order_dt > S.sls_ship_dt OR S.sls_order_dt > S.sls_due_dt -- 0 records




/*********************
Checking Data quality of bronze.erp_cust_az12
***********************/

select * 
from bronze.erp_cust_az12 c
where c.cid like '%AW00011000%' -- 0 records

select * 
from silver.crm_cust_info c

SELECT  distinct c.GEN
FROM BRONZE.erp_cust_az12 c
