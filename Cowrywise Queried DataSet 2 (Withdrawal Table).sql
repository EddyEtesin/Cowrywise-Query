SELECT * FROM adashi_staging.withdrawals_withdrawal;

# 1. Withdrawal Volume by Month
SELECT Date_Format(transaction_date, '%Y-%m') as month, Sum(amount) as total_withdrawn
FROM adashi_staging.withdrawals_withdrawal
Group By month;

# 2. Top Withdrawing Users
SELECT owner_id, Sum(amount) as total_withdrawn FROM adashi_staging.withdrawals_withdrawal
Group By owner_id
Order By total_withdrawn desc
Limit 20;

# 3. Withdrawal Frequency per User
SELECT owner_id, Count(*) AS tx_count FROM adashi_staging.withdrawals_withdrawal
Group By owner_id
Having tx_count > 5;

# 4. Bank-Specific Trends
SELECT bank_id, avg(amount) as avg_withdrawal FROM adashi_staging.withdrawals_withdrawal
Group By bank_id;

# 5. High-Risk Withdrawal Detection
SELECT * FROM withdrawals_withdrawal
Where amount > (Select avg(amount) * 3 From adashi_staging.withdrawals_withdrawal);

# 6. Weekday Liquidity Patterns
SELECT Dayname(transaction_date) as day, sum(amount) as total FROM adashi_staging.withdrawals_withdrawal
Group By day
order by total desc;

# 7. Gateway Performance
SELECT gateway, avg(amount) as avg_amount, Count(*) as tx_count FROM adashi_staging.withdrawals_withdrawal
Group By gateway;

# 8. Withdrawal vs. Savings Ratio
SELECT w.owner_id, Sum(w.amount) as withdrawn, (Select Sum(amount) From adashi_staging.savings_savingsaccount Where owner_id = w.owner_id) as saved
FROM adashi_staging.withdrawals_withdrawal w
Group By w.owner_id;


# 9. Session Abandonment
SELECT session_id, amount FROM adashi_staging.withdrawals_withdrawal
Where transaction_status_id = 1;


