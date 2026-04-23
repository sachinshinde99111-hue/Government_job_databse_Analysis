-- Part 1: Basic Exploration

-- Q)1. Display all records from the candidates table
Select * from candidates;

-- Q)2.Show all female candidates.
select * from candidates where gender = 'Female';

-- Q)3.Find candidates whose age is greater than 30.
select candidate_id,name,age from candidates where age >30;

-- Q)4.Find the applicationid,status where apply_date between '2025-11-1' to '2026-01-30'. 
select app_id,apply_date,status from applications where apply_date between '2025-11-1' and '2026-01-30';

-- Q) 5.Display candidates from Maharashtra.
select candidate_id,name,state from candidates where state = 'maharashtra';

-- Q) 6.Find jobs with salary greater than 50,000.
select job_id,job_title,salary from jobs where salary>=50000;

-- Q) 7.Show records from results where marks are greater than 80 and less then 40.
select * from results where marks>80 or marks<40;

-- Q) 8.display all record from results and status is only pass.
select * from results where status = 'pass';

-- Part 2. where conditions + Filter + sort

-- Q) 9.Sort candidates by age in ascending order.
Select candidate_id,name,age from candidates order by age asc;

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

-- Q) 15.Show candidates NOT from UP and  Bihar.
select name, state from Candidates where state not in('UP','bihar');

-- Part. AGGREGATE + GROUP BY

-- Q) 16. Count total number of candidates
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

-- Q) 22.Get candidate name with their applications.
select c.name,a.apply_date from candidates c inner join applications a on c.candidate_id = a.candidate_id;

-- Q) 23.get candidate name with thier marks and status.
select c.name, r.marks, r.status from candidates c inner join results r on c.candidate_id = r.candidate_id; 

-- Q) 24. Show candidates and the jobs they applied for.
select c.name,j.job_title from candidates c inner join applications a on c.candidate_id = a.candidate_id inner join jobs j on a.job_id = j.job_id;

-- Q) 25.Show candidates who failed exams.
select DISTINCT c.name from candidates c join results r on c.candidate_id= r.candidate_id where r.status = 'Fail';

-- Q) 26.Show all exams and results.
SELECT e.exam_id,e.exam_date, r.candidate_id, r.marks, r.status FROM exams e LEFT JOIN results r ON e.exam_id = r.exam_id;

-- Q) 27.Get top 3 candidates based on highest marks.
select c.candidate_id,c.name,max(marks) as highest_marks from candidates c join results r on c.candidate_id = r.candidate_id group by c.candidate_id,c.name order by highest_marks desc limit 3;

-- Q) 28.Show candidates who applied but didn’t attend any exam.
SELECT DISTINCT c.name FROM candidates c JOIN applications a ON c.candidate_id = a.candidate_id LEFT JOIN results r ON c.candidate_id = r.candidate_id WHERE r.candidate_id IS NULL;

-- Q) 29.Show city-wise number of selected candidates.
SELECT c.state, COUNT(c.candidate_id) AS selected_candidates FROM candidates c JOIN results r ON c.candidate_id = r.candidate_id WHERE r.status = 'Pass' GROUP BY c.state;

-- Q) 30. Show candidate name, job title, and marks for all results.
Select c.name,j.job_title,r.marks from results r join candidates c on r.candidate_id = c.candidate_id join applications a on c.candidate_id = a.candidate_id join jobs j on a.job_id = j.job_id;

-- Part 4. Having clause
-- Q) 31.Show exams where the average marks is greater than 60.
select e.exam_id,avg(r.marks) as Average_marks from exams e join results r on e.exam_id = r.exam_id group by e.exam_id having avg(r.marks)>60;

-- Q) 32.Find jobs where the total vacancies are greater than 50.
Select job_title,sum(vacancies) as total_vacancies from jobs group by job_title having sum(vacancies)>50;

-- Q) 33.Find candidates whose total marks > 150 AND average marks > 60
select c.candidate_id,c.name,sum(r.marks) as total_marks, avg(r.marks) as AVG_marks from candidates c join results r on c.candidate_id = r.candidate_id group by c.candidate_id,c.name having sum(r.marks) > 150 AND AVG(r.marks) > 60;

-- Q) 34.Find jobs where no candidate has scored above 95
select j.job_id,j.job_title,max(r.marks) from jobs j join exams e on j.job_id = e.job_id join results r on e.exam_id = r.exam_id group by J.job_id,j.Job_title having max(r.marks) <= 95;

-- Q) 35.Find exams where maximum marks scored is greater than 90.
select e.exam_id,max(r.marks) as maximum_marks from exams e join results r on e.exam_id = r.exam_id group by e.exam_id having max(r.marks) > 90;

-- Part 5. subqueries .

-- Q) 36.Find candidates who have same marks as another candidate. 
select candidate_id,marks from results where marks in(select marks from results group by marks having count(*) >1);

-- Q) 37.Find the second highest salary from the jobs table.
select max(salary) as Highest_salary from jobs where salary <(select max(salary) from jobs);

-- Q) 38.Find jobs where salary is greater than the minimum salary.
select job_title,salary from jobs where salary > (select min(salary) from jobs);

-- part 6. Store procedures

-- Q) 39.Create a procedure to get all candidates details.
Delimiter //

Create procedure get_all_candidates()
Begin
select * from candidates;
end //

Delimiter ;

Call get_all_candidates();

-- Q) 40.Create a procedure to Check if a candidate passed or failed (return message).
Delimiter $

create procedure check_result( IN p_candidate_id INT, IN p_exam_id INT)
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

-- Q) 42.Show dense rank of candidates by marks.
Select c.candidate_id,c.name,r.marks, DENSE_RANK() Over (order by r.marks desc) as rnk from candidates c join results r on c.candidate_id = r.candidate_id;

-- Q) 43.Rank candidates within each exam.
select candidate_id,exam_id,marks, DENSE_RANK() Over (partition by r.exam_id order by r.marks DESC) as Rnk_within_exam from results r;

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