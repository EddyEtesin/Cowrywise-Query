#MySQL Database Assessment Questions
#Data Retrieval Questions

# 1. Retrieve all plans with a goal amount greater than 1,000,000 Naira that are currently active (status_id = 1).
SELECT * FROM adashi_staging.plans_plan
where  goal > 1000000 and status_id = 1;

# 2. Find all plans created in 2023 that have an interest rate higher than 10%.
SELECT * FROM adashi_staging.plans_plan
where year(created_on) = 2023 and interest_rate > 0.1;

# 3. List all plans that are marked as "emergency plans"  along with their owners' IDs.
SELECT name,id, is_emergency_plan  FROM adashi_staging.plans_plan 
where is_emergency_plan  = 1;

# 4. Retrieve the names and creation dates of all plans that are part of a group .
SELECT name,created_on, plan_group_id  FROM adashi_staging.plans_plan 
where plan_group_id is not null;

# 5. Find all dollar stash plans  that were created in the last 6 months.
SELECT * FROM adashi_staging.plans_plan
where created_on between Date_format(Date_Sub(Curdate(), Interval 6 Month), '%Y-%m-01') and
Last_Day(Date_Sub(Curdate(), Interval 6 Month))
and currency_is_dollars = 1;

# 6. List all plans with a frequency_id of 6  that have been charged at least once.
SELECT * FROM adashi_staging.plans_plan
where frequency_id = 6 and last_charge_date is not null ;

# 7. Retrieve all mutual fund plans  that have a purchased_fund_id.
SELECT * FROM adashi_staging.plans_plan
where is_a_fund = 1 and purchased_fund_id is not null;

# 8. Find all plans that are locked  and have a withdrawal date in the future.
SELECT * FROM adashi_staging.plans_plan
where locked = 1 and withdrawal_date > curdate();

# 9. List all plans with a "donation" in their name or description, including their donation links if available.
SELECT name, description, donation_link FROM adashi_staging.plans_plan
where name like '%donation%' or description like '%donation%';

# 10. Retrieve all plans that are both a personal challenge and have a goal amount set
SELECT * FROM adashi_staging.plans_plan
where is_personal_challenge = 1 and is_a_goal = 1;

#Aggregation Questions
# 11. Calculate the total amount saved across all active regular savings plans (plan_type_id = 1).
SELECT sum(amount) as Total_Amount_Saved FROM adashi_staging.plans_plan
where plan_type_id = 1 and status_id = 1;

# 12. Find the average interest rate for all fixed investment plans (is_fixed_investment = 1).
SELECT avg(interest_rate) * 100 as Average_Interest_Rate FROM adashi_staging.plans_plan
where is_fixed_investment = 1;

# 13. Count how many plans were created each month in 2023, grouped by month.
SELECT month(created_on) as Month_Created, count(*) as Number_of_Plans_created FROM adashi_staging.plans_plan
where Year(created_on) = 2023
group by month(created_on) 
order by Number_of_Plans_created;

# 14. Calculate the total cowry_amount for all plans that are part of groups.
SELECT plan_group_id, sum(cowry_amount) as Total_Cowry_Amount FROM adashi_staging.plans_plan
group by plan_group_id;

# 15. Find the maximum goal amount set across all emergency funds.
SELECT max(goal) as Maximum_Goal FROM adashi_staging.plans_plan
where is_emergency_plan = 1;

# 16. Calculate the average amount saved in dollar stash plans  vs regular stash plans.
SELECT case when currency_is_dollars = 1 then 'Dollar Stash' else 'Regular Stash'
end as stash_Type, count(*) as No_of_plans, avg(amount) as Average_amount, sum(amount) as Total_amount
FROM adashi_staging.plans_plan
group by currency_is_dollars;

# 17. Count how many plans are set up with each frequency type .
SELECT frequency_id, count(*) as Number_of_plans  FROM adashi_staging.plans_plan
group by frequency_id;

# 18. Find the total amount saved in all managed portfolios.
SELECT sum(amount) as Total_Amount_saved FROM adashi_staging.plans_plan
where is_managed_portfolio = 1;

# 19. Calculate the percentage of plans that are archived  out of all plans.
SELECT count(*) as Total_plans, sum(case when is_archived = 1 then 1 else 0 end) as Archived_plan,  (sum(case when is_archived = 1 then 1 else 0 end )/ count(*) * 100) as Percent_Archived
FROM adashi_staging.plans_plan; 

# 20. Find the most common plan name (the name that appears most frequently across all plans).
SELECT name, count(*) as plan_count  FROM adashi_staging.plans_plan 
group by name
order by plan_count desc
limit 1 ;

# 21. List each user's email and their corresponding tier name.
SELECT first_name, last_name, tier_id FROM adashi_staging.users_customuser;

# 22. Find all ambassadors and display their name, email, and the name of their tier.
SELECT first_name, last_name, tier_id FROM adashi_staging.users_customuser
where is_ambassador = 1;

#Questions on Joins 

# 23. List all savings plans with their owner's email and name
SELECT p.name, p.amount, u.email, u.first_name, u.last_name FROM adashi_staging.plans_plan p
join adashi_staging.users_customuser u on p.owner_id = u.id;

# 24. Show all plans  and their total savings amounts.
SELECT p.name, coalesce(sum(s.amount), 0) as Total_saved
FROM adashi_staging.plans_plan p
left join adashi_staging.savings_savingsaccount s on p.id = s.plan_id
group by  p.name;

# 25. Find withdrawals with user details and plan names.
SELECT w.amount,u.first_name,u.last_name, u.email, p.name as Plan_name
FROM adashi_staging.withdrawals_withdrawal w
join adashi_staging.users_customuser u on w.owner_id = u.id
join adashi_staging.plans_plan p on w.plan_id = p.id;

# 26. Identify users who have both savings and withdrawals.
SELECT distinct u.email
FROM adashi_staging.users_customuser u
join adashi_staging.savings_savingsaccount s on u.id = s.owner_id
join adashi_staging.withdrawals_withdrawal w on u.id = w.owner_id;

# 27. List emergency plans with their owners' phone numbers.
SELECT u.first_name,u.last_name, p.name as Plan_Name, u.phone_number
FROM plans_plan p
join users_customuser u on p.owner_id = u.id
where p.is_emergency_plan = 1;

# 28. Calculate the average withdrawal amount per user tier.
SELECT u.tier_id, AVG(w.amount) as avg_withdrawal
FROM adashi_staging.withdrawals_withdrawal w
join users_customuser u on w.owner_id = u.id
group by u.tier_id;

# 29. Find plans with no savings transactions.
SELECT p.*
from adashi_staging.plans_plan p
left join adashi_staging.savings_savingsaccount s on p.id = s.plan_id
where s.id is null;

# 30. Show savings transactions in January 2023 with plan details.
SELECT s.transaction_date, p.name, s.amount FROM adashi_staging.savings_savingsaccount s
join adashi_staging.plans_plan p ON s.plan_id = p.id
where s.transaction_date between '2023-01-01' and '2023-01-31';

# 31. List donations  with donor emails and plan names.
SELECT p.name, u.email as  donor_email, s.amount FROM adashi_staging.plans_plan p
join adashi_staging.savings_savingsaccount s on p.id = s.plan_id
join adashi_staging.users_customuser u ON s.donor_id = u.id
where p.is_donation_plan = 1;

# 32. Rank users by total savings (highest first).
SELECT u.first_name,u.last_name ,u.email, sum(s.amount) as total_savings
FROM adashi_staging.users_customuser u
join adashi_staging.savings_savingsaccount s on u.id = s.owner_id
group by u.email
order by total_savings desc;

#Subqueries
# 33. Find users who haven’t created any plans.
SELECT email FROM adashi_staging.users_customuser
where id not in (select owner_id from plans_plan);

# 34. List plans with above-average amounts.
SELECT name, amount FROM adashi_staging.plans_plan
where amount > (select avg(amount) from plans_plan);

# 35. Calculate the percentage of each user's savings relative to their total.
SELECT u.email, s.amount / (Select sum(amount) from savings_savingsaccount where owner_id = u.id) * 100 as percentage
FROM adashi_staging.users_customuser u
join savings_savingsaccount s on u.id = s.owner_id;

# 36. List plans that have never been withdrawn from.
SELECT name FROM adashi_staging.plans_plan
where id not in (select plan_id from withdrawals_withdrawal);

# 37. Increase the goal amount by 10% for all emergency plans.
Update plans_plan
Set goal = goal * 1.1
Where is_emergency_plan = 1;

# 38. Remove savings transactions older than 5 years.
Delete from  adashi_staging.savings_savingsaccount
where transaction_date < Date_sub(Now(), Interval 5 Year);

# 39. Archive inactive plans to a backup table.
Insert Into plans_archive
Select * from adashi_staging.plans_plan
where status_id = 2;

# 40. Categorize users based on savings:
Update users_customuser u
set account_campaign = case
  When (Select SUM(amount) From adashi_staging.savings_savingsaccount Where owner_id = u.id) > 1000000 Then 'High Saver'
  Else 'Standard Saver'
End;

# 41. Identify and update orphaned withdrawals (no matching user).
WITH orphaned_withdrawals AS (
  SELECT w.id
  FROM adashi_staging.withdrawals_withdrawal w
  Left join users_customuser u On w.owner_id = u.id
  Where u.id is null
)
Update withdrawals_withdrawal
Set owner_id = '[default_user_id]'
Where id in (Select id From orphaned_withdrawals);

