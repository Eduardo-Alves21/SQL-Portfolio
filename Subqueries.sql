/* 1. For tax purposes, the company's accounting needs a table containing all sales for the 'Contoso Orlando Store'. This is because this store is located in a region where taxation has recently changed.
Therefore, create a query to the Database to get a FactSales table containing all the sales for this store. */

SELECT 
	*
FROM
	FactSales
WHERE
	StoreKey =
	(SELECT StoreKey FROM DimStore WHERE StoreName = 'Contoso Orlando Store')


/* 2. The product control industry wants to do an analysis to find out which products have a UnitPrice greater than the UnitPrice of the product ID equal to 1893.
a) Your resulting query should contain the ProductKey, ProductName, and UnitPrice columns from the DimProduct table.
b) In this query you should also return an extra column, which informs the UnitPrice of the product 1893. */

SELECT 
	ProductKey,
	ProductName,
	UnitPrice,
	(SELECT UnitPrice FROM DimProduct WHERE ProductKey = 1893) AS 'Unit Price Product 1893'
FROM 
	DimProduct
WHERE 
	UnitPrice > (SELECT UnitPrice FROM DimProduct WHERE ProductKey = 1893)
ORDER BY 
	UnitPrice


/* 3. The Contoso company has created a bonus program called "All for 1." This program consisted of the following: 1 employee would be chosen at the end of the year as the outstanding employee, but the bonus would be received by everyone in that particular employee's area. The objective of this program would be to encourage collective collaboration among employees in the same area. In this way, the outstanding employee would benefit not only himself, but also all colleagues in his area.
At the end of the year, the employee chosen as a highlight was Miguel Severino. This means that all employees in Miguel's area would benefit from the program.
Its objective is to perform a query on the DimEmployee table and return all the employees in the "winning" area so that the Financial sector can make the bonus payments. */

SELECT
	EmployeeKey,
	FirstName,
	LastName,
	DepartmentName
FROM
	DimEmployee
WHERE
	DepartmentName IN
		(SELECT DepartmentName FROM DimEmployee WHERE FirstName = 'Miguel' AND LastName = 'Severino')


/* 4. Make a query that returns customers who receive an above-average annual salary. Your query should return the CustomerKey, FirstName, LastName, EmailAddress, and YearlyIncome columns.
Note: consider only customers who are 'Individuals'. */

SELECT
	CustomerKey,
	FirstName,
	LastName,
	EmailAddress,
	YearlyIncome
FROM
	DimCustomer
WHERE
	YearlyIncome >
		(SELECT AVG (YearlyIncome) FROM DimCustomer WHERE CustomerType = 'Person')
ORDER BY
	YearlyIncome


/*- 5. The Asian Holiday Promotion discount action was one of the company's most successful. Now, Contoso wants to understand a little better about the profile of customers who bought products with this promotion.
Your job is to create a query that returns the list of customers who bought from this promotion. */

SELECT
	CustomerKey,
	FirstName,
	LastName
FROM
	DimCustomer
WHERE
	CustomerKey IN (
		SELECT CustomerKey FROM FactOnlineSales WHERE PromotionKey IN (
			SELECT PromotionKey FROM DimPromotion WHERE PromotionName = 'Asian Holiday Promotion')
		)


/* 6. The company has implemented a business customer loyalty program. All those who buy more than 3000 units of the same product will receive discounts on other purchases.
You should find out the CustomerKey and CompanyName information for these customers. */

SELECT
	CustomerKey,
	CompanyName
FROM
	DimCustomer
WHERE
	CustomerKey IN (
		SELECT CustomerKey FROM FactOnlineSales GROUP BY CustomerKey, ProductKey HAVING COUNT(*) >= 3000 
		)


/* 7. You must create a query for sales that shows the following columns from the DimProduct table: ProductKey, ProductName, BrandName, UnitPrice, Average UnitPrice. */

SELECT
	ProductKey,
	ProductName,
	BrandName,
	UnitPrice,
	(SELECT AVG(UnitPrice) FROM DimProduct) AS 'Average UnitPrice'
FROM
	DimProduct


/* 8. Make a query to find out the following indicators of your products: Highest number of products per brand; Fewer products per brand; Average products per brand */

SELECT
	MAX(Quantity) AS 'Maximum',
	MIN(Quantity) AS 'Minimum',
	AVG(Quantity) AS 'Average' 
FROM (
	SELECT BrandName, COUNT(*) AS 'Quantity' FROM DimProduct GROUP BY BrandName
	) AS T


/* 9. Create a CTE that is the grouping of the DimProduct table, storing the total products by brand. Then, do a SELECT on this CTE, finding out what the maximum amount of products for a brand is. Call this CTE CTE_QttProductsPerBrand. */

WITH CTE_QttProductsPerBrand AS (
SELECT 
	BrandName,
	COUNT(*) AS 'Quantity'
FROM
	DimProduct
GROUP BY 
	BrandName
)

SELECT MAX(Quantity) FROM CTE_QttProductsPerBrand


/* 10. Create two CTEs: 
(i) the first one must contain the ProductKey, ProductName, ProductSubcategoryKey, BrandName, and UnitPrice columns of the DimProduct table, but only the Adventure brand products 
Works. Call this CTE CTE_ProdutosAdventureWorks.
(ii) the second must contain the columns ProductSubcategoryKey, ProductSubcategoryName, of the DimProductSubcategory table but only for the subcategories 'Televisions' and 'Monitors'. 
Call this CTE CTE_CategoriaTelevisionsERadio.
Do a Join between these two CTEs, and the result should be a query containing all the columns of the two tables. Notice in this example the difference between LEFT JOIN and INNER JOIN */

WITH CTE_ProdutosAdventureWorks AS (
SELECT
	ProductKey,
	ProductName,
	ProductSubcategoryKey,
	BrandName,
	UnitPrice
FROM
	DimProduct
WHERE
	BrandName = 'Adventure Works'
),

CTE_CategoriaTelevisionsERadio AS (
SELECT
	ProductSubcategoryKey,
	ProductSubcategoryName
FROM
	DimProductSubcategory
WHERE
	ProductSubcategoryName IN ('Televisions', 'Monitors')
)

SELECT
	CTE_ProdutosAdventureWorks.*,
	CTE_CategoriaTelevisionsERadio.ProductSubcategoryName
FROM
	CTE_ProdutosAdventureWorks
		LEFT JOIN CTE_CategoriaTelevisionsERadio
			ON CTE_ProdutosAdventureWorks.ProductSubcategoryKey = CTE_CategoriaTelevisionsERadio.ProductSubcategoryKey


SELECT
	CTE_ProdutosAdventureWorks.*,
	CTE_CategoriaTelevisionsERadio.ProductSubcategoryName
FROM
	CTE_ProdutosAdventureWorks
		INNER JOIN CTE_CategoriaTelevisionsERadio
			ON CTE_ProdutosAdventureWorks.ProductSubcategoryKey = CTE_CategoriaTelevisionsERadio.ProductSubcategoryKey