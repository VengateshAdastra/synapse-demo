EXECUTE AS USER = 'SalesDemo_ELTUser';
GO

IF NOT EXISTS (SELECT * FROM sys.objects O JOIN sys.schemas S ON O.schema_id = S.schema_id WHERE O.NAME = '[DimProduct]' AND O.TYPE = 'U' AND S.NAME = '[salesdemo]')
CREATE TABLE [salesdemo].[DimProduct]
WITH
	(
	DISTRIBUTION = REPLICATE,
	 CLUSTERED INDEX ([ProductID])
	)
AS
SELECT
[ProductID],
[ProductNumber],
[ProductDesc],
[TradeName],
[PrimaryMarket],
getdate() as [EffectiveDate],
'Y' as [CurrentFlag]
FROM
[salesdemo].[staging_product];


--SELECT TOP 100 * from [salesdemo].[DimProduct]