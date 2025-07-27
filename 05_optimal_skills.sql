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