SELECT * FROM adashi_staging.savings_savingsaccount;

# 1. High-Value User Identification
SELECT id, email, monthly_salary, 
       Case when monthly_salary > 500000 then 'Premium' else 'Standard' end as segment
FROM adashi_staging.users_customuser
where is_active = 1;

# 2. Ambassador Performance Tracking
SELECT id, first_name, last_name, tier_id FROM adashi_staging.users_customuser
Where is_ambassador = 1
Order by date_joined desc;

# 3. User Growth by Tier
SELECT tier_id, Count(*) as user_count, year(date_joined) as join_year FROM adashi_staging.users_customuser
Group By tier_id, join_year
order by join_year;

# 4. Dormant User Reactivation
SELECT id, email, last_login FROM adashi_staging.users_customuser
Where last_login < Date_Sub(Now(), Interval 6 Month);

# 5. Geographic Distribution
SELECT address_country, address_state, Count(*) as users FROM adashi_staging.users_customuser
Group By address_country, address_state
order by address_country, address_state;

# 6. Risk Appetite Analysis
SELECT risk_apetite, avg(monthly_salary) as avg_salary From adashi_staging.users_customuser
Group By risk_apetite;

# 7. Device Preference
SELECT signup_device, COUNT(*) as signups FROM adashi_staging.users_customuser
Group By signup_device
order by signup_device;

# 8. Fraud Risk Flagging
SELECT id, email, fraud_score FROM adashi_staging.users_customuser
Where fraud_score > 70;

# 9. Salary vs. Savings Correlation
SELECT u.id, u.monthly_salary, Sum(s.amount) as total_savings From adashi_staging.users_customuser u
Join savings_savingsaccount s ON u.id = s.owner_id
Group By u.id;

# 10. Account Deletion Trends
SELECT Year(proposed_deletion_date) as year, Count(*) as deletions FROM adashi_staging.users_customuser
Where is_account_deleted = 1
Group By year;

