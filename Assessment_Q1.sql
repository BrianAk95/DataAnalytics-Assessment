-- Q1: High-Value Customers with Multiple Products
-- Find customers with at least one funded savings plan AND one funded investment plan, sorted by total deposits

with savings as (SELECT 
        s.owner_id,
            COUNT(distinct s.id) savings_count,
            SUM(s.confirmed_amount) Savings_deposit
    FROM
        savings_savingsaccount s
    LEFT JOIN plans_plan p ON s.plan_id = p.id
    WHERE
        p.is_regular_savings = 1 
    GROUP BY s.owner_id),
    -- subquery to aggregate for the savings plan 
    Investment as (SELECT 
        s.owner_id,
            COUNT(distinct s.id) investment_count,
            SUM(s.confirmed_amount) Investment_deposit
    FROM
        savings_savingsaccount s
    LEFT JOIN plans_plan p ON s.plan_id = p.id
    WHERE
        p.is_a_fund = 1 
    GROUP BY s.owner_id) 
    -- subquery to aggregate for the investment plan 
    SELECT 
    uc.id AS owner_id,
    CONCAT(uc.first_name, ' ', uc.last_name) AS name,
    s.savings_count,
    i.investment_count,
    ROUND(((s.savings_deposit + i.investment_deposit) / 100),
            2) AS total_deposits
    -- calculating the total deposits made by each customer across both savings and investment plans
    -- as hinted; all amount fields are in kobo, dividing it by 100 to convert to Naira
    -- 1 kobo = 100 Naira
FROM
    users_customuser uc left join savings s ON uc.id = s.owner_id
    left join investment i ON uc.id = i.owner_id
    where s.savings_count is not null 
    and i.investment_count is not null