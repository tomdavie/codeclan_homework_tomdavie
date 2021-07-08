--MVP
--Q1

SELECT 
	COUNT(id) AS num_pay_details_no_local_acct_iban
FROM pay_details
WHERE local_account_no IS NULL
AND iban IS NULL


--Q2

SELECT 
	first_name,
	last_name,
	country
FROM employees 
ORDER BY country, last_name NULLS LAST; 

--Q3

SELECT *
FROM employees 
ORDER BY salary DESC NULLS LAST
LIMIT 10;

--Q4

SELECT 
	first_name,
	last_name,
	salary
FROM employees 
WHERE country = 'Hungary'
ORDER BY salary ASC NULLS LAST 
LIMIT 1;

--Q5

SELECT * 
FROM employees 
WHERE email LIKE '%yahoo%'

--Q6

SELECT 
	COUNT(id),
	department
FROM employees 
WHERE start_date >= '2003-01-01'
AND start_date < '2004-01-01'
GROUP BY department 

--Q7

SELECT 
	department,
	fte_hours,
	COUNT(id)
FROM employees 
GROUP BY department, fte_hours 
ORDER BY department, fte_hours 

--Q8

SELECT
	pension_enrol,
	COUNT(id) AS num_employees
FROM employees 
GROUP BY pension_enrol

--Q9

SELECT
	salary	
FROM employees 
WHERE department = 'Engineering'
AND fte_hours = '1.0'
ORDER BY salary DESC
LIMIT 1;

--Q10

SELECT 
	country,
	COUNT(id) AS num_employees,
	ROUND(AVG(salary)) AS avg_salary
FROM employees 
GROUP BY country
HAVING COUNT(id) > 30
ORDER BY avg_salary DESC

--Q11

SELECT 
	first_name,
	last_name,
	fte_hours,
	salary,
	fte_hours * salary AS effective_yearly_salary
FROM employees; 

--Q12

SELECT
	first_name,
	last_name
FROM employees AS e LEFT JOIN pay_details as p
	ON e.id = p.id 
WHERE local_tax_code IS NULL 

--Q13

SELECT 
	e.id,
	e.first_name,
	e.last_name,
	(48 * 35 * CAST(t.charge_cost AS INTEGER) - e.salary) * e.fte_hours AS expected_profit 
FROM employees AS e INNER JOIN teams AS t 
	ON e.team_id = t.id 

--Q14
	
SELECT
	department,
	COUNT(id) AS no_name
FROM employees
WHERE first_name IS NULL
GROUP BY department
HAVING COUNT(id) >= 2
ORDER BY no_name DESC, department ASC
	
--Q15

SELECT
	first_name,
	COUNT(id)
FROM employees 
WHERE first_name IS NOT NULL
GROUP BY first_name 
ORDER BY COUNT(id) DESC, first_name ASC 

--Q16

SELECT
	department,
	CAST(COUNT(id) AS REAL) AS grade_1,
	ROUND(SUM(CAST(grade = 1 AS INTEGER))/CAST(COUNT(id) AS REAL)*100) AS proportion_of_grade_1
FROM employees 
GROUP BY department


--Extension
--Q17

---------------- Not managed this one! -----------

WITH dept_avg_sal(id, department , avg_salary) AS (
    SELECT
        id,
        department,
        AVG(salary)
    FROM employees
    GROUP BY department
)
SELECT 
    e.first_name,
    e.last_name,
    e.salary,
    e.salary / dept_avg_sal.avg_salary AS salary_over_dept_avg
 FROM employees AS e INNER JOIN dept_avg_sal
 ON e.id = dept_avg_sal.id

--Q18
	
SELECT
	CASE 
		WHEN pension_enrol IS NULL THEN 'Unknown'
		WHEN pension_enrol = FALSE THEN 'Not enrolled' 
		WHEN pension_enrol = TRUE THEN 'Enrolled'
	END AS pension_scheme,
	COUNT(id) AS num_employees
FROM employees 
GROUP BY pension_enrol 

--Q19

SELECT 
	e.first_name,
	e.last_name,
	e.email,
	e.start_date
FROM employees AS e LEFT JOIN employees_committees AS ec 
	ON e.id = ec.employee_id LEFT JOIN committees AS c
	ON ec.committee_id = c.id 
WHERE c.name = 'Equality and Diversity'
ORDER BY start_date ASC

--Q20
---- Not got working ---- 
SELECT 
	CASE 
		WHEN e.salary IS NULL THEN 'none'
		WHEN e.salary < 40000 THEN 'low' 
		WHEN e.salary >= 40000 THEN 'high'
	END AS salary_class,
 	COUNT(DISTINCT(e.id)) AS num_committee_members
FROM employees AS e INNER JOIN employees_committees AS ec 
	ON e.id = ec.employee_id
GROUP BY salary_class 

