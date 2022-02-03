use employees;
show tables;

-- 1. Feladat
-- dept_name alapján
use employees; 
select gender, departments.dept_name, avg(salaries.salary) AS "Átlag fizetés"
from employees
join  dept_emp using(emp_no) join departments using(dept_no)
join salaries using(emp_no)
group by gender, dept_name;

-- 2. feladat
-- legalacsonyabb
use employees;
select min(dept_no) AS "Legkisebb részlegszám" from dept_emp;
-- select concat("d", min(substring(dept_no, 2,3))) AS "Legkisebb részlegszám" from dept_emp;

-- legmagasabb
use employees;
select max(dept_no) AS "Legkisebb részlegszám" from dept_emp;
-- select max(substring(dept_no, 2,3))  AS "Legnagyobb részlegszám"  from dept_emp;

-- 3.feladat NEM működik
use employees;
select employees.emp_no, dept_no,
case
	when employees.emp_no <= 10020 then 110022
	when employees.emp_no between 10021 and 20040 then 110039
	end as 'manager'
from employees join dept_emp using(emp_no)
where employees.emp_no <=10040;

use employees;
select min(dept_no) As "Részlegszám" from dept_emp
where emp_no <=10040
group by emp_no;

-- 4.feladat
use employees;
select first_name, last_name, hire_date from employees
where substring(hire_date, 1,4) = '2000';

-- 5. feladat
use employees;
select employees.first_name, employees.last_name, titles.title
from employees join titles using(emp_no)
where titles.title = 'engineer';

-- 6.feladat
use employees;
drop procedure if exists last_dept;

delimiter $$
create procedure last_dept(in emp_number integer)
begin
	select departments.dept_name 
    from dept_emp join departments using(dept_no)
	where dept_emp.emp_no = emp_number and substring(dept_emp.to_date, 1, 4) = "9999";
end$$
delimiter ;

call last_dept(10010);

-- 7. feladat ebben benne van a határozatlan idő is!
use employees;
select count(emp_no) from salaries
where datediff(to_date, from_date) > 365 and salary > 100000;

-- 8. feladat
use employees;
delimiter $$
create trigger employees.before_hire
before insert on employees
for each row
begin
	if new.hire_date > sysdate() then
		set new.hire_date = date_format(sysdate(), '%y-%m-%d');
	end if;
end $$
delimiter ;

use employees;
insert employees values('999904', '1970-01-31', 'John', 'Johnson', 'M', '2025-01-01');
select * from employees order by emp_no desc limit 10;

drop trigger employees.before_hire;

-- 9. feladat
-- MAX
use employees;
drop function if exists f_max_salary;

delimiter $$
create function f_max_salary(p_emp_number integer) returns decimal(10,2)
    DETERMINISTIC
begin    
	declare v_max_salary decimal(10,2);
    
	select max(salaries.salary)
    into v_max_salary
    from employees 
    inner join salaries using(emp_no)
    where employees.emp_no = p_emp_number;
    
    return v_max_salary;
end$$

delimiter ;

select employees.f_max_salary(11356);

-- MIN
use employees;
drop function if exists f_min_salary;

delimiter $$
create function f_min_salary(p_emp_number integer) returns decimal(10,2)
    DETERMINISTIC
begin    
	declare v_min_salary decimal(10,2);
    
	select min(salaries.salary)
    into v_min_salary
    from employees 
    inner join salaries using(emp_no)
    where employees.emp_no = p_emp_number;
    
    return v_min_salary;
end$$

delimiter ;

select employees.f_min_salary(11356);


-- 10. feladat
use employees;
drop function if exists f_min_max_salary;

delimiter $$
create function f_min_max_salary(p_emp_number integer, min_or_max varchar(3)) returns decimal(10,2)
    DETERMINISTIC
begin    
	declare v_min_max_salary decimal(10,2);
    if min_or_max = 'min' then
		select min(salaries.salary)
		into v_min_max_salary
		from employees 
		inner join salaries using(emp_no)
		where employees.emp_no = p_emp_number;
	elseif min_or_max = 'max' then
		select max(salaries.salary)
		into v_min_max_salary
		from employees 
		inner join salaries using(emp_no)
		where employees.emp_no = p_emp_number;
	else
		select max(salaries.salary) - min(salaries.salary) AS 'satary_diff'
		into v_min_max_salary
		from employees 
		inner join salaries using(emp_no)
		where employees.emp_no = p_emp_number;
	end if;
    return v_min_max_salary;
end$$

delimiter ;

select employees.f_min_max_salary(11356, 'bla');



