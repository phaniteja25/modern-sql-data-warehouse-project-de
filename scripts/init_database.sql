--creating a new schema 
USE MASTER;

--DROP AND RECREATE THE DataWarehouse database
IF EXISTS (SELECT * FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
    DROP DATABASE DataWarehouse;
END
GO

--create the DataWarehouse database
CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO  

-- CREATE THE SLIVER,GOLD AND BRONZE SCHEMAS 
CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
GO
