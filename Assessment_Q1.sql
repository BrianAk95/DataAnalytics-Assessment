-- Q1: High-Value Customers with Multiple Products
-- Find customers with at least one funded savings plan AND one funded investment plan, sorted by total deposits

SELECT
    uc.id AS owner_id,
    uc.name,
    COUNT(DISTINCT ss.id) AS savings_count,
    COUNT(DISTINCT pp.id) AS investment_count,
    ROUND(SUM((ss.confirmed_amount + pp.amount) / 100.0), 2) AS total_deposits
    -- calculating the total amount of deposits made by each customer across both savings and investment plans
FROM users_customuser uc
LEFT JOIN savings_savingsaccount ss
    ON uc.id = ss.owner_id     
LEFT JOIN plans_plan pp
    ON uc.id = pp.owner_id   
WHERE ss.confirmed_amount > 0
AND ss.is_regular_savings = 1
AND pp.confirmed_amount > 0 
AND pp.is_a_fund = 1
GROUP BY uc.id, uc.name
HAVING COUNT(DISTINCT ss.id) >= 1 AND COUNT(DISTINCT pp.id) >= 1
ORDER BY total_deposits DESC;