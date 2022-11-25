use employees_mod;
select * from t_departments;
select * from t_dept_emp;
select * from t_dept_manager;
select * from t_employees;
select * from t_salaries;

# TASK 1
select YEAR(d.from_date) as calender_yr,e.gender,count(e.emp_no) as num_of_employees
from t_ as e
join t_dept_emp as d
on e.emp_no=d.emp_no
group by calender_yr,gender
HAVING calender_yr >= 1990
order by calender_yr;

# TASK 2
select 
	d.dept_name,
    ee.gender,
    dm.emp_no,
    dm.from_date,
    dm.to_date,
	e.calender_yr,
	CASE
		WHEN e.calender_yr >= YEAR(dm.from_date) and e.calender_yr <= YEAR(dm.to_date)
			THEN 1
		ELSE 0
	END AS activee
from (SELECT YEAR(hire_date) as calender_yr FROM t_employees GROUP BY calender_yr) as e
CROSS JOIN t_dept_manager as dm
JOIN t_departments as d
ON dm.dept_no=d.dept_no
JOIN t_employees as ee
ON ee.emp_no=dm.emp_no
ORDER BY dm.emp_no, calender_yr;

# TASK 3
SELECT 
	e.gender, 
    d.dept_name, 
    ROUND(AVG(s.salary),2) as Avg_salary, 
    YEAR(s.from_date) as calender_yr
FROM t_employees as e
JOIN t_dept_emp as de
	ON e.emp_no=de.emp_no
JOIN t_departments as d
	ON de.dept_no=d.dept_no
JOIN t_salaries as s
	ON e.emp_no=s.emp_no
GROUP BY d.dept_no,e.gender,calender_yr
HAVING calender_yr <= 2002
ORDER BY d.dept_no;

# TASK 4

DROP PROCEDURE IF EXISTS filter_salary;
DELIMITER $$
CREATE PROCEDURE filter_salary (IN p_min_salary FLOAT, IN p_max_salary FLOAT)
BEGIN
SELECT 
    e.gender, d.dept_name, AVG(s.salary) as avg_salary
FROM
    t_salaries s
        JOIN
    t_employees e ON s.emp_no = e.emp_no
        JOIN
    t_dept_emp de ON de.emp_no = e.emp_no
        JOIN
    t_departments d ON d.dept_no = de.dept_no
    WHERE s.salary BETWEEN p_min_salary AND p_max_salary
GROUP BY d.dept_no, e.gender;
END$$
DELIMITER ;
CALL filter_salary(50000, 90000);
