SELECT 
    s.customerkey,
    s.orderdate,
    SUM(s.quantity * s.netprice * s.exchangerate) AS total_net_revenue,
    COUNT(s.orderkey) AS num_orders
FROM sales s
GROUP BY 
    s.customerkey,
    s.orderdate;

SELECT
    s.customerkey,
    s.orderdate,
    SUM(s.quantity * s.netprice * s.exchangerate) AS total_net_revenue,
    COUNT(s.orderkey),
    c.countryfull,
    c.age,
    c.givenname,
    c.surname
FROM sales s 
LEFT JOIN customer c ON c.customerkey = s.customerkey
GROUP BY
    s.customerkey,
    s.orderdate,
    c.countryfull,
    c.age,
    c.givenname,
    c.surname;

CREATE OR REPLACE VIEW cohort_analysis AS  --create view as cohort_analysis
WITH customer_revenue AS (
	SELECT
		s.customerkey,
		s.orderdate,
		SUM(s.quantity * s.netprice * s.exchangerate) AS total_net_revenue,
		COUNT(s.orderkey) AS num_orders,
		c.countryfull,
		c.age,
		c.givenname,
		c.surname
	FROM sales s 
	LEFT JOIN customer c ON c.customerkey = s.customerkey
	GROUP BY
		s.customerkey,
		s.orderdate,
		c.countryfull,
		c.age,
		c.givenname,
		c.surname
)
SELECT
	cr.*,
	MIN(cr.orderdate) OVER (PARTITION BY cr.customerkey) AS first_purchase_date,
	EXTRACT(YEAR FROM MIN(cr.orderdate) OVER (PARTITION BY cr.customerkey)) AS cohort_year
FROM customer_revenue cr;


SELECT
    cohort_year,
    SUM(total_net_revenue) AS total_revenue
FROM cohort_analysis
GROUP BY 
    cohort_year
ORDER BY cohort_year;