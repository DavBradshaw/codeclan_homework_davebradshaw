--1 MVP


--Question 1.
--(a). Find the first name, last name and team name of employees who are members of teams.

SELECT
e.first_name,
e.last_name ,
t."name" AS team_name
FROM teams  AS t
INNER JOIN employees AS e
ON t.id = e.team_id;

--(b). Find the first name, last name and team name of employees who are members of teams and are enrolled in the pension scheme.

SELECT
e.first_name,
e.last_name ,
t."name" AS team_name
FROM teams  AS t
INNER JOIN employees AS e
ON t.id = e.team_id 
WHERE e.pension_enrol = TRUE;


--(c). Find the first name, last name and team name of employees who are members of teams, where their team has a charge cost greater than 80.

SELECT
e.first_name,
e.last_name ,
t."name" AS team_name
FROM teams  AS t
INNER JOIN employees AS e
ON t.id = e.team_id
WHERE CAST(t.charge_cost AS INT) > 80;


--Question 2.
--(a). Get a table of all employees details, together with their local_account_no and local_sort_code, if they have them.

SELECT
e.*,
p.local_account_no ,
p.local_sort_code 
FROM employees AS e
INNER JOIN pay_details AS p 
ON e.pay_detail_id = p.id 
WHERE p.local_account_no IS NOT NULL AND 
      p.local_sort_code IS NOT NULL;
      
--(b). Amend your query above to also return the name of the team that each employee belongs to.
SELECT
e.*,
p.local_account_no ,
p.local_sort_code,
t."name" AS team_name
FROM employees AS e
INNER JOIN pay_details AS p 
ON e.pay_detail_id = p.id
INNER JOIN teams AS t 
ON e.team_id = t.id 
WHERE p.local_account_no IS NOT NULL AND 
      p.local_sort_code IS NOT NULL;

--Question 3.
--(a). Make a table, which has each employee id along with the team that employee belongs to.

SELECT
e.id AS employee_ID,
t.name AS team_name
FROM employees AS e
INNER JOIN teams AS t 
ON e.team_id = t.id
ORDER BY employee_ID;
      
--(b). Breakdown the number of employees in each of the teams.

SELECT
t.name AS team_name,
count(e.id)
FROM employees AS e
INNER JOIN teams AS t 
ON e.team_id = t.id
GROUP BY t."name"; 

--(c). Order the table above by so that the teams with the least employees come first.

SELECT
t.name AS team_name,
count(e.id) AS employees_in_department
FROM employees AS e
INNER JOIN teams AS t 
ON e.team_id = t.id
GROUP BY t."name" 
ORDER BY employees_in_department;



--Question 4.
--(a). Create a table with the team id, team name and the count of the number of employees in each team.

SELECT
t.id,
t.name AS team_name,
count(t.id) AS number_of_employees
FROM employees AS e
INNER JOIN teams AS t 
ON e.team_id = t.id 
GROUP BY t.id; 

--(b). The total_day_charge of a team is defined as the charge_cost of the team multiplied by the number of employees in the team. Calculate the total_day_charge for each team.

SELECT 
t.id,
t.name AS team_name,
(count(t.id)) * CAST(t.charge_cost AS INT) AS total_day_charge
FROM employees AS e
INNER JOIN teams AS t 
ON e.team_id = t.id 
GROUP BY t.id; 

--(c). How would you amend your query from above to show only those teams with a total_day_charge greater than 5000?

SELECT 
t.id,
t.name AS team_name,
(count(t.id)) * CAST(t.charge_cost AS INT) AS total_day_charge
FROM employees AS e
INNER JOIN teams AS t 
ON e.team_id = t.id
GROUP BY t.id
HAVING (count(t.id)) * CAST(t.charge_cost AS INT) >5000;


--2 Extension


--Question 5.
--How many of the employees serve on one or more committees?
SELECT
DISTINCT (employee_id)
FROM employees_committees;
--There are 22 distinct

SELECT
employee_id,
count(employee_id) AS commitees_served_on
FROM employees_committees 
GROUP BY employee_id
ORDER BY commitees_served_on DESC
LIMIT 2;
--Review - answered the wrong question, read it as how many serve on more than one committee.
--Answered who serves on more than one committee


--Question 6.
--How many of the employees do not serve on a committee?
--The answer is 978 employees who provide NULL value for comittee when joining
SELECT 
sum(CASE WHEN ec.committee_id IS NULL THEN 1 ELSE 0 end) AS employee_not_on_committee
FROM employees AS e
LEFT JOIN employees_committees AS ec
ON e.id = ec.employee_id;

