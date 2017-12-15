use session_7;

drop table employees;

CREATE TABLE employees
(
id int,
name string,
salary int,
unit string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ' ';


LOAD DATA LOCAL INPATH 'input'
INTO TABLE employees;

set hive.auto.convert.join = false;

create table employees_salary_avg
(
unit string,
salary int)
row format delimited
fields TERMINATED by '\t'
tblproperties("skip.header.line.count"="1");

insert overwrite table employees_salary_avg
SELECT unit,avg(salary) salary
FROM employees
GROUP BY unit;


select e.*
from employees e
left join employees_salary_avg es
on e.unit = es.unit
where e.salary > es.salary;
