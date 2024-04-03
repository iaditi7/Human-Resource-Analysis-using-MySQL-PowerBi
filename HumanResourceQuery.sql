CREATE DATABASE newhr;

use newhr;

select * from humanrsc;

alter table humanrsc change column ï»¿id emp_id varchar(20) NULL;

describe humanrsc;

select birthdate from humanrsc;

set sql_safe_updates = 0;

UPDATE humanrsc
SET birthdate = CASE
    WHEN birthdate LIKE '%/%' THEN DATE_FORMAT(STR_TO_DATE(birthdate, '%m/%d/%Y'), '%Y-%m-%d')
    WHEN birthdate LIKE '%-%' THEN DATE_FORMAT(STR_TO_DATE(birthdate, '%m-%d-%y'), '%Y-%m-%d')
    ELSE NULL
END;

alter table humanrsc
modify column birthdate date;

select birthdate from humanrsc;

UPDATE humanrsc
SET hire_date = CASE
    WHEN hire_date LIKE '%/%' THEN DATE_FORMAT(STR_TO_DATE(hire_date, '%m/%d/%Y'), '%Y-%m-%d')
    WHEN hire_date LIKE '%-%' THEN DATE_FORMAT(STR_TO_DATE(hire_date, '%m-%d-%y'), '%Y-%m-%d')
    ELSE NULL
END;

ALTER TABLE humanrsc
MODIFY COLUMN hire_date DATE;

select hire_date from humanrsc;

update humanrsc
set termdate = IF(termdate IS NOT NULL AND termdate != '',date(str_to_date(termdate,'%Y-%m-%d %H:%i:%s UTC')), '0000-00-00')
where true;

SET sql_mode = 'ALLOW_INVALID_DATES';

ALTER TABLE humanrsc
MODIFY COLUMN termdate DATE;

select termdate from humanrsc;

ALTER TABLE humanrsc ADD COLUMN age INT;

UPDATE humanrsc
SET age = timestampdiff(YEAR, birthdate, CURDATE());

SELECT 
	MIN(age) AS youngest,
    MAX(age) AS oldest 
FROM humanrsc;

SELECT COUNT(*) FROM humanrsc where age < 18;

-- Questions:

-- 1. What is the gender breakdown of employees in the company?
SELECT gender, COUNT(*) AS count 
FROM humanrsc
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY gender;

-- 2. What is the race/ethnicity breakdown of employees in the company?
SELECT race, COUNT(*) AS race_count
FROM humanrsc
WHERE age >= 18 AND termdate = '0000-00-00'
group by race
ORDER BY count(*) desc;

-- 3. What is the age distribution of employees in the company?
SELECT
	MIN(age) AS youngest,
    MAX(age) as oldest
FROM humanrsc
WHERE AGE>=18 AND termdate = '0000-00-00';

SELECT 
	CASE
		WHEN age >= 18 AND AGE <= 24 THEN '18-24'
        WHEN age > 24 AND AGE <= 34 THEN '25-34'
        WHEN age > 34 AND AGE <= 44 THEN '35-44'
        WHEN age > 44 AND AGE <= 54 THEN '45-54'
        WHEN age > 54 AND AGE <= 64 THEN '55-64'
        ELSE '65+'
	END AS age_group,
    count(*) AS count_age, gender
FROM humanrsc
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY age_group, gender
ORDER BY age_group, gender;


-- 4. How many employees work at headquarters versus remote locations?
SELECT location, count(*) AS work_mode FROM humanrsc
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY location ;

-- 5. What is the average length of employment for employees who have been terminated?
SELECT 
	ROUND(AVG(datediff(termdate, hire_date))/365, 0) AS avg_length_employment
FROM humanrsc
WHERE termdate <= curdate() AND termdate <> '0000-00-00' AND age >= 18;

-- 6. How does the gender distribution vary across departments and job titles?
SELECT department, gender, count(*) AS count_vary_dist
FROM humanrsc 
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY department, gender
ORDER BY department;

-- 7. What is the distribution of job titles across the company?
SELECT jobtitle, count(*) AS count_job 
FROM humanrsc 
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY jobtitle
ORDER BY jobtitle desc;

-- 8. Which department has the highest turnover rate?
SELECT department,
	total_count,
    terminated_count,
    terminated_count/total_count AS termination_rate
FROM(
	SELECT department,
    count(*) as total_count,
    sum(CASE WHEN termdate <> '0000-00-00' AND termdate <= curdate() THEN 1 ELSE 0 END) AS terminated_count
    FROM humanrsc
    WHERE age>=18
    GROUP BY department) AS sub
ORDER BY termination_rate DESC;

-- 9. What is the distribution of employees across locations by state?
SELECT location_state, count(*) location_count
FROM humanrsc 
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY location_state
ORDER BY location_count desc;

-- 10. How has the company's employee count changed over time based on hire and term dates?
SELECT 
	year,
    hires,
    terminations,
    hires - terminations AS net_change,
	ROUND((hires - terminations)/hires * 100, 2) AS net_change_perc
FROM(
	SELECT YEAR(hire_date) AS year,
    count(*) AS hires,
    SUM(CASE WHEN termdate<> '0000-00-00' AND termdate <=curdate() 
			THEN 1 
            ELSE 0 END) AS terminations
    FROM humanrsc
	WHERE AGE>=18
    GROUP BY year(hire_date)) AS subquery
ORDER BY year asc;
    
-- 11. What is the tenure distribution for each department?
SELECT department, ROUND(AVG(datediff(termdate, hire_date)/365),0) AS avg_tenure
FROM humanrsc
WHERE termdate <> '0000-00-00' AND termdate <=curdate() AND age >= 18
GROUP BY department;


select * from humanrsc;






