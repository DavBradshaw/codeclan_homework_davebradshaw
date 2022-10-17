--Question 1.
--Find all the employees who work in the ‘Human Resources’ department.
SELECT *
FROM employees 
WHERE department = 'Human Resources';
-- There are 90 employees in Human Resources department.

--Question 2.
--Get the first_name, last_name, and country of the employees who work in the ‘Legal’ department.
SELECT first_name, last_name, country
FROM employees 
WHERE department = 'Legal';
--There are 102 employees in the legal department.

--Question 3.
--Count the number of employees based in Portugal.
SELECT count(*) AS employees_based_in_portugal
FROM employees 
WHERE country = 'Portugal';
--There are 29 employees based in Portugal.

--Question 4.
--Count the number of employees based in either Portugal or Spain.
SELECT count(*) AS ememployees_based_in_portugal_or_spain
FROM employees 
WHERE country = 'Portugal' OR country = 'Spain';
--There are 35 employees based in Portugal or Spain.

--Question 5.
--Count the number of pay_details records lacking a local_account_no.

SELECT count(*) AS pay_details_lacking_local_account_no
FROM pay_details 
WHERE local_account_no IS NULL;
--There are 25 pay_details records missing a local account number.

--Question 6.
--Are there any pay_details records lacking both a local_account_no and iban number?
--First a test
--SELECT *
--FROM pay_details 
--WHERE iban IS NULL

SELECT count(*) AS pay_details_missing_local_and_IBAN
FROM pay_details 
WHERE iban IS NULL AND local_account_no  IS NULL;

--There are none. There ARE 60 pay_details missing an IBAN number but these must ALL have a CORRESPONDING LOCAL account number.

--Question 7.
--Get a table with employees first_name and last_name ordered alphabetically by last_name (put any NULLs last).
SELECT first_name, last_name 
FROM employees 
ORDER BY last_name NULLS LAST;
--List created starting with Abels, Angus

--Question 8.
--Get a table of employees first_name, last_name and country, ordered alphabetically first by country
-- and then by last_name (put any NULLs last).
SELECT first_name, last_name, country 
FROM employees 
ORDER BY country, last_name NULLS LAST;
--List created starting with Pawden, Abeu from Afghanistan

--Question 9.
--Find the details of the top ten highest paid employees in the corporation.
SELECT *
FROM employees 
ORDER BY salary DESC NULLS LAST
LIMIT 10;
--List created starting with Gustave Truwert and their 99,889 salary 

--Question 10.
--Find the first_name, last_name and salary of the lowest paid employee in Hungary.
SELECT first_name, last_name, salary, country 
FROM employees 
WHERE country = 'Hungary'
ORDER BY salary;
--There is only 1 employee in Hungary, Eveline Canton on 20519 salary.

--Question 11.
--How many employees have a first_name beginning with ‘F’?
SELECT count(*) AS employees_beginning_with_F
FROM employees 
WHERE first_name LIKE 'F%';
--There are 30 employees whose first name begins with an F.

--Question 12.
--Find all the details of any employees with a ‘yahoo’ email address?
SELECT *
FROM employees 
WHERE email LIKE '%yahoo%';
--There are 5 employees with a yahoo e-mail address


--Question 13. Count the number of pension enrolled employees not based in either France or Germany.
SELECT*
FROM employees
WHERE country != 'France' AND
      country != 'Germany' AND
      pension_enrol = TRUE;      
--There are 475 pension enrolled employees not based in France or Germany (not France AND not Germany)
  
--Question 14.
--What is the maximum salary among those employees in the ‘Engineering’ department who work 1.0 full-time equivalent hours (fte_hours)?
SELECT *
FROM employees 
WHERE department = 'Engineering' AND 
      fte_hours = 1.0
ORDER BY salary DESC NULLS LAST;
--Table created starting with Gualterio Withnall, the Engineer in Ivory Coast on 83,370 salary.


--Question 15.
--Return a table containing each employees first_name, last_name, full-time equivalent hours (fte_hours), salary, 
--and a new column effective_yearly_salary which should contain fte_hours multiplied by salary.
SELECT 
    first_name, 
    last_name, 
    fte_hours, 
    salary,
    concat(salary * fte_hours) AS effective_yearly_salary
FROM employees 
--Table created with new column

--Question 16.
--The corporation wants to make name badges for a forthcoming conference.
--Return a column badge_label showing employees’ first_name and last_name joined together with their department in the following style:
-- ‘Bob Smith - Legal’. Restrict output to only those employees with stored first_name, last_name and department.
SELECT
    first_name,
    last_name,
    department,
    concat(first_name, ' ', last_name, ' - ', department) AS badge_label
FROM employees 
--Table created showing badge_label and the columns that made it.

--Question 17.
--One of the conference organisers thinks it would be nice to add the year of the employees’ start_date to the badge_label
-- to celebrate long-standing colleagues, in the following style ‘Bob Smith - Legal (joined 1998)’.
-- Further restrict output to only those employees with a stored start_date.
SELECT
    first_name,
    last_name,
    department,
    start_date,
    concat(
    first_name,
    ' ',
    last_name,
    ' - ',
    department,
    ' (joined ',
    EXTRACT (YEAR FROM start_date),
    ')') AS badge_label
FROM employees 
WHERE start_date IS NOT NULL;

--Table created and is not null filtered out 74 rows.

--Question 18.
--Return the first_name, last_name and salary of all employees together with a new column called salary_class
--with a value 'low' where salary is less than 40,000 and value 'high' where salary is greater than or equal to 40,000.
SELECT
    first_name,
    last_name,
    salary,
    CASE
        WHEN salary < 40000 THEN 'Low'
        WHEN salary >= 40000 THEN 'High'
    END AS salary_class
FROM employees 
--Table created with new column using CASE WHEN
 