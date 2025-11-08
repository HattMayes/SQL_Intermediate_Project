-- Customer Segmentation -
/*
1. Display key parts of table + calculate total LTV of customers.
2. Create CTE for customer_ltv.
3. Calculate Lower and Higher Percentiles. Percentiles are showing how much a customer spends when near that range.
4. Create CTE for Percentiles, customer_segments.
5. Use CASE WHEN to segment each customer based on their total_ltv.

-- Adding Statistics of Segmented Customers -
1. Create CTE, customer_segments.
2. Calculate the total_ltv as of each customer_segment, using SUM. - could be put into a pie chart to represent this.
3. Finding the average LTV for a customer within each segment, using COUNT and SUM.
- This is key info for showcasing what value of customer spends what, and then how you could reintroduce this customer using specific price ranges on items.
- e.g. Recommend a higher costing product to a high-value customer, and vice versa.
 */

WITH customer_ltv AS (	
	SELECT
		customerkey,
		clean_name,
		SUM(total_net_revenue) AS total_ltv
	FROM
		cohort_analysis
	GROUP BY
		customerkey,
		clean_name
), customer_segments AS (
SELECT 
	PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY total_ltv) AS ltv_25th_percentile,
	PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY total_ltv) AS ltv_75th_percentile
FROM 
	customer_ltv
), segment_value AS (
SELECT 
	c.*,
	CASE 
		WHEN c.total_ltv < cs.ltv_25th_percentile THEN '1 - Low-Value'
		WHEN c.total_ltv <= cs.ltv_75th_percentile THEN '2 - Mid-Value'
		ELSE '3 - High-Value'
	END	AS customer_segment
FROM 
	customer_ltv c,
	customer_segments cs
)
SELECT 
	customer_segment,
	SUM(total_ltv) AS total_ltv,
	COUNT(customerkey) AS customer_count,
	SUM (total_ltv) / COUNT(customerkey) AS avg_ltv
FROM 
	segment_value
GROUP BY
	customer_segment 
ORDER BY 
	customer_segment DESC