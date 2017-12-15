use session_7;


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

CREATE TABLE employees_salary(
id int,
name string,
salary int,
unit string,
rnk int) ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
tblproperties(“skip.header.line.count” = “1”);




INSERT OVERWRITE TABLE employees_salary 
SELECT id, name, salary, unit , dense_rank() over (partition by unit order by salary) rnk

from employees;



SET hive.auto.convert.join = false;



SELECT T1.id, T1.name, T1.salary, T1.unit

from employees_salary T1

LEFT JOIN employees_salary T2

ON T1.unit = T2.unit and (T1.rnk+1) = (T2.rnk)

where (T2.salary-T1.salary) >100;
