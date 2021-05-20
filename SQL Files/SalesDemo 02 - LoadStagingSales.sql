EXECUTE AS USER = 'SalesDemo_ELTUser';
GO

IF NOT EXISTS (SELECT * FROM sys.objects O JOIN sys.schemas S ON O.schema_id = S.schema_id WHERE O.NAME = '[staging_sales]' AND O.TYPE = 'U' AND S.NAME = '[salesdemo]')
CREATE TABLE [salesdemo].[staging_sales]
	(
	 [SalesID] int,
	 [ProductID] int,
	 [PostedDateID] int,
	 [SalesOrganizationID] int,
	 [CustomerID] int,
	 [Units] numeric(26,12),
	 [GrossSales] numeric(26,12),
	 [NetSales] numeric(26,12),
	 [CreateTimeStamp] datetime2(7),
	 [UpdateTimeStamp] datetime2(7)
	)
WITH
	(
	DISTRIBUTION = ROUND_ROBIN,
	HEAP
	)
GO

--Uncomment the 4 lines below to create a stored procedure for data pipeline orchestration​
--CREATE PROC bulk_load_[staging_sales]
--AS
--BEGIN
COPY INTO [salesdemo].[staging_sales]
(SalesID 1, ProductID 2, PostedDateID 3, SalesOrganizationID 4, CustomerID 5, Units 6, GrossSales 7, NetSales 8, CreateTimeStamp 9, UpdateTimeStamp 10)
FROM 'https://adastrasynapsestorage.dfs.core.windows.net/salesdemo/sales'
WITH
(
	FILE_TYPE = 'PARQUET'
	,MAXERRORS = 0
	,COMPRESSION = 'snappy'
	,IDENTITY_INSERT = 'OFF'
)
--END
GO
