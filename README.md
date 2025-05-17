# MySQL Database Assessment: Adashi Staging Data

This repository contains a collection of SQL queries designed to assess proficiency in MySQL by retrieving, analyzing, and manipulating data from the `adashi_staging` database. The focus is on the `plans_plan`, `users_customuser`, `savings_savingsaccount`, and `withdrawals_withdrawal` tables.

## Structure

The questions are grouped into the following categories:

### Data Retrieval Queries
Perform basic filtering and selection of relevant records.
- Example: Retrieve all active plans with goal amounts over 1,000,000 Naira.
- Includes string matching, date filtering, null checks, and boolean flags.

### Aggregation Queries
Summarize and compute metrics using SQL aggregate functions.
- Example: Calculate the average interest rate for all fixed investment plans.
- Uses `SUM()`, `AVG()`, `MAX()`, `COUNT()`, `GROUP BY`, and `HAVING`.

### Join Queries
Demonstrate the ability to work across multiple related tables.
- Example: List all savings plans with their owners' emails and names.
- Uses `JOIN`, `LEFT JOIN`, and multiple-table relationships.

### Subqueries & Updates
Use subqueries for conditional filtering, and perform updates/deletes based on logic.
- Example: Find users who haven’t created any plans.
- Includes scalar subqueries, `IN`, `NOT IN`, and `UPDATE`/`DELETE` statements.

---

## Sample Tables Referenced
- `plans_plan`: Holds plan-level details such as goal, amount, interest rates, statuses.
- `users_customuser`: Contains user-specific information including tier, ambassador status, etc.
- `savings_savingsaccount`: Logs transactions related to savings against plans.
- `withdrawals_withdrawal`: Records withdrawal history tied to users and plans.

---

## Use Cases
- Internal database assessments
- SQL practice for intermediate/advanced users
- Interview test cases for database-related roles
- Audit and reporting tasks on financial savings platforms

---

## Important Notes
- Some queries use date functions like `CURDATE()`, `DATE_SUB()` which are MySQL-specific.
- Table prefixes like `adashi_staging` imply usage in a staging/test environment.
- Update and Delete queries should be executed with caution in a live environment.

---

/*
===========================================================
  MySQL Database Assessment: Adashi Staging Data
===========================================================

  📌 Author:
    Name: Ediomo Usoro Etesin
    Email: ediomoetesin40@gmail.com
    GitHub: https://github.com/Edyetesin
    LinkedIn: https://www.linkedin.com/in/ediomo-etesin

  📜 License:
    This SQL script is intended for educational and 
    assessment purposes only. Not for production use 
    without verification of data accuracy and integrity.
    All queries are based on the adashi_staging database 
    schema and are safe to use in test environments.

===========================================================
*/

## Example Highlight

```sql
-- Find plans with no savings transactions
SELECT p.*
FROM adashi_staging.plans_plan p
LEFT JOIN adashi_staging.savings_savingsaccount s ON p.id = s.plan_id
WHERE s.id IS NULL;


