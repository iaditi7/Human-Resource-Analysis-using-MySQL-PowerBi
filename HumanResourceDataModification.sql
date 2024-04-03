/*Inspecting the data*/
select * from humanrsc;


 /*Data Modification*/
 /*Changed column name*/
 alter table humanrsc change column ﻿id emp_id varchar(20) NULL;
 
 /*Modified birthdate*/
 UPDATE humanrsc
SET birthdate = CASE
    WHEN birthdate LIKE '%/%' THEN DATE_FORMAT(STR_TO_DATE(birthdate, '%m/%d/%Y'), '%Y-%m-%d')
    WHEN birthdate LIKE '%-%' THEN DATE_FORMAT(STR_TO_DATE(birthdate, '%m-%d-%y'), '%Y-%m-%d')
    ELSE NULL
END;

alter table humanrsc
modify column birthdate date;

/*Modified hiredate*/
UPDATE humanrsc
SET hire_date = CASE
    WHEN hire_date LIKE '%/%' THEN DATE_FORMAT(STR_TO_DATE(hire_date, '%m/%d/%Y'), '%Y-%m-%d')
    WHEN hire_date LIKE '%-%' THEN DATE_FORMAT(STR_TO_DATE(hire_date, '%m-%d-%y'), '%Y-%m-%d')
    ELSE NULL
END;

ALTER TABLE humanrsc
MODIFY COLUMN hire_date DATE;

/*Modified termdate*/
update humanrsc
set termdate = IF(termdate IS NOT NULL AND termdate != '',date(str_to_date(termdate,'%Y-%m-%d %H:%i:%s UTC')), '0000-00-00')
where true;

SET sql_mode = 'ALLOW_INVALID_DATES';

ALTER TABLE humanrsc
MODIFY COLUMN termdate DATE;

/*Added new column age*/
ALTER TABLE humanrsc ADD COLUMN age INT;

UPDATE humanrsc
SET age = timestampdiff(YEAR, birthdate, CURDATE());

/*Verification of age*/
SELECT 
	MIN(age) AS youngest,
    MAX(age) AS oldest 
FROM humanrsc;
/*-45 is the youngest age and 58 is the oldest age*/

/*Total count of employees having age greater than 18years*/
SELECT COUNT(*) FROM humanrsc where age < 18;
/*Total count 967*/