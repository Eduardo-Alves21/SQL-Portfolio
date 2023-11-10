/* 1. a) Make a summary of the quantity sold according to the name of the sales channel. You must sort the final table according to SalesQuantity, in descending order.
b) Make a grouping showing the total quantity sold and total quantity returned according to the name of the stores.
c) Make a summary of the total amount sold for each month and year. */

-- a)

SELECT
	ChannelName AS 'Canal',
	SUM(SalesQuantity) AS 'Qtd de vendas'
FROM
	DimChannel
		INNER JOIN FactSales
			ON DimChannel.ChannelKey = FactSales.channelKey
GROUP BY
	ChannelName
ORDER BY
	SUM(SalesQuantity) DESC

-- b)

SELECT
	StoreName AS 'Loja',
	SUM(SalesQuantity) AS 'Qtd de vendas',
	SUM(ReturnQuantity) AS 'Qtd de devoluções'
FROM
	DimStore
		INNER JOIN FactSales
			ON DimStore.StoreKey = FactSales.StoreKey
GROUP BY
	StoreName
ORDER BY
	SUM(SalesQuantity) DESC

-- c)

SELECT
	CalendarYear AS 'Ano',
	CalendarMonthLabel AS 'Mês',
	SUM(SalesAmount) AS 'Total vendido'
FROM
	DimDate
		INNER JOIN FactSales
			ON DimDate.Datekey = FactSales.DateKey
GROUP BY
	CalendarYear, CalendarMonthLabel
ORDER BY
	CalendarYear


/*2.Supplement the DimProduct table with the ProductCategoryDescription information. Return in your SELECT only the 5 columns that you consider most relevant.*/

SELECT
	DimProduct.ProductSubcategoryKey,
	ProductName,
	ProductSubcategoryDescription,
	Manufacturer,
	BrandName
FROM
	DimProduct
		Left Join DimProductSubcategory
			On DimProduct.ProductSubcategoryKey= DimProductSubcategory.ProductSubcategoryKey


/*3.Find out which are the sales channel for the brands Contoso, Fabrikam e Litware.*/

SELECT
	DISTINCT BrandName,
	ChannelName
FROM
	DimProduct
		Cross join DimChannel
WHERE BrandName In ('Contoso', 'Fabrikam', 'Litware')


/*4. a) You should do a query to the FactOnlineSales table and find out what is the full name of the customer who made the most online purchases.
b) Once this is done, make a group of products and find out which were the top 10 products most purchased by the customer of the letter a, considering the name of the product. */

-- a)

SELECT TOP(1) 
	FirstName AS 'Primeiro Nome',
	LastName AS 'Último Nome',
	SUM(SalesQuantity) AS 'Nº de compras'
FROM
	FactOnlineSales
		INNER JOIN DimCustomer
			ON FactOnlineSales.CustomerKey = DimCustomer.CustomerKey
WHERE 
	FirstName IS NOT NULL
GROUP BY
	FirstName, LastName 
ORDER BY
	SUM(SalesQuantity) DESC

-- b)

SELECT TOP(10)
	ProductName AS 'Produto',
	SUM(SalesQuantity) AS 'Qtd comprada'
FROM
	FactOnlineSales
		INNER JOIN DimProduct
			ON	FactOnlineSales.ProductKey = DimProduct.ProductKey
				INNER JOIN DimCustomer
					ON FactOnlineSales.CustomerKey = DimCustomer.CustomerKey
WHERE 
	FirstName = 'Lacey'
		AND LastName = 'Xu'
GROUP BY
	ProductName
ORDER BY 
	SUM(SalesQuantity) DESC


/*5. Make a summary table showing the average exchange rate according to each CurrencyDescription. The final table should only contain rates between 10 and 100. */

SELECT
	CurrencyDescription AS 'Moeda',
	AVG(AverageRate) AS 'Taxa média'
FROM
	FactExchangeRate
		INNER JOIN DimCurrency
			ON FactExchangeRate.CurrencyKey = DimCurrency.CurrencyKey
GROUP BY
	CurrencyDescription
HAVING
	AVG(AverageRate) BETWEEN 10 AND 100


/*6. Calculate the TOTAL SUM of AMOUNT for the FactStrategyPlan table for the scenarios: Current and Budget.*/

SELECT
	ScenarioName AS 'Cenário',
	SUM(Amount) AS 'Total'
FROM
	DimScenario
		INNER JOIN FactStrategyPlan
			ON DimScenario.ScenarioKey = FactStrategyPlan.ScenarioKey
WHERE 
	ScenarioName <> 'Forecast'
GROUP BY
	ScenarioName


/*7. Double-group product quantity by BrandName and ProductSubcategoryName. The final table should be sorted according to the BrandName */ 

SELECT 
	BrandName AS 'Marca',
	ProductSubcategoryName AS 'Subcategoria',
	COUNT (ProductKey) AS 'Quantidade'
FROM
	DimProduct
		INNER JOIN DimProductSubcategory
			ON DimProduct.ProductSubcategoryKey = DimProductSubcategory.ProductSubcategoryKey
GROUP BY
	ProductSubcategoryName, BrandName
ORDER BY
	BrandName