/* MVP */

/* Q1 */

SELECT *
FROM employees
WHERE department = 'Human Resources';

/* Q2 */

SELECT 
	first_name,
	last_name,
	country
FROM employees 
WHERE department = 'Legal';

/* Q3 */

SELECT
	COUNT(*)
FROM employees 
WHERE country = 'Portugal';

/* Q4 */

SELECT 
	COUNT(*)
FROM employees 
WHERE country = 'Portugal' OR country = 'Spain';

/* Q5 */

SELECT
	COUNT(*) 
FROM pay_details 
WHERE local_account_no IS NULL;

/* Q6 */

SELECT *
FROM pay_details 
WHERE local_account_no IS NULL
AND iban IS NULL;

/* Q7 */

SELECT 
	first_name,
	last_name
FROM employees 
ORDER BY last_name ASC NULLS LAST

/* Q8 */
		
SELECT 
	first_name,
	last_name,
	country
FROM employees 
ORDER BY country ASC NULLS LAST,
		last_name ASC NULLS LAST;
		
/* Q9 */

SELECT *
FROM employees 
ORDER BY salary DESC NULLS LAST
LIMIT 10;

/* 10 */

SELECT
	first_name,
	last_name,
	salary
FROM employees 
WHERE country = 'Hungary'
ORDER BY salary ASC NULLS LAST;

/* 11 */

SELECT *
FROM employees 
WHERE first_name LIKE 'F%';

/* 12 */

SELECT *
FROM employees 
WHERE email LIKE '%yahoo%';

/* 13 */

SELECT *
FROM employees 
WHERE pension_enrol = TRUE 
AND (country != 'France' 
OR country != 'Germany');


/* 14 */

SELECT * 
FROM employees 
WHERE department = 'Engineering'
AND fte_hours = '1'
ORDER BY salary DESC NULLS LAST
LIMIT 1; 

/* 15 */

SELECT
	first_name,
	last_name,
	fte_hours,
	CONCAT(fte_hours * salary) 
	AS effective_yearly_salary
FROM employees; 

/* EXTENSION */
/* 16 */

SELECT 
	first_name,
	last_name,
	department,
	CONCAT(first_name, ' ', last_name, ' - ', department) 
	AS badge_label
FROM employees
WHERE first_name IS NOT NULL 
AND last_name IS NOT NULL
AND department IS NOT NULL;
	
/* 17 */

SELECT 
	first_name,
	last_name,
	department,
	start_date,
	CONCAT(first_name, ' ', last_name, ' - ', department, ' (joined ', TO_CHAR(start_date, 'FMMonth FMYYYY'), ')') 
	AS badge_label_date
FROM employees
WHERE first_name IS NOT NULL 
AND last_name IS NOT NULL
AND department IS NOT NULL
AND start_date IS NOT NULL;

/* 18 */

SELECT
	first_name,
	last_name,
	salary,
CASE 
	WHEN salary IS NULL THEN 'NA'
	WHEN salary < 40000 THEN 'low' 
	WHEN salary >= 40000 THEN 'high'
END AS salary_class
FROM employees;