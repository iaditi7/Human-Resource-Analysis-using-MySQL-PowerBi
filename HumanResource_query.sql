/*The gender breakdown of employees in the company*/
SELECT gender, COUNT(*) AS count 
FROM humanrsc
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY gender;
/*More male employees in the company*/

/*The race/ethnicity breakdown of employees in the company*/
SELECT race, COUNT(*) AS race_count
FROM humanrsc
WHERE age >= 18 AND termdate = '0000-00-00'
group by race
ORDER BY count(*) desc;
/*White 4987*/

/*The age distribution of employees in the company*/
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

/*No of employees work at headquarters versus remote locations*/
SELECT location, count(*) AS work_mode FROM humanrsc
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY location ;
/*There are more employees working from Headquarter
    Headquarter: 13107
    Rempte: 4375*/
    
/*The average length of employment for employees who have been terminated*/
SELECT 
	ROUND(AVG(datediff(termdate, hire_date))/365, 0) AS avg_length_employment
FROM humanrsc
WHERE termdate <= curdate() AND termdate <> '0000-00-00' AND age >= 18;
/*The average length of employment is 8 years*/

/*The gender distribution vary across departments and job titles*/
SELECT department, gender, count(*) AS count_vary_dist
FROM humanrsc 
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY department, gender
ORDER BY department;
/*The Engineering Department has highest rate of employess and Male employees 2671*/

/*The distribution of job titles across the company*/
SELECT jobtitle, count(*) AS count_job 
FROM humanrsc 
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY jobtitle
ORDER BY jobtitle desc;
/*Account Executive has more no of employees*/

/*The department that has the highest turnover rate*/
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
/*The Marketing department has the lowest termination rate of 0.0938*/

/*The distribution of employees across locations by state*/
SELECT location_state, count(*) location_count
FROM humanrsc 
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY location_state
ORDER BY location_count desc;
/*Ohio has the highest no of employees*/

/*The company's employee count changed over time based on hire and term dates*/
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

/*The tenure distribution for each department*/
SELECT department, ROUND(AVG(datediff(termdate, hire_date)/365),0) AS avg_tenure
FROM humanrsc
WHERE termdate <> '0000-00-00' AND termdate <=curdate() AND age >= 18
GROUP BY department;

