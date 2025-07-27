/*
 Question: What are the top-paying DAta Analyst jobs?
 -Identify the top 10 highest-paying Data Analyst roles that are available remotely.
 -Focuses on job postings with specified salaries (remove nulls).
 -Why? Highlight the top-paying opportunities for Data Analyst, offering insights into employment opportunity
 
 */

with top_paying_jobs as (

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




