# DataAnalytics-Assessment
Cowrywise assessment
### Assessment_Q1.sql — High-Value Customers with Multiple Products

**Objective**: Identify users who have both a funded savings plan and a funded investment plan.

**Approach**:
- Used two Common Table Expressions (CTEs): one for savings, one for investment.
- Aggregated by `owner_id` to count the distinct IDs and sum confirmed amounts.
- Joined with the `users_customuser` table for names.
- Filtered out users who don’t have both.
- Converted kobo to naira and rounded to 2 decimal places.

### Assessment_Q2.sql — Transaction Frequency Analysis

**Objective**: Categorize customers by transaction frequency per month

**Approach**:
- Used 3 Common Table Expressions (CTEs): 
- `txn_monthly` to calculate customers' transaction frequency per month
- `customer_freq` to calculate customers' average transactions frequency per month using the table txn_monthly
- `freq_category` to categorize customers by average transaction frequency per month using the table customer_freq
- And the final query to output the expect resolve


### Assessment_Q3.sql — Account Inactivity Alert

**Objective**: Identify accounts with no inflow in the last 365 days

**Approach**:
- Used 3 Common Table Expressions (CTEs): 
- `last_savings` to create the scenario last transaction with respect to savings plan
- `last_investment` to create the scenario last transaction with respect to investment plan
- Then both created CTEs unified using UNION ALL so as to bring both transaction types into a table `savings_investment`
- And the final query to output the expect resolve


### Assessment_Q4.sql — Customer Lifetime Value (CLV) Estimation

**Objective**: Estimate CLV based on tenure and transaction profit

**Approach**:
- Used 3 Common Table Expressions (CTEs): 
- `txn_stats` to calculate the lifetime value and volume of transaction per customer
- `tenure_data` to calculate difference in month since become a customer till current date
- `clv_calc`; using both previous tables to estimate customers' lifetime value.
- And the final query for the output; querying all for all the field in the `clv_calc` ordering by estimated_clv.


**Using CTEs for readability**

### Challenges

- Faced MySQL Error 2013 (Lost connection): Solved it by increasing `net_read_timeout` and `net_write_timeout`.


### Final Thoughts

This assessment was really good to test one reasoning capacity and ability to see hiding detailss. It also reinforced the importance of query performance and data validation.
