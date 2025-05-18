-- Q3: Account Inactivity Alert
-- Identify accounts with no inflow in the last 365 days

WITH last_savings AS (
    SELECT
        p.id AS plan_id,
        s.owner_id,
        'Savings' AS type,
        MAX(s.transaction_date) AS last_transaction_date
    FROM savings_savingsaccount s
    left join plans_plan p on s.plan_id = p.id
    WHERE p.is_regular_savings =1 and s.confirmed_amount > 0
    GROUP BY p.id, s.owner_id
), -- subquery for last transaction with respect to savings plan
last_investments AS (
    SELECT
        p.id AS plan_id,
        s.owner_id,
        'Investment' AS type,
        MAX(s.transaction_date) AS last_transaction_date
    FROM savings_savingsaccount s
    left join plans_plan p on s.plan_id = p.id
    WHERE p.is_a_fund =1 and s.confirmed_amount > 0
    GROUP BY p.id, s.owner_id
), -- subquery for last transaction with respect to investment plan
savings_investment AS (
    SELECT * FROM last_savings
    UNION ALL
    SELECT * FROM last_investments
)
-- Both savings and investment scenario unified in a table distinct by type
SELECT
    plan_id,
    owner_id,
    type,
    last_transaction_date,
    TIMESTAMPDIFF(DAY, last_transaction_date, CURRENT_DATE) AS inactivity_days
FROM savings_investment
WHERE last_transaction_date <= CURRENT_DATE - INTERVAL 365 day; -- expected output
