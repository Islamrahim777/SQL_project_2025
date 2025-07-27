/*
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
