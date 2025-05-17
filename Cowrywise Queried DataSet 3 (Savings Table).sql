SELECT * FROM adashi_staging.savings_savingsaccount;

# 1. Monthly Deposit Trends
SELECT Date_Format(transaction_date, '%Y-%m') as month,Sum(amount) as deposits FROM adashi_staging.savings_savingsaccount
Group By month;

# 2. Plan Adoption Rates
SELECT plan_id, Count(*) as tx_count FROM adashi_staging.savings_savingsaccount
Group By plan_id
Order By tx_count DESC;

# 3. Recurring vs. One-Time Deposits
SELECT Case When recurrence Is Not Null Then 'Recurring' Else 'One-Time' End as type, Count(*) as transactions
FROM adashi_staging.savings_savingsaccount
Group By type;

# 4. Donation Tracking
SELECT donor_id, Sum(amount) as total_donated FROM adashi_staging.savings_savingsaccount
Where donor_id Is Not Null
Group By donor_id;

# 4. Channel Effectiveness
SELECT channel_id, Sum(amount) as volume FROM adashi_staging.savings_savingsaccount
Group By channel_id;

# 5. Large Deposit Alerts
SELECT * FROM adashi_staging.savings_savingsaccount
Where amount > (Select avg(amount) * 5 FROM savings_savingsaccount);

# 6. Maturity Analysis
SELECT plan_id, Datediff(maturity_end_date, maturity_start_date) as days_active FROM adashi_staging.savings_savingsaccount
Where maturity_end_date Is Not Null
order by days_active desc;

# 7. Failed Charge Recovery
SELECT owner_id, transaction_reference FROM adashi_staging.savings_savingsaccount
Where transaction_status = 'failed' and verification_call_code = 'retry_eligible';

# 8. Interest Accrual
SELECT owner_id, Sum(book_returns) as total_interest FROM adashi_staging.savings_savingsaccount
Group By owner_id;

# 9. Cross-Plan Behavior
SELECT owner_id, Count(DISTINCT plan_id) as plan_count FROM adashi_staging.savings_savingsaccount
Group By owner_id
Having plan_count > 1;