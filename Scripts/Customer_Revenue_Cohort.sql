WITH yearly_cohort AS (
    SELECT DISTINCT
        customerkey,
        EXTRACT(YEAR FROM MIN(orderdate) OVER (PARTITION BY customerkey)) AS cohort_year
    FROM sales
)
SELECT 
    y.cohort_year,
    EXTRACT(YEAR FROM s.orderdate) AS purchase_year,
    SUM(s.quantity * s.netprice * s.exchangerate) AS net_revenue
FROM sales s
LEFT JOIN yearly_cohort y ON s.customerkey = y.customerkey
GROUP BY 
    y.cohort_year,
    purchase_year
ORDER BY 
    y.cohort_year, 
    purchase_year
LIMIT 10;


WITH yearly_cohort AS (
    SELECT DISTINCT
        customerkey,
        EXTRACT(YEAR FROM MIN(orderdate) OVER (PARTITION BY customerkey)) AS cohort_year,
        EXTRACT(YEAR FROM orderdate) AS purchase_year  --moved
    FROM sales
)
SELECT DISTINCT  -- added
    cohort_year,
    purchase_year, --added
    COUNT(*) OVER (PARTITION BY purchase_year, cohort_year) as num_customers  --added
FROM yearly_cohort
ORDER BY 
    purchase_year,
    cohort_year
LIMIT 10;


SELECT
    cohort_year,
    SUM(total_net_revenue) AS total_revenue,
    COUNT(DISTINCT customerkey) AS total_customers,
    SUM(total_net_revenue) / COUNT(DISTINCT customerkey) AS customer_revenue
FROM cohort_analysis
GROUP BY 
    cohort_year;


WITH purchase_days AS (
    SELECT
        customerkey,
        total_net_revenue,
        orderdate - MIN(orderdate) OVER (PARTITION BY customerkey) AS days_since_first_purchase
    FROM cohort_analysis
)

SELECT
    days_since_first_purchase,
    SUM(total_net_revenue) as total_revenue,
    SUM(total_net_revenue) / (SELECT SUM(total_net_revenue) FROM cohort_analysis) * 100 as percentage_of_total_revenue,
    SUM(SUM(total_net_revenue) / (SELECT SUM(total_net_revenue) FROM cohort_analysis) * 100) OVER (ORDER BY days_since_first_purchase) as cumulative_percentage_of_total_revenue
FROM purchase_days
GROUP BY days_since_first_purchase
ORDER BY days_since_first_purchase
LIMIT 10;


SELECT
    cohort_year,
    SUM(total_net_revenue) AS total_revenue,
    COUNT(DISTINCT customerkey) AS total_customers,
    SUM(total_net_revenue) / COUNT(DISTINCT customerkey) AS customer_revenue
FROM cohort_analysis
WHERE orderdate = first_purchase_date
GROUP BY 
    cohort_year