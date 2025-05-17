-- Q3: Account Inactivity Alert
-- Identify accounts with no inflow in the last 365 days

WITH last_savings AS (
    SELECT
        id AS plan_id,
        owner_id,
        'Savings' AS type,
        MAX(created_at) AS last_transaction_date
    FROM savings_savingsaccount
    WHERE confirmed_amount > 0
    GROUP BY id, owner_id
),
last_investments AS (
    SELECT
        id AS plan_id,
        owner_id,
        'Investment' AS type,
        MAX(created_at) AS last_transaction_date
    FROM plans_plan
    WHERE confirmed_amount > 0
    GROUP BY id, owner_id
),
combined AS (
    SELECT * FROM last_savings
    UNION ALL
    SELECT * FROM last_investments
)
SELECT
    plan_id,
    owner_id,
    type,
    last_transaction_date,
    DATE_PART('day', CURRENT_DATE - last_transaction_date)::int AS inactivity_days
FROM combined
WHERE last_transaction_date <= CURRENT_DATE - INTERVAL '365 days';
