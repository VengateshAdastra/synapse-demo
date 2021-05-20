EXECUTE AS USER = 'SalesDemo_ELTUser';
GO

IF NOT EXISTS (SELECT * FROM sys.objects O JOIN sys.schemas S ON O.schema_id = S.schema_id WHERE O.NAME = '[staging_product]' AND O.TYPE = 'U' AND S.NAME = '[salesdemo]')
CREATE TABLE [salesdemo].[staging_product]
	(
	 [ProductID] int,
	 [ProductNumber] nvarchar(4000),
	 [ProductDesc] nvarchar(4000),
	 [TradeName] nvarchar(4000),
	 [PrimaryMarket] nvarchar(4000)
	)
WITH
	(
	DISTRIBUTION = ROUND_ROBIN,
	 HEAP
	 -- CLUSTERED COLUMNSTORE INDEX
	)
GO

--Uncomment the 4 lines below to create a stored procedure for data pipeline orchestration​
--CREATE PROC bulk_load_[product]
--AS
--BEGIN
COPY INTO [salesdemo].[staging_product]
(ProductID 1, ProductNumber 2, ProductDesc 3, TradeName 4, PrimaryMarket 5)
FROM 'https://adastrasynapsestorage.dfs.core.windows.net/salesdemo/product/*'
WITH
(
	FILE_TYPE = 'PARQUET'
	,MAXERRORS = 0
	,COMPRESSION = 'snappy'
	,IDENTITY_INSERT = 'OFF'
)
--END
GO

SELECT TOP 100 * FROM [salesdemo].[staging_product]
GO

REVERT
GO