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
