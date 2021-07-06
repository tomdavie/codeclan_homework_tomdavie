--MVP
--Q1
--a
SELECT 
	e.first_name AS first_name,
	e.last_name AS first_name,
	t.name AS team_name
FROM employees AS e LEFT JOIN teams AS t
	ON e.team_id = t.id;

--b
SELECT 
	e.first_name AS first_name,
	e.last_name AS first_name,
	t.name AS team_name
FROM employees AS e LEFT JOIN teams AS t
	ON e.team_id = t.id
WHERE e.pension_enrol = TRUE;

--c
SELECT 
	e.first_name AS first_name,
	e.last_name AS first_name,
	t.name AS team_name,
	t.charge_cost AS charge_cost
FROM employees AS e LEFT JOIN teams AS t
	ON e.team_id = t.id
WHERE CAST(t.charge_cost AS INTEGER) > CAST ('80' AS INTEGER);

--Q2
--a
SELECT 
	e.*,
	p.local_account_no AS local_account_no,
	p.local_sort_code AS local_sort_code
FROM employees AS e LEFT JOIN pay_details AS p 
	ON e.pay_detail_id = p.id;

--b

SELECT 
	e.*,
	p.local_account_no AS local_account_no,
	p.local_sort_code AS local_sort_code,
	t.name
FROM employees AS e LEFT JOIN pay_details AS p 
	ON e.pay_detail_id = p.id LEFT JOIN teams as t
	ON e.team_id = t.id; 

--Q3
--a

SELECT 
	e.id AS employee_ID,
	t.name AS team_name
FROM employees AS e INNER JOIN teams AS t 
	ON e.team_id = t.id 

--b

SELECT 
	COUNT(e.id) AS employee_ID,
	t.name AS team_name
FROM employees AS e INNER JOIN teams AS t 
	ON e.team_id = t.id   
GROUP BY t.name;

--c
SELECT 
	COUNT(e.id) AS num_employees,
	t.name AS team_name
FROM employees AS e INNER JOIN teams AS t 
	ON e.team_id = t.id   
GROUP BY t.name
ORDER BY COUNT(e.id); 

--Q4
--a

SELECT 
	e.team_id AS team_id,
	t.name AS team_name,
	COUNT(e.id) AS num_employees
FROM teams AS t LEFT JOIN employees AS e 
	ON t.id = e.team_id 
GROUP BY t.name, e.team_id;
	
--b

SELECT 
	e.team_id AS team_id,
	t.name AS team_name,
	COUNT(e.id) AS num_employees,
	CAST(t.charge_cost AS INTEGER) * COUNT(e.id) AS total_day_charge
FROM teams AS t LEFT JOIN employees AS e 
	ON t.id = e.team_id 
GROUP BY t.name, e.team_id, t.charge_cost;


--c

SELECT 
	t.name AS team_name,
	COUNT(e.id) AS num_employees,
	CAST(t.charge_cost AS INTEGER) * COUNT(e.id) AS total_day_charge
FROM teams AS t LEFT JOIN employees AS e 
	ON t.id = e.team_id 
GROUP BY t.name, e.team_id, t.charge_cost
HAVING CAST(t.charge_cost AS INTEGER) * COUNT(e.id) > 5000
ORDER BY total_day_charge;

--Extension

--Q5
--Q6