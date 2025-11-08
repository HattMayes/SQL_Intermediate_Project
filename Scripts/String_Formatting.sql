-- STRING FORMATTING -

-- LOWER - Converts the string to all lowercase.
-- UPPER - Converts the string to all uppercase.

SELECT 
	LOWER('MATT HAYES');

SELECT 
	UPPER('matt hayes');

-- TRIM - Removes the longest string containing only characters, by default this is a space.
-- Useful for when cleaning data with lots of unusual space characters.
-- Can also specify LEADING or TRAILING or BOTH which trims either the front, back or both. BOTH is the default.

SELECT 
	TRIM(BOTH '@' FROM '@@Matt Hayes@@');

-- CONCAT - Concantenates the text representations of all arguments. NULL arguments are ignored.
-- Using this on my "cohort_analysis" View to combine customers' first and last names.

CREATE OR REPLACE VIEW public.cohort_analysis AS
WITH customer_revenue AS (
         SELECT s.customerkey,
            s.orderdate,
            sum(s.quantity::double precision * s.netprice * s.exchangerate) AS total_net_revenue,
            count(s.orderkey) AS num_orders,
            c.countryfull,
            c.age,
            c.givenname,
            c.surname
           FROM sales s
             LEFT JOIN customer c ON c.customerkey = s.customerkey
          GROUP BY s.customerkey, s.orderdate, c.countryfull, c.age, c.givenname, c.surname
        )
 SELECT customerkey,
    orderdate,
    total_net_revenue,
    num_orders,
    countryfull,
    age,
    concat(TRIM(givenname), ' ', TRIM(surname)) AS clean_name,
    min(orderdate) OVER (PARTITION BY customerkey) AS first_purchase_date,
    EXTRACT(year FROM min(orderdate) OVER (PARTITION BY customerkey)) AS cohort_year
   FROM customer_revenue cr;