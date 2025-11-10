# SQL Project 2 - Sales Analysis 

## Overview:
Analysis project using SQL for querying data on customer behvaiour, retention and lifetime value for an e-commerce company. Data is analysed and presented in a way that can help to improve customer retention rates and maximise revenue. This project improves on my SQL knowledge by using new querying techniques like creating Views, using conditional handles to remove NULL values, and proper string formatting alongside optimising my queries to make them run more efficiently. 

This project was completed using Luke Barousse's data on over 40,000 customers and a YouTube tutorial that can be found at this link: https://www.youtube.com/watch?v=QKIGsShyEsQ&t=6500s.

## Business Questions:
1. **Customer Segmentation:** Who are the most valuable customers?

2. **Cohort Analysis:** How do different customer groups generate revenue?

3. **Retention Analysis:** Which customers haven't made a recent purchase?

## Analysis Approach:

### 1. Customer Segmentation
- Categorised customers based on their Lifetime Value (LTV), which is how much revenue they have brought to the company since their first purchase.
- Each customer was assigned a segmented value, either Low, Mid or High-value based on where they sat in the range of average spending. 
- Calculated key metrics: total revenue and LTV.

**Query:** [1_Customer_Segmentation.sql](/1_Customer_Segmentation.sql)

**Visualisation:** Put Image Here [Customer Segmentation](<img width="1121" height="1168" alt="Image" src="https://github.com/user-attachments/assets/b2dd3585-2d41-4335-a99b-7432f3d6a76b" />)

**Key Findings:**
- Each customer segment was successful in showing how much total revenue is driven into the company by these customer types. Total company revenue = $206.3M.
- Low-value (25% of customers) accounted for 2% of revenue at $4.3M.
- Mid-value (50% of customers) accounted for 32% of revenue at $66.6M.
- High-value (25% of customers) accounted for 66% of revenue at $135.4M.

**Business Insights & Strategic Recommendations:**
- Low-value (2% revenue): Design campaigns that strive for re-engagement and offer promotions on price like BOGOF or free shipping to increase purchase quantity and frequency.
- Mid-value (32% revenue): Create upgrade paths that focus on items that are usually bought by the customer, but offer the same and similar complementary items that have a higher purchase price in order to raise revenue of this customer segment from Mid to High. 
- High-value (66% revenue): Offer rewards for being valued customers, like a premium membership program that helps retain all High-value customers' interest. Losing just one of these customers could signifcantly impact revenue, so the highest priority is keeping them active. 

### 2. Cohort Analysis
- Customers were grouped by the year of their first purchase.
- Tracked revenue and the customer count within each cohort.
- Analysed customer retention at a cohort level. 

**Query:** [2_cohort_analysis.sql](/2_cohort_analysis.sql)

**Visualisation:**
- Put Image here [Cohort Analysis](/Images/2_cohort_analysis.png)

**Key Findings:**
- Revenue per customer shows a decreasing trend over time.
- 2022 - 2024 cohorts are consistently performing worse than earlier cohorts.
- Net revenue is increasing, but this is likely due to a larger customer base overall, which is not reflective of individual customer value.

**Business Insights & Strategic Recommendations:**
- Value from customers is decreasing over time, this needs further investigation of why this is happening.
- 2023 saw a drop in the number of customers acquired, which is concerning.
- Lowering of both lifetime value (LTV) and decreasing customer acquisition will result in the company facing a potential decline in revenue.
- Implementing loyalty/subscription programs will help to stabilise revenue fluctuations. 
- Apply successful strategies from high-spending 2016-2018 cohorts to newer customers.

### 3. Retention Analysis

**Query:** [3_Retention_Analysis.sql](/3_Retention_Analysis.sql)

**Visualisation:** Put Image here [Retention Analysis]()

**Key Findings:**
- Cohort churn stabilises at ~90% after 2-3 years, this indicates a predictable long-term retention pattern that can be followed to create necessary campagins to target Active and Churned customers.
- Retention rates return as consistently low, ~8-10% or anywhere from 3,000 to 8,000+ people across all cohorts, which suggests retention issues are systematic and not specific to particular cohort years.
- Newer cohorts, in the years of 2022 and 2023 show similar churn rates, signaling that without intervention, future cohorts will follow the same pattern. 

**Business Insights & Strategic Recommendations:**
- Recommended to start customer engagement early, with strategies that target new customers within 1-2 years of their first purchase. This could include incentives like loyalty rewards and personalised offers to improve long-term retention.
- Specific targets on high-value customers that have churned. Use win-back campaigns rather than broad retention efforts, as reactivating high-value customers is likely to be easier and more effective on ROI, than just aiming for newer customers.
- Use the correct indicators of inactivity from customer data to predict when a customer is about to churn and intervene with at-risk users before they lapse.

## Project Technical Details:
- **Databases Used:** PostgreSQL
- **Analysis Tools:** PostgreSQL, DBeaver, pgAdmin, Visual Studio Code
- **Visualisations:** ChatGPT
