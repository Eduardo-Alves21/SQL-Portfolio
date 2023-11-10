/* 1. You are responsible for managing a database where external user data is received. In summary, this data is:
- Username
- Date of birth
- Number of pets that user has
You'll need to create SQL code that can piece together the information provided by this user. To simulate this data, create 3 variables, called: name, birthdate, and num_pets. You should store the values 'Andrew', '10/02/1998', and 2, respectively. */

DECLARE @name VARCHAR(30) = 'Andrew'
DECLARE @birthdate DATETIME = '1998/02/10'
DECLARE @num_pets INT = 2

SELECT 
	'My name is ' + CAST (@name AS VARCHAR(30)) + ', I was born in ' + FORMAT (@birthdate, 'dd/MM/yyyy') + ' and I have ' + CAST (@num_pets AS VARCHAR(30)) + ' pets.' 


/* 2. You have just been promoted and your role will be to perform quality control over the company's stores. 
The first piece of information that is passed on to you is that the year 2008 was very complicated for the company, as it was when two of the main stores closed. Your first challenge is to find out the name of those stores that closed in 2008, so you can understand why and map out action plans to prevent other important stores from taking the same path.
Your result should be structured in a sentence, with the following structure:
'The stores closed in the year 2008 were: ' + store_name */

DECLARE	
	@store_name VARCHAR(50)
SET
	@store_name = ' '
SELECT
	@store_name = @store_name + StoreName + ', '
FROM
	DimStore
WHERE 
	FORMAT (CloseDate, 'yyyy') = 2008

PRINT 'The stores closed in the year 2008 were:' + @store_name


/* 3. You need to create a query to show the list of products from the DimProduct table for a specific subcategory: 'Lamps'.
Use the concept of variables to arrive at this result. */

DECLARE 
	@subcategory VARCHAR (10) = 'Lamps'
DECLARE 
	@subcategorykey INT 
		= (SELECT ProductSubcategoryKey 
				FROM DimProductSubcategory  
					WHERE ProductSubcategoryName = @subcategory)

SELECT 
	* 
FROM
	DimProduct
WHERE
	ProductSubcategoryKey = @subcategorykey