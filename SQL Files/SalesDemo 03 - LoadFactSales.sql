EXECUTE AS USER = 'SalesDemo_ELTUser';
GO

IF NOT EXISTS (SELECT * FROM sys.objects O JOIN sys.schemas S ON O.schema_id = S.schema_id WHERE O.NAME = '[FactSales]' AND O.TYPE = 'U' AND S.NAME = '[salesdemo]')
CREATE TABLE [salesdemo].[FactSales]
WITH
	(
	DISTRIBUTION = HASH([SalesID]),
	CLUSTERED COLUMNSTORE INDEX
	)
AS
SELECT 
[SalesID],
[ProductID],
[PostedDateID],
[SalesOrganizationID],
[CustomerID],
[Units],
[GrossSales],
[NetSales],
[CreateTimeStamp],
[UpdateTimeStamp]
FROM
[salesdemo].[staging_sales];