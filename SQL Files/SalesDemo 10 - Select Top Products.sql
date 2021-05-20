SELECT top 10
dp.ProductDesc as Product,
sum(GrossSales) as TotalSales
FROM
[salesdemo].FactSales fs
inner join [salesdemo].DimProduct dp on fs.ProductID = dp.ProductID
WHERE
dp.CurrentFlag = 'Y'
and dp.ProductDesc <> 'Not Applicable'
group BY
dp.ProductDesc
ORDER BY 2 desc