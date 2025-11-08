-- QUERY OPTIMISATIONS -

-- EXPLAIN - Displays the execution plan of a query, but without executing it.
-- EXPLAIN ANALYZE - Exeucutes the query and provides actual execution times, row estimates, and other runtime details.
-- Both are good uses when working with large databases that could cost or take large amounts of time to load.

EXPLAIN
SELECT *
FROM Sales;

EXPLAIN ANALYZE
SELECT *
FROM Sales;

-- DBEaver also has "Explain Execution Plan" button below the "Run" button that does the same as EXPLAIN ANALYZE.

-- LIMIT - limits the number of columns displayed by a run.
-- Useful for large datasets that take ages to load when you don't want all the data.

SELECT *
FROM sales
LIMIT 10;

-- WHERE (instead of HAVING) - Filter before aggregation for efficiency, execution time shortened.

SELECT 
	customerkey,
	SUM(quantity * netprice * exchangerate) AS net_revenue
FROM sales s 
WHERE customerkey < 100
GROUP BY customerkey;

-- GROUP BY - Minimise usage of this command, each new filter increases query execution time.

SELECT 
	customerkey,
	orderdate,
	orderkey,
	SUM(quantity * netprice * exchangerate) AS net_revenue
FROM sales s 
GROUP BY 
	customerkey,
	orderdate,
	orderkey,
	linenumber;
	
-- JOINs - Minimise the number and different types of JOINs used, also increases query execution time.
-- Replacing JOINs with a function like EXTRACT can help reduce execution time.

EXPLAIN ANALYZE
SELECT
	c.customerkey,
	c.givenname,
	c.surname,
	p.productname,
	s.orderdate,
	s.orderkey,
	EXTRACT (YEAR FROM s.orderdate) AS year
FROM sales s 
INNER JOIN customer c ON s.customerkey = c.customerkey 
INNER JOIN product p ON p.productkey = s.productkey;

-- ORDER BY - Columns that filter the most rows should come first in ORDER BY, as this allows the database to eliminate more rows early in the sorting process.
-- Also try to limit number of columns in ORDER BY.

SELECT 
	customerkey,
	orderdate,
	orderkey,
	SUM(quantity * netprice * exchangerate) AS net_revenue
FROM sales s 
GROUP BY 
	customerkey,
	orderdate,
	orderkey
ORDER BY 
	customerkey,
	orderdate,
	orderkey;
	
-- Real-World Example - Using the cohort_analysis code -
/*
- Start Execution Time = ~190 - 200ms
1. Change LEFT JOIN to INNER JOIN, keeps the same number of rows but INNER JOIN skips NULL CHECK.
2. Minimise the GROUP BY filters, only need to GROUP BY customerkey and orderdate. Once removed, have to add MAX or MIN to the SELECT of the value for the wuery to run.
- End Execution Time = ~160ms
 */

EXPLAIN ANALYZE
WITH customer_revenue AS (
	SELECT
		s.customerkey,
		s.orderdate,
		sum(s.quantity::double PRECISION * s.netprice * s.exchangerate) AS total_net_revenue,
		count(s.orderkey) AS num_orders,
		MAX(c.countryfull) AS countryfull,
		MAX(c.age) AS age,
		MAX(c.givenname) AS givenname,
		MAX(c.surname) AS surname
	FROM
		sales s
	INNER JOIN customer c ON
		c.customerkey = s.customerkey
	GROUP BY
		s.customerkey,
		s.orderdate
)
SELECT
	customerkey,
	orderdate,
	total_net_revenue,
	num_orders,
	countryfull,
	age,
	concat(TRIM(BOTH FROM givenname), ' ', TRIM(BOTH FROM surname)) AS clean_name,
	min(orderdate) OVER (
		PARTITION BY customerkey
	) AS first_purchase_date,
	EXTRACT(YEAR FROM min(orderdate) OVER (PARTITION BY customerkey)) AS cohort_year
FROM
	customer_revenue cr;

-- Other ways of query optimisation include:
/*
- Data Types - Ensure numeric Vs. string-based filtering is efficient.
- Indexing - Speed-up queries with strategic indexes.
- Partitioning - Use partitions on large tables for improved performance.
