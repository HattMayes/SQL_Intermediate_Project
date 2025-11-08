-- Conditional Handle NULLs

-- COALESCE -
-- Returns the first non-NULL value from a list of expressions 
-- Used to replace NULL values with a default. Common in reporting and data cleaning, such as filling missing values with a placeholder.

-- NULLIF -
-- Returns NULL if two expressions are equal, otherwise, returns the first expression.
-- Helps prevent division by zero by returning NULL instead of causing an error.

-- Coalesce for Average Revenue - Spending Customers Vs. All Customers -
/*
1. Convert code to CTE.
2. Want to make customer table the main table, so merge sales table onto it. - use LEFT JOIN.
3. Modify what is displayed from customer and sales table i.e. "c.customerkey", "sd.net.revenue".
4. Use COALESCE to replace "NULL" with "0".
5. Now will calculate net average of "net_revenue" with NULL values and with 0 values to truly compare spending customers Vs. all customers
*/

WITH sales_data AS (
	SELECT 
		customerkey,
		SUM(quantity * netprice * exchangerate) AS net_revenue
	FROM
		sales s
	GROUP BY 
		customerkey 
)
SELECT 
	c.customerkey,
	sd.net_revenue,
	COALESCE(sd.net_revenue, 0)
FROM 
	customer c
LEFT JOIN 
	sales_data sd ON c.customerkey = sd.customerkey;


-- Final code -

WITH sales_data AS (
	SELECT 
		customerkey,
		SUM(quantity * netprice * exchangerate) AS net_revenue
	FROM
		sales s
	GROUP BY 
		customerkey 
)
SELECT 
	AVG(sd.net_revenue) AS spending_customers,
	AVG(COALESCE(sd.net_revenue, 0)) AS all_customers
FROM 
	customer c
LEFT JOIN 
	sales_data sd ON c.customerkey = sd.customerkey
	
-- Clear to see when looking at all customers, average net_revenue is less.
