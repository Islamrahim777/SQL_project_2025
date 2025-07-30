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

```SQL

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
```

Here's the breakdown of the top data analyst jobs in 2023:

-**Wide Salary Range:** Top 10 paying data analyst roles span from $184,000 to 650,000 indicating significant salary potential in the field.

-**Diverse Employers:** Companies like SmartAsset, Meta, and AT&T are among those offering high salaries, showing a broad interest across different industries.

-**Job titles Variety:** THere's a high diversity in job titles, from Data Analyst to Director of Analytics, reflecting varied roles and specializations with data analytics.

![Top Paying Roles](/image/)
*The bargraf vizualizing the salary for the top 10 salaries for data analysts; ChatGPT generated this graph from my SQL query results*

### 2. Skills fro Top Paying Jobs
To understand what skills are required for the top-paying jobs, I joined the job postings with the skills data, providing insights into what employers value for high-compensation roles.

```sql
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

Here's the breakdown of the most demanded skills for the top 10 highest paying data analyst jobs in 2023:

-**SQL** is leading with bold count of 8
-**Python** follows closely with a bold count of 7.
-**Tableau** is also highly sought after, with a bold count of 6. Other skills like **R**, **Snowflake**, **Pandas**, and **Excel** show varying degrees of demand.

![Skill Count for Top 10 Paying Data Analyst Jobs in 2023](/photo/)

*Bar graph visualizing the count off skills for the top 10 paying jobs for data analysts; ChatGPT generated this graph from my SQL query results*

### 3. In-Demand skills for Data Analysts

   This query helped identify the skills most frequently requested in job postings, directing focus to areas with high demand.

   
```sql
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
    5;
```
Here's the breakdown of the most demanded skills for data analysts in 2023

SQL and Excel remain fundamental, emphasizing the need for strong foundational skills in data processing and spreadsheet manipulation.
Programming and Visualization Tools like Python, Tableau, and Power BI are essential, pointing towards the increasing importance of technical skills in data storytelling and decision support.

Skills	Demand Count
SQL	        7291
Excel	    4611
Python	    4330
Tableau  	3745
Power BI	2609

Table of the demand for the top 5 skills in data analyst job postings

### 4. Skills Based on Salary

Exploring the average salaries associated with different skills revealed which skills are the highest paying.

```sql
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

Here's a breakdown of the results for top paying skills for Data Analysts:

High Demand for Big Data & ML Skills: Top salaries are commanded by analysts skilled in big data technologies (PySpark, Couchbase), machine learning tools (DataRobot, Jupyter), and Python libraries (Pandas, NumPy), reflecting the industry's high valuation of data processing and predictive modeling capabilities.
Software Development & Deployment Proficiency: Knowledge in development and deployment tools (GitLab, Kubernetes, Airflow) indicates a lucrative crossover between data analysis and engineering, with a premium on skills that facilitate automation and efficient data pipeline management.
Cloud Computing Expertise: Familiarity with cloud and data engineering tools (Elasticsearch, Databricks, GCP) underscores the growing importance of cloud-based analytics environments, suggesting that cloud proficiency significantly boosts earning potential in data analytics.

Skills	    Average Salary ($)
pyspark	        208,172
bitbucket	    189,155
couchbase	    160,515
watson	        160,515
datarobot    	155,486
gitlab	        154,500
swift	        153,750
jupyter	        152,777
pandas       	151,821
elasticsearch	145,000

Table of the average salary for the top 10 paying skills for data analysts


### 5 Most Optimal Skills to Learn

Combining insights from demand and salary data, this query aimed to pinpoint skills that are both in high demand and have high salaries, offering a strategic focus for skill development.
```sql

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
Skill ID	   Skills   	Demand Count	   Average Salary ($)
8	           go	        27	               115,320
234	           confluence	11	               114,210
97	           hadoop	    22	               113,193
80	           snowflake	37	               112,948
74	           azure	    34	               111,225
77	           bigquery	    13	               109,654
76	           aws	        32	               108,317
4	           java     	17	               106,906
194	           ssis	        12	               106,683
233	           jira	        20	               104,918



*Table of the most optimal skills for data analyst sorted by salary*

Here's a breakdown of the most optimal skills for Data Analysts in 2023:

**- High-Demand Programming Languages:** Python and R stand out for their high demand, with demand counts of 236 and 148 respectively. Despite their high demand, their average salaries are around $101,397 for Python and $100,499 for R, indicating that proficiency in these language ** Skills in specialized technologies such as Snowflake, Azure, AWS, and BigQuery show significant demand with relatively high average salaries, pointing towards the growing importance of cloud platforms and big data technologies in data analysis.
**- Business Intelligence and Visualization Tools:** Tableau and Looker, with demand counts of 230 and 49 respectively, and average salaries around $99,288 and $103,795, highlight the critical role of data visualization and business intelligence in deriving actionable insights from data.
**Database Technologies:** The demand for skills in traditional and NoSQL databases (Oracle, SQL Server, NoSQL) with average salaries ranging from $97,786 to $104,534, reflects the enduring need for data storage, retrieval, and management expertise.

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


