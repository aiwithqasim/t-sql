CREATE TABLE EmployeeTest
(
EmpId INT IDENTITY,
Emp_Name VARCHAR(15),
Emp_Salary DECIMAL(10,2)
)

INSERT INTO EmployeeTest VALUES
('Qasim', 100),
('Hassan', 200),
('Ali', 300)

CREATE TABLE EmployeeTest_Audit
(
EmpId INT,
Emp_Name VARCHAR(15),
Emp_Salary DECIMAL(10,2),
Audit_Action VARCHAR(15),
Audit_Timestamp DATETIME
)

CREATE TRIGGER BackupEmp
ON  EmployeeTest
FOR INSERT
AS
	DECLARE @empid INT;
	DECLARE @empname VARCHAR(15);
	DECLARE @empsalary DECIMAL(10,2);
	DECLARE @audit VARCHAR(15)

	SELECT @empid = i.EmpId FROM INSERTED i;
	SELECT @empname = i.Emp_Name FROM INSERTED i;
	SELECT @empsalary = i.Emp_Salary FROM INSERTED i;
	SELECT @audit = 'Insert Record - After Insert Trigger';

INSERT INTO EmployeeTest_Audit VALUES 
(@empid, @empname, @empsalary, @audit, GETDATE());

PRINT 'After Insertion Trigger Fired'

SELECT * FROM EmployeeTest;
SELECT * FROM EmployeeTest_Audit;

INSERT INTO EmployeeTest VALUES
('Qasim', 200);