-- Q4: Customer Lifetime Value (CLV) Estimation
-- Estimate CLV based on tenure and transaction profit

WITH txn_summary AS (
    SELECT
        owner_id,
        SUM(confirmed_amount) AS total_txn,
        COUNT(*) AS txn_count
    FROM savings_savingsaccount
    GROUP BY owner_id
), -- subquery to calculate the lifetime value and volume of transaction per customer
tenure_data AS (
    SELECT
        id AS customer_id,
        CONCAT(first_name, ' ', last_name) AS name,
		TIMESTAMPDIFF(MONTH, date_joined, CURRENT_DATE) AS tenure_months
    FROM users_customuser
), -- subquery to calculate difference in month since become a customer till current date
clv_calc AS (
    SELECT
        u.id as customer_id,
        CONCAT(u.first_name, ' ', u.last_name) as name,
        td.tenure_months,
        ts.txn_count AS total_transactions,
        ROUND(((ts.txn_count / NULLIF(td.tenure_months, 0)) * 12 * (ts.total_txn * 0.001 / ts.txn_count)), 2) AS estimated_clv
-- This expression estimates customer lifetime value based on:
-- Average monthly transaction activity - (ts.txn_count / NULLIF(td.tenure_months, 0))
-- Assumed profit margin (0.1%) - (ts.total_txn * 0.001 / ts.txn_count)
-- Projected over a year multiplyiing by 12
    FROM tenure_data td
    JOIN txn_summary ts ON td.customer_id = ts.owner_id
    JOIN users_customuser u ON u.id = td.customer_id
)
SELECT *
FROM clv_calc
ORDER BY estimated_clv DESC;

