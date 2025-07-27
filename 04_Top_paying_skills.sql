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