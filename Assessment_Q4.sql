-- Q4: Customer Lifetime Value (CLV) Estimation
-- Estimate CLV based on tenure and transaction profit

WITH txn_summary AS (
    SELECT
        owner_id,
        SUM(confirmed_amount) AS total_txn,
        COUNT(*) AS txn_count
    FROM savings_savingsaccount
    GROUP BY owner_id
),
tenure_data AS (
    SELECT
        id AS customer_id,
        name,
        DATE_PART('month', AGE(CURRENT_DATE, date_joined)) AS tenure_months
    FROM users_customuser
),
clv_calc AS (
    SELECT
        t.customer_id,
        t.name,
        td.tenure_months,
        ts.txn_count AS total_transactions,
        ROUND((ts.total_txn * 0.001 / ts.txn_count), 2) AS avg_profit_per_transaction,
        ROUND((ts.txn_count / NULLIF(td.tenure_months, 0)) * 12 * (ts.total_txn * 0.001 / ts.txn_count), 2) AS estimated_clv
    FROM tenure_data td
    JOIN txn_summary ts ON td.customer_id = ts.owner_id
    JOIN users_customuser t ON t.id = td.customer_id
)
SELECT *
FROM clv_calc
ORDER BY estimated_clv DESC;
