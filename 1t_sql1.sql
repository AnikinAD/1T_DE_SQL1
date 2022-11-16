
create table employee(
emp_id serial  ,
lastname varchar(50),
firstname varchar(50),
surname varchar(50),
hiring_date date,
position  varchar(50), -- лучше ссылку на таблицу со списком позиций position_id int
emp_level  varchar(50), -- лучше ссылку на таблицу со списком уровней emd_level_id int
salary money,
department_id int,
driver_license bool);

create table department(
dep_id serial,
name varchar(50),
chief_id int, -- вместо имени сразу ссылаемся на сотрудника
dep_size int)
;


create table rating (
emp_id int,
grade_year int,
grade_quarter int,
grade char(1));

insert into employee values (
DEFAULT,
'Говоров',
'Михаил',
'Сергеевич',
to_date('2018-07-22', 'YYYY-MM-DD'),
'Ведущий разработчик',
'lead',
150000,
2,
false),
(
DEFAULT,
'Кашев',
'Алексей',
'Романович',
to_date('2018-09-22', 'YYYY-MM-DD'),
'Старший разработчик',
'senior',
120000,
2,
false),
(
DEFAULT,
'Лом',
'Викентий',
'Федотович',
to_date('2018-12-05', 'YYYY-MM-DD'),
'Младший разработчик',
'jun',
40000,
2,
false),
(
DEFAULT,
'Комова',
'Виктория',
'Николаевна',
to_date('2018-06-15', 'YYYY-MM-DD'),
'Главный бухгалтер',
'lead',
200000,
1,
false),
(
DEFAULT,
'Воронова',
'Ульяна',
'Сергеевна',
to_date('2018-11-24', 'YYYY-MM-DD'),
'бухгалтер',
'middle',
100000,
1,
false)
;
insert into department values
(DEFAULT, 'Бухгалтерия', 4, 2),
(DEFAULT, 'Отдел разработки', 1, 3);

insert into employee values (
DEFAULT,
'Корнеев',
'Александр',
'Валентинович',
to_date('2019-03-12', 'YYYY-MM-DD'),
'Ведущий тестировщик',
'lead',
150000,
3,
true),
(
DEFAULT,
'Фомина',
'Анастасия',
'Максимовна',
to_date('2019-03-20', 'YYYY-MM-DD'),
'Младший тестировщик',
'jun',
30000,
3,
false),
(
DEFAULT,
'Уткин',
'Вадим',
'Романович',
to_date('2019-04-05', 'YYYY-MM-DD'),
'Тестировщик',
'middle',
80000,
3,
false);

insert into department values
(DEFAULT, 'Отдел тестирования', 6, 3) ;

insert into rating values
(1, 2019, 1, 'A'),
(1, 2019, 2, 'A'),
(1, 2019, 3, 'B'),
(1, 2019, 4, 'B'),
(2, 2019, 1, 'C'),
(2, 2019, 2, 'C'),
(2, 2019, 3, 'C'),
(2, 2019, 4, 'C'),
(3, 2019, 1, 'C'),
(3, 2019, 2, 'D'),
(3, 2019, 3, 'B'),
(3, 2019, 4, 'C');

select emp_id, lastname, firstname, current_date - hiring_date as work_experience_in_days
from employee;

select emp_id, lastname, firstname, current_date - hiring_date as work_experience_in_days
from employee
where emp_id <4;
-- альтернативный вариант по дате трудоустройства через оконку
select emp_id, lastname, firstname, work_experience_in_days
from (
select emp_id, lastname, firstname, current_date - hiring_date as work_experience_in_days, rank() over (order by hiring_date asc ) rnk
from employee
) as t1
where rnk <4;


select emp_id 
from employee
where driver_license = true;

select distinct emp_id
from  rating
where grade in ('D', 'E');

select max(salary) 
from employee;

--доп
select name
from (
select name, rank() over (order by dep_size desc) rnk
from  department
) t
where rnk = 1;

--jun, middle, senior, lead
 
select emp_id 
from (
select emp_id, rank() over (order by hiring_date asc ) rnk
from employee
) as t1
order by rnk, emp_id;

select  emp_level, avg(salary::numeric)
from employee
group by emp_level;


alter table employee add column bonus_coef numeric(2,1);

UPDATE employee
SET bonus_coef= subquery.bonus_coef
FROM (SELECT emp_id, 1 + sum(case when grade = 'A' then 0.2  when grade = 'B' then 0.1  when grade = 'C' then 0  when grade = 'D' then -0.1  when grade = 'E' then -0.2 end) as bonus_coef
      FROM rating
	  group by emp_id ) AS subquery
WHERE employee.emp_id=subquery.emp_id;