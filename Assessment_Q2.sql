-- Q2: Transaction Frequency Analysis
-- Categorize customers by transaction frequency per month

WITH txn_monthly AS (
    SELECT
        owner_id,
        month(transaction_date) AS txn_month,
        COUNT(id) AS monthly_txn
    FROM savings_savingsaccount
    GROUP BY owner_id, month(transaction_date)
), -- subquery to calculate customers' transaction frequency per month
customer_freq AS (
    SELECT
        owner_id,
        AVG(monthly_txn) AS avg_txn_per_month
    FROM txn_monthly
    GROUP BY owner_id
), -- subquery to calculate customers' average transactions frequency per month using the table txn_monthly
freq_category AS (
    SELECT
        CASE
            WHEN avg_txn_per_month >= 10 THEN 'High Frequency'
            WHEN avg_txn_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category,
        owner_id,
        avg_txn_per_month
    FROM customer_freq
) -- subquery to categorize customers by average transaction frequency per month using the table customer_freq
SELECT
    frequency_category,
    COUNT(owner_id) AS customer_count,
    ROUND((AVG(avg_txn_per_month)), 1) AS avg_transactions_per_month
    -- average transaction per category
FROM freq_category
GROUP BY frequency_category;

