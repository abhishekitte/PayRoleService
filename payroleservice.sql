-----UC1-------------
---Create DataBase---
Create database payroleservice;
use payroleservice;

---------UC2-----------
---Create table for DataBase---
CREATE TABLE employee_payroll(
	Id int Identity(1,1) PRIMARY KEY,
	--Identity is a method--
	Name varchar (200),
	Salary float,
	StartDate date
	);

	--------UC3 insert operation--------
INSERT INTO employee_payroll VALUES('Abhishek','12345','2016/03/01') ,('Viahan','13335','2018/01/05'),('Virat','525245','2019/03/01');


--------UC4-----------
---Retrieve all data from employee_payroll
select * from employee_payroll;


-----------Uc5-----------------------
---------Retrieve Specific Data-------
select Name,StartDate from employee_payroll where Name='Viahan';
select * from employee_payroll where StartDate between cast('2005-01-01' as date) and getdate();

--------------Uc6------------------------
-----------Alter the table to add gender---
alter table employee_payroll add Gender char(1);
update employee_payroll set Gender='M';
update employee_payroll set Gender='F' where Id='1';


-------------------------Uc7----------------------------------------
----calculate sum,avergae,min,max,count of employee ased on gender---
select SUM(Salary) as TotalSalary,Gender from employee_payroll group by Gender;
select AVG(Salary) as AverageSalary from employee_payroll group by Gender;
select count(Salary) as TotalSalary,Gender from employee_payroll group by Gender;
select Min(Salary) as MinSalary,Gender from employee_payroll group by Gender;
select Max(Salary) as MaxSalary,Gender from employee_payroll group by Gender;


---Uc8---
alter table employee_payroll add PhoneNumber bigint;
alter table employee_payroll add Department varchar(250) not null default 'HR';
alter table employee_payroll add Address varchar(250) default 'bangaluru';
select * from employee_payroll;


---Uc9---
---RenameColomn name in existing table(Salary renamed as Basic pay)---
Exec sp_rename 'employee_payroll.Salary', 'BasicPay';
alter table employee_payroll add TaxablePay float, Deduction float,IncomeTax float,NetPay float;
Update employee_payroll set Deduction = '4000' where Department = 'HR';
Update employee_payroll set Deduction = '3000' where Department = 'Sales';
Update employee_payroll set Deduction = '2000' where Department = 'Customer Service';
Update employee_payroll set NetPay = (BasicPay-Deduction);
Update employee_payroll set TaxablePay = '1000';
Update employee_payroll set IncomeTax = '200';
select * from employee_payroll;


---------UC10---------
------Create duplicate of person-------
INSERT INTO employee_payroll(Name,BasicPay,StartDate,Gender,PhoneNumber,Department,Address,TaxablePay,Deduction,IncomeTax,NetPay) VALUES('Terissa','525245','2018/03/01','F','7345787969','Sales','Mumbai','1200','1650','2000','40013');
INSERT INTO employee_payroll(Name,BasicPay,StartDate,Gender,PhoneNumber,Department,Address,TaxablePay,Deduction,IncomeTax,NetPay) VALUES('Terissa','525245','2018/03/01','F','7345787969','Marketing','Mumbai','0','0','0','0');


-------------UC11-------------
------By implimentaing ER, redoing UC 7--------------
-----Create table--------Company Details---
create table company
(
company_Id int identity(1,1) primary key,
company_name varchar(255)
)
Insert into company values('Microsoft'),('Google')
select * from company

--Create table--Employee Details---
create table Employee
(
EmployeeId int identity(1,1) primary key,
EmployeeName varchar(255),
Gender char(1),
EmployeePhoneNumber bigint,
EmployeeAddress varchar(255),
StartDate date,
CompanyId int
Foreign key(CompanyId) references Company(company_Id)
)
Insert into Employee values('Naveen','M','8080277459','Mumbai','2021-10-10','1'),('Anvesh','M','9967320888','Chennai','2018-07-14','2'),('Ruchira','F','9930532545','Delhi','2019-03-15','2'),('Sushmita','F','9988773443','Hyderbad','2020-11-11','2');
select * from Employee;

--Create table---Payroll table---
create table payroll
(
empId int 
foreign key(empId) references Employee(EmployeeId),
BasicPay float,
TaxablePay float,
IncomeTax float,
Deductions float,
NetPay float
)
Insert into payroll(empId,BasicPay,IncomeTax,Deductions)values('1','980000','50000','35000'),('2','620000','25000','30000'),('3','560500','12000','23000'),('4','420500','26000','12500');
select * from payroll;
Update payroll set TaxablePay = (BasicPay-Deductions)
Update payroll set NetPay = (TaxablePay-IncomeTax)
select * from payroll;

-----Department and employee has many many relation so two diffrent table needed
---Dept Table---
create table department_table
(
DepartmentId int identity(1,1) primary key,
DeptName varchar(255)
)
insert into department_table values('Developement'),('Marketing'),('HR'),('Sales');
select * from department_table

----Creating Employee Department table-----
create table emp_Dept
(
EmpId int
foreign key(EmpId) references Employee(EmployeeId),
DeptId int
foreign key(DeptId) references department_table(DepartmentId),
)
insert into emp_Dept values('1','3'),('2','1'),('3','4'),('4','3');
--creating duplicate, means same person works at different dept--
insert into emp_Dept values('4','2');
select * from emp_Dept;


--UC12-----
--Ensure all retrieve queries done especially in UC 4, UC 5 and UC 7 are working with new table structure--------

---UC4(Retrieve the data)--------- 
select company.company_Id ,company.company_name,EmployeeId,EmployeeName,Gender,EmployeePhoneNumber,EmployeeAddress,StartDate,payroll.BasicPay,TaxablePay,IncomeTax,Deductions,NetPay,department_table.DeptName from Employee
inner join company on company.company_Id = Employee.CompanyId
inner join payroll on payroll.EmpId = Employee.EmployeeId
inner join emp_Dept on Employee.EmployeeId = emp_Dept.EmpId
inner join department_table on department_table.DepartmentId = emp_Dept.DeptId;

----UC5------Retrieve salary of a perticular person
select Employee.EmployeeId,Employee.EmployeeName,payroll.BasicPay 
from payroll --Table1-- 
inner join
Employee ---Table2---
on Employee.EmployeeId=payroll.EmpId where Employee.EmployeeName = 'Veer';

------UC5------Retrieve salary in a date range
select Employee.EmployeeId,Employee.EmployeeName,payroll.BasicPay from payroll inner join
Employee on Employee.EmployeeId = payroll.EmpId where Employee.StartDate between Cast('2020-01-01' as Date) and GETDATE();

----------UC7---------
---Sum of salary based on gender---
select sum(payroll.BasicPay) as TotalSalary,Employee.Gender from Employee
inner join payroll on Employee.EmployeeId = payroll.EmpId group by Employee.Gender

---Average of salary based on gender---
select avg(payroll.BasicPay) as averagesalary,Employee.Gender from Employee
inner join payroll on Employee.EmployeeId = payroll.EmpId group by Employee.Gender

---Minimum salary based on gender---
select min(payroll.BasicPay) as minimumsalary,Employee.Gender from Employee
inner join payroll on Employee.EmployeeId = payroll.EmpId group by Employee.Gender

---Maximum salary based on gender---
select max(payroll.BasicPay) as maximumsalary,Employee.Gender from Employee
inner join payroll on Employee.EmployeeId = payroll.EmpId group by Employee.Gender;

----Count the number of Employee's salary based on gender
select count(payroll.BasicPay) as TotalSalary,Employee.Gender from Employee 
inner join payroll on Employee.EmployeeId = payroll.EmpId group by Employee.Gender;