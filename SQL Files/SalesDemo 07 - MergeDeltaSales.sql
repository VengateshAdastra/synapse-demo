EXECUTE AS USER = 'SalesDemo_ELTUser';
GO

--Redistribute staging table with hash key for better join performance
CREATE TABLE [salesdemo].[staging_sales_delta_hash]   
WITH   
  (   
    HEAP,  
    DISTRIBUTION = HASH(SalesID)  
  )  
AS SELECT * FROM [salesdemo].[staging_sales_delta]; 

-- Switch table names
RENAME OBJECT [salesdemo].[staging_sales_delta] to [staging_sales_delta_old];
RENAME OBJECT [salesdemo].[staging_sales_delta_hash] TO [staging_sales_delta];

--Drop old table
DROP TABLE [salesdemo].[staging_sales_delta_old];

EXECUTE AS USER = 'SalesDemo_ELTUser';
GO
--UPSERT fact table using CTAS approach
CREATE TABLE [salesdemo].[FactSales_new]
WITH
  (   
    CLUSTERED COLUMNSTORE INDEX,  
    DISTRIBUTION = HASH(SalesID)  
  )  
AS 
-- New rows and new versions of rows from staging delta
SELECT
[SalesID]
,[ProductID]
,[PostedDateID]
,[SalesOrganizationID]
,[CustomerID]
,[Units]
,[GrossSales]
,[NetSales]
,[CreateTimeStamp]
,[UpdateTimeStamp]
FROM [salesdemo].[staging_sales_delta]
UNION ALL
-- Keep rows from existing fact table that are not being touched
SELECT
fs.[SalesID]
,fs.[ProductID]
,fs.[PostedDateID]
,fs.[SalesOrganizationID]
,fs.[CustomerID]
,fs.[Units]
,fs.[GrossSales]
,fs.[NetSales]
,fs.[CreateTimeStamp]
,fs.[UpdateTimeStamp]
FROM [salesdemo].[FactSales] AS fs
LEFT OUTER JOIN [salesdemo].[staging_sales_delta] as fsdelta on fs.[SalesID] = fsdelta.[SalesID]
WHERE fsdelta.[SalesID] is null;

--Switch Tables
RENAME OBJECT [salesdemo].[FactSales]  TO [FactSales_old] ;
RENAME OBJECT [salesdemo].[FactSales_new]  TO [FactSales];

--Drop old fact table
DROP TABLE [salesdemo].[FactSales_old];

REVERT
GO

