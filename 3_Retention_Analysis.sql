-- RETENTION ANALYSIS -

-- Business Terms -
/*
- Active Customer - Made a purchase within the last 6 months.
- Churned Customer - Hasn't made a purchase in over 6 months.
*/

-- Why this matters? - Helps track customer retention and engagement
/*
- Identifies at-risk customers before they fully churn.
- Enables targeted rengagement campaigns. 
- Measures effectiveness of retention strategies. 
- Provides useful insights into customer lifecycle. 
*/

-- Churn Period -
/*
- E-commerce - 6 - 12 months since last purchase (Average).
- SaaS & Subscription Services - 30 - 90 days since last login/payment. 
- Mobile Apps - 7 - 30 days since last session. 
- B2B Business - 6 - 12 months since last transaction. 
*/

/*
1. Use ROW_NUMBER & PARTITION to find each customer's most recent orderdate.
2. Place code into a CTE, SELECT relevant columns and use WHERE to only show "1" in rn (row number) column. This will show only the most recent purchase for each customer.
3. Clasify customers into ACTIVE or CHURNED, find the latest order date of the dataset through orderdate and sorting by ascending.
- Use CASE WHEN to clasify 6 months from latest orderdate.
4. Problem - customers that have a first_purchase_date of less than 6 months will skew the data as having more "Active" customers. 
- Modify WHERE to include first_purchase_date only 6 months before the latest possible orderdate.
5. Place code into CTE, "churned_customers".
6. Use customer_status and COUNT(customerkey) to show number of each customers that are ACTIVE or CHURNED.
7. Use SUM and COUNT to display total customers combined. Need both as one aggregation for the GROUP BY, one aggrgation for the Window Function.
8. Calculate the percetage by dividing num_customers by total_customers, use ROUND function to round to 2 d.p.
9. Calculating Active Vs. Churned rate for cohort years. Add cohort_year to both CTEs and latest SELECT.
- Query now gives cohort year, but status_percentage divides by total_customers (lowering overall percentage).
- For each cohort year, the status_percentage should = 100%, not a percentage of total_customers.
10. Add-in a PARTITION BY cohort_year in the total_customers & status_percentage code.
 */

WITH customer_last_purchase AS (
	SELECT 
		customerkey,
		clean_name,
		orderdate,
		row_number() OVER (PARTITION BY customerkey ORDER BY orderdate DESC) AS rn,
		first_purchase_date,
		cohort_year
	FROM
		cohort_analysis ca 
), churned_customers AS (
	SELECT
		customerkey,
		clean_name,
		first_purchase_date,
		orderdate AS last_purchase_date,
		CASE
			WHEN orderdate < (SELECT MAX(orderdate) FROM sales) - INTERVAL '6 months' THEN 'Churned'
			ELSE 'Active'
		END AS customer_status,
		cohort_year 
	FROM
		customer_last_purchase 
	WHERE rn = 1
		AND first_purchase_date < (SELECT MAX(orderdate) FROM sales) - INTERVAL '6 months'
)
SELECT 
	cohort_year,
	customer_status,
	COUNT(customerkey) AS num_customers,
	SUM(COUNT(customerkey)) OVER(PARTITION BY cohort_year) AS total_customers,
	ROUND(COUNT(customerkey) / SUM(COUNT(customerkey)) OVER(PARTITION BY cohort_year), 2) AS status_percentage
FROM 
	churned_customers 
GROUP BY 
	cohort_year,
	customer_status