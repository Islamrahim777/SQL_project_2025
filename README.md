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

# What i learnd

Throughout this adventure, I've turbocharged my SQL toolkit with some serious firepower:

- **Coplex Query crafting: **  Mastered the artbof advanced SQL, merging tables like a pro and wielding WITH clause for ninja-level temp table maneuvers.
- ** Data Aggregation:** Got cozay with GROUP BY and turend aggregate functions like COUNT() and AVG() into my data summerating sidekicks.
- ** Analitical Wizardry :**  Leveled up my real-world puzzle-solving skills, turning questions into actionable, insightful SQL queries.

# Conclusion
