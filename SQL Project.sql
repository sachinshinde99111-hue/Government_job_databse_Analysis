-- Part 1: Basic Exploration

-- Q)1. Display top 5 candidates from "Maharshtra".
Select * from candidates where state ='Maharashtra' limit 5;

-- Q)2.Show top 3 female candidates.
select * from candidates where gender = 'Female' limit 3;

-- Q)3.Find the 10 candidates whose age is greater than 30.
select candidate_id,name,age from candidates where age >30 limit 10;

-- Q)4.Find the applicationid,status where apply_date between '2026-01-01' to '2026-01-15'. 
select app_id,apply_date,status from applications where apply_date between '2026-01-01' and '2026-01-15';

-- Q) 5.Find the candidates whose start with sh .
select candidate_id,name from candidates where name like 'sh%';

-- Q) 6.Find jobs with salary greater than 50,000.
select job_id,job_title,salary from jobs where salary>=50000;

-- Q) 7.Show all records from results where marks is greater than 95 and less than 100.
select * from results where marks >95 and marks < 100;

-- Q) 8.display 5 record from results and status is only pass.
select * from results where status = 'pass' limit 5;

-- Part 2. where conditions + Filter + sort

-- Q) 9.Sort top 10 candidates by age in ascending order.
Select candidate_id,name,age from candidates order by age asc limit 10;

-- Q) 10. Sort top 5 jobs by salary in descending order.
select job_id,job_title,salary from jobs order by salary desc limit 5;

-- Q) 11. Display candidate_id, status and marks from results who's scored highest marks.
select candidate_id,marks,status from results order by marks desc limit 1;

-- Q) 12.Display the list of unique states from the candidates table.
select distinct state from candidates;

-- Q) 13. find the How many vacancies for Programmer, multimedia, IT sales professional,Editor, film/video  jobs. 
SELECT job_title, vacancies FROM jobs WHERE job_title IN ('Programmer, Multimedia','IT Sales Professional','Editor, Film/Video');

-- Q) 14.Show all jobs where job_title is start with 'Tech%'. 
select * from jobs where job_title like 'Tech%';

-- Q) 15.Show 10 candidates NOT from UP and  Bihar.
select name, state from Candidates where state not in('up','bihar') limit 10;

-- Part. AGGREGATE + GROUP BY

-- Q) 16. Count total number of candidates.
select count(*) as Total_candidates from candidates;

-- Q) 17. Count number of candidates in each state.
select State,count(candidate_id) as Candidate_count from candidates group by state;

-- Q) 18.Find the maximum salary.
select max(salary) as maximum_salary from jobs;

-- Q) 19.Get pass/fail count from results.
select status,count(*) from results group by status;

-- Q) 20.Find number of application apply candidate in each year.
select Year(apply_date),count(*) as Number_of_application from applications group by year(apply_date);

-- Q) 21.Find average age of candidates per state.
select state,avg(age) from candidates group by state;

-- Part 3. Joins

-- Q) 22.Get 15 candidate name with their applications.
select c.name,a.apply_date from candidates c inner join applications a on c.candidate_id = a.candidate_id limit 15;

-- Q) 23.get 10 candidate name with thier marks and status.
select c.name, r.marks, r.status from candidates c inner join results r on c.candidate_id = r.candidate_id limit 10; 

-- Q) 24. Show candidates whose name end s with  and the jobs they applied for.
select c.name,j.job_title from candidates c inner join applications a on c.candidate_id = a.candidate_id inner join jobs j on a.job_id = j.job_id where c.name like '%s';

-- Q) 25.Show candidates who top 3 failed candidates in exam.
select DISTINCT c.name,r.marks,r.status from candidates c join results r on c.candidate_id= r.candidate_id where r.status ='fail' order by r.marks desc limit 3;

-- Q) 26.Show all exams and results where marks in 80,81,83,85,90,92.
SELECT e.exam_id,e.exam_date, r.candidate_id, r.marks, r.status FROM exams e LEFT JOIN results r ON e.exam_id = r.exam_id where r.marks in(80,81,83,85,90,92);

-- Q) 27.Get top 3 candidates based on highest marks.
select c.candidate_id,c.name,max(marks) as highest_marks from candidates c join results r on c.candidate_id = r.candidate_id group by c.candidate_id,c.name order by highest_marks desc limit 3;

-- Q) 28.Find those 10 candidates who applied but his application is Rejected.
SELECT DISTINCT c.name,a.status FROM candidates c JOIN applications a ON c.candidate_id = a.candidate_id WHERE a.status ='Rejected' limit 10;

-- Q) 29.Show state-wise number of selected candidates.
SELECT c.state, COUNT(c.candidate_id) AS selected_candidates FROM candidates c JOIN results r ON c.candidate_id = r.candidate_id WHERE r.status = 'Pass' GROUP BY c.state;

-- Q) 30. Show top 10 candidate name, job title, and who got highest marks.
Select c.name,j.job_title,r.marks from results r join candidates c on r.candidate_id = c.candidate_id join applications a on c.candidate_id = a.candidate_id join jobs j on a.job_id = j.job_id order by r.marks desc limit 10;

-- Part 4. Having clause
-- Q) 31.Show exams where the average marks is greater than 60.
select e.exam_id,avg(r.marks) as Average_marks from exams e join results r on e.exam_id = r.exam_id group by e.exam_id having avg(r.marks)>60;

-- Q) 32.Find jobs where the total vacancies are greater than 50.
Select job_title,sum(vacancies) as total_vacancies from jobs group by job_title having sum(vacancies)>50;

-- Q) 33.Find 15 candidates whose average marks greater than 70 and less than 80.
select c.candidate_id,c.name,avg(r.marks) as AVG_marks from candidates c join results r on c.candidate_id = r.candidate_id group by c.candidate_id,c.name having AVG(r.marks) > 70 and AVG(r.marks) <80 limit 15;

-- Q) 34.Find jobs where no candidate has scored above 95.
select j.job_id,j.job_title,max(r.marks) from jobs j join exams e on j.job_id = e.job_id join results r on e.exam_id = r.exam_id group by J.job_id,j.Job_title having max(r.marks) <= 95;

-- Q) 35.Candidates with average marks exactly 60.
SELECT candidate_id, AVG(marks) AS avg_marks FROM results GROUP BY candidate_id HAVING AVG(marks) = 60;

-- Part 5. subqueries .

-- Q) 36.Find 10 candidates who have same marks as another candidate. 
select candidate_id,marks from results where marks in(select marks from results group by marks having count(*) >1) limit 10;

-- Q) 37.Find the second highest salary from the jobs table.
select max(salary) as Highest_salary from jobs where salary <(select max(salary) from jobs);

-- Q) 38.Find jobs where salary is greater than the average salary.
select job_title,salary from jobs where salary > (select avg(salary) from jobs);

-- part 6. Store procedures

-- Q) 39.Create a procedure to show top 10 candidates details.
Delimiter //

Create procedure show_10_candidates()
Begin
select * from candidates limit 10;
end //

Delimiter ;

Call show_10_candidates();

-- Q) 40.Create a procedure to Check if a candidate passed or failed (return message).
Delimiter $

create procedure check_results( IN p_candidate_id INT, IN p_exam_id INT)
BEGIN
Declare V_Marks INT;
select marks into V_marks from results where candidate_id = P_candidate_id And exam_id = P_exam_id;
if v_marks >= 40 Then
   select 'PASS' as result;
else
   select 'FAIL' as result;
END if;
EnD $
Delimiter ;

Call Check_result(1,213);
call check_result(3,256);

-- Q) 41. Create a procedure to get jobs based on salary range (min, max input).
Delimiter #
create procedure get_job_by_salary(IN P_Min_salary INT, IN P_Max_salary INT)
BEGIN
Select Job_id,Job_title,salary from jobs where salary between P_Min_salary And P_Max_salary;
END # 
delimiter ;

Call get_job_by_salary(20000,30000);

-- Part 7. Windows functions.

-- Q) 42.Show dense rank of candidates by marks but show only where marks is 99.
Select c.candidate_id,c.name,r.marks, DENSE_RANK() Over (order by r.marks desc) as rnk from candidates c join results r on c.candidate_id = r.candidate_id where r.marks = 99;

-- Q) 43.get Rank of 50 candidates within each exam.
select candidate_id,exam_id,marks, DENSE_RANK() Over (partition by r.exam_id order by r.marks DESC) as Rnk_within_exam from results r limit 50;

-- part 8.Business Insights

-- Q) 44.Which job has the highest number of applications? 
select j.job_id,j.job_title,count(a.app_id) as Total_applications from jobs j join applications a on j.job_id = a.job_id group by j.job_id,j.job_title order by Total_applications DESC limit 1;
-- Insight: Most popular job role.

-- Q) 45.Which state has the highest number of selected candidates?
select c.state,count(c.candidate_id) as selected_candidates from candidates c join results r on c.candidate_id = r.candidate_id where r.status = "Pass" group by c.state order by selected_candidates limit 1;
-- Insight: regional performance

-- Q) 46. Which job has the highest salary but lowest applications?
select j.job_id,j.job_title,j.salary,count(a.app_id) as Total_applications from jobs j left join applications a on j.job_id = a.job_id group by j.job_id,j.job_title,j.salary order by j.salary DESC, Total_applications ASC limit 1;
-- Insight: unpopular high-paying jobs

-- Q) 47.Which job has the highest competition per vacancy?
SELECT j.job_id,j.job_title,j.vacancies,COUNT(a.app_id) AS total_applications,(COUNT(a.app_id) / j.vacancies) AS competition_ratio FROM jobs j JOIN applications a ON j.job_id = a.job_id GROUP BY j.job_id, j.job_title, j.vacancies ORDER BY competition_ratio DESC LIMIT 1;
-- Insight: Highly competitive jobs