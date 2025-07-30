# Introduction
Dive into the data job market! Focusing on data analyst roles, this project explores top-paying jobs, in-demand skills, and where high demand meets hig salary in data analytics.

SQL queries? Check them out here: [SQL_PROJECT_2025 folder](/SQL_PROJECT_2025/)
# Background

Diving by a quest to navigate the data analyst job market more effectively, this project was born from a desire to point top-paid and in-demand skills, streamlining others work to find optimal jobs.

### The questions I wanted to answer through my SQL queries were:
1. What are the top-paying data analyst jobs?
2. What skillsnare required for these top-paying jobs?
3. What skills are most in demand for data analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?

# Tools I used
For my deep dive into the data analyst job market, I harness the power of several key tools:

**-SQL:** The backbone of my analysis, allowingme to query the database and unearth critical insights.
**-PostgreSQL:** THe chosen database managment system, ideal for handling the job posting data.
**-Visual Studio Code:** My go-to for database managment and executing SQL queries.
**-Git & GitHub:** Essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking

# The Analysis
EAch query for this project aimed at investigating specific aspects of the data analyst job market. Here's how I approached each question:

### 1. Top paying Data Analyst Jobs 
To identify the highest-paying roles, I filtered data analyst positions by average yearly salary and location, focusing on remote jobs. This query highlights the high paying opportunities in the field.


with top_paying_jobs as (
```SQL
select
    job_id,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name as comany_names
from
    job_postings_fact
    left join company_dim on job_postings_fact.company_id = company_dim.company_id
where
    job_title = 'Data Analyst'
    and job_location = 'Anywhere'
    and salary_year_avg is not null
order by
    salary_year_avg desc
limit
    10)


select top_paying_jobs.*,
skills
from top_paying_jobs
left  join skills_job_dim on top_paying_jobs.job_id = skills_job_dim.job_id
left join skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
order by salary_year_avg desc 
```

Here's the breakdown of the top data analyst jobs in 2023
-**Wide Salary Range:** Top 10 paying data analyst roles span from $184,000 to 650,000 indicating significant salary potential in the field.
-**Diverse Employers:** Companies like SmartAsset, Meta, and AT&T are among those offering high salaries, showing a broad interest across different industries.
-**Job titles Variety:** THere's a high diversity in job titles, from Data Analyst to Director of Analytics, reflecting varied roles and specializations with data analytics


```sql
 Question: What skills are required for the top-paying Data Analyst jobs?
 -Use the top 10 highest-paying Data Analyst jobs from first query
 -add the specific skills required for these roles
 - Why? It provides a detailed look at which high-paying jobs demand certain skills, helping job seekers understand which skills to develop that align with top salaries
 */
SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date
from
    job_postings_fact
where
    job_id in (
        select
            job_id
        from
            job_postings_fact
        where
            job_title = 'Data Analyst'
            and job_location = 'Anywhere'
            and salary_year_avg is not null
    )
order by
    salary_year_avg desc
limit
    10
```

3 
```sql
 Question: What are the most in-demand skills for data analysts?
 -Join to job ostings to inner join table similar to query 2
 -Identify the Top 5 in-demand skills for a data analyst.
 -Focus on all job postings.
 -Why? Retrives the top 5 skills with the highest demand in job market,
 providing insights into the most valuable skills for job seekers.
 */
SELECT
    skills,
    count(skills_job_dim.job_id) as demand_count
from
    job_postings_fact
    inner join skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
    inner join skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
where
    job_title_short = 'Data Analyst'
    and job_work_from_home = True
group by
    skills
order by
    demand_count desc
limit
    5
```
4 
```sql
/*
 What are the top skills bassed on the salary?
 -look at the average salary associated with each skill for Data Analyst positions
 -Focuses on roles with specified salaries, regardless of location
 -Why? It reveals how different skills impact salary levels for Data Analyst and 
 helps identify the most financially rewarding skills to acquire or improve
 
 */
SELECT
    skills,
    round(avg(salary_year_avg), 0) as average_salary
from
    job_postings_fact
    inner join skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
    inner join skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
where
    job_title_short = 'Data Analyst'
    and salary_year_avg is not null
group by
    skills
order by
    average_salary DESC
limit
    25
```

5

/* 
     - SQL query to find the top 25 in-demand skills for Data Analysts that work from home
     - the query calculates the demand count and average salary for each skill
     - it filters for skills that have a demand count greater than 10
     - the results are ordered by demand count and average salary
     - the query limits the resukts to top 25 skills
     - the query uses Common Table Expressions (CTEs) for better readablity
     */
     -- CTEs are used to break down the query into smaller, manageable parts




with skills_demand as (
    SELECT
        skills_dim.skill_id,
        skills_dim.skills,
        count(skills_job_dim.job_id) as demand_count
    from
        job_postings_fact
        inner join skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
        inner join skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
    where
        job_title_short = 'Data Analyst'
        and salary_year_avg is not null
        and job_work_from_home = TRUE
    group by
        skills_dim.skill_id
),
average_salary as (
    SELECT
        skills_job_dim.skill_id,
        round(avg(salary_year_avg), 0) as average_salary
    from
        job_postings_fact
        inner join skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
    where
        job_title_short = 'Data Analyst'
        and salary_year_avg is not null
        and job_work_from_home = true
    group by
        skill_id
)
select
    skills_demand.skill_id,
    skills_demand.skills,
    skills_demand.demand_count,
    average_salary.average_salary
from
    skills_demand
    inner join average_salary on skills_demand.skill_id = average_salary.skill_id
where
    demand_count > 10
order by
    demand_count desc,
    average_salary desc
limit
    25






```sql

-- rewriting the query more simple without CTEs

SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    count(skills_job_dim.job_id) as demand_count,
    round(avg(job_postings_fact.salary_year_avg), 0) as avg_salary
from
    job_postings_fact
    inner join skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
    inner join skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
where
    job_title_short = 'Data Analyst'
    and salary_year_avg is not null
    and job_work_from_home = TRUE
group by
    skills_dim.skill_id
having
    count(skills_job_dim.job_id) > 10
order by
    avg_salary DESC,
    demand_count DESC
limit
    25
    ```

# What i learnd

Throughout this adventure, I've turbocharged my SQL toolkit with some serious firepower:

**-Coplex Query crafting:** Mastered the artbof advanced SQL, merging tables like a pro and wielding WITH clause for ninja-level temp table maneuvers.
**- Data Aggregation:** Got cozay with GROUP BY and turend aggregate functions like COUNT() and AVG() into my data summerating sidekicks.
**- Analitical Wizardry :** Leveled up my real-world puzzle-solving skills, turning questions into actionable, insightful SQL queries.

# Conclusion

### Insights
1. **Top-paying Data Analyst Jobs**:  The highest-paying jobs for data analysts that allow remote work offer a wide range of salaries, the highest at 650,000!
2. **Skills for Top-Paying jobs**: High-Paying data analyst jobs require advanced proficiency in SQL, suggestion it's a critical skill for earning a top salary.
3. **Most In-Demand Skills**: SQL is also most demanded skill in the data analyst job market, thus making it essential for job seekers.
4. **Skills with Higher Salaries**: Specialized skills, such as SVN and Solidity, are associated with the highest average salaries, indicating a premium one niche expertise.
5. **optimal Skills for job Market Value**: SQL leads in demand and offers for a high averae salary, positioning it as one of the most optimal skills for data analysts to learn to maximaze their market value.

### Closing thoughts

this project enhanced my SQL skills and provided valuable insights into the data analyst job market. the findings from the analyst serve as a guide to prioritizing skill development and job search efforts. Aspiring data analyst can better position themselves in a competeive job market by focusing on high-demand, high-salary skills. this  exploration highlights the importance of continuous learning and adaptation to emerging trends in the field of data analystics.


