SELECT TOP(1)* FROM FactInternetSales
SELECT TOP(1)* FROM DimProductCategory 
SELECT TOP(1)* FROM DimProductSubcategory
SELECT TOP(1)* FROM DimProduct



GO
CREATE OR ALTER VIEW RESULTADOS_ADW AS
SELECT
	fis.SalesOrderNumber AS 'Nº Pedido',
	fis.OrderDate AS 'Data Pedido',
	dpc.EnglishProductCategoryName AS 'Categoria Produto',
	dc.CustomerKey AS 'ID Cliente',
	CONCAT(dc.FirstName, ' ', dc.LastName) AS 'Nome Cliente',
	REPLACE(REPLACE(dc.Gender, 'M', 'Masculino'), 'F', 'Feminino') AS 'Sexo',
	dg.EnglishCountryRegionName AS 'País',
	fis.OrderQuantity AS 'Qtd Vendida',
	fis.SalesAmount AS 'Receita de Venda',
	fis.TotalProductCost AS 'Custo de Venda',
	(fis.SalesAmount - fis.TotalProductCost) AS 'Lucro Venda'
FROM
	FactInternetSales AS fis
		INNER JOIN DimProduct AS dp 
			ON fis.ProductKey = dp.ProductKey
				INNER JOIN DimProductSubcategory AS dpsc
					ON dp.ProductSubcategoryKey = dpsc.ProductSubcategoryKey
						INNER JOIN DimProductCategory AS dpc
							ON dpsc.ProductCategoryKey = dpc.ProductCategoryKey
		INNER JOIN DimCustomer AS dc
			ON fis.CustomerKey = dc.CustomerKey
				INNER JOIN DimGeography AS dg
					ON dc.GeographyKey = dg.GeographyKey


GO

SELECT * FROM RESULTADOS_ADW