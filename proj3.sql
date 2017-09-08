set serveroutput on;

-- drop all tables
DROP TABLE RoomAccess;
DROP TABLE Employee;
DROP TABLE Equipment;
DROP TABLE StayIn;
DROP TABLE RoomService;
DROP TABLE Examine;
DROP TABLE Admission;
DROP TABLE Patient;
DROP TABLE Doctor;
DROP TABLE Room;
DROP TABLE EquipmentType;

-- create all tables with constraints
CREATE TABLE Patient (
	SSN char(12) primary key,
	lastName varchar2(20),
	firstName varchar2(20),
	phoneNum char(12),
	address varchar2(100)
);

CREATE TABLE Admission (
	Num integer primary key,
	SSN char(12) references Patient(SSN),
	admitTime timestamp,
	leaveTime timestamp,
	totalPayment float,
	insurancePayment float,
	futureVisit timestamp
);

CREATE TABLE Doctor (
	ID integer primary key,
	LastName varchar2(20),
	FirstName varchar2(20),
	gender char(1) check (gender='M' or gender='F'),
	specialty varchar2(20)
);
	
CREATE TABLE Examine (
	DocID integer references Doctor(ID),
	AdmissionNum integer references Admission(Num),
	comments varchar2(100),
	constraint pk_examine primary key (DocID, AdmissionNum)
);

CREATE TABLE Room (
	Num integer primary key,
	occupied char(1) check (occupied='T' or occupied='F')
);

CREATE TABLE RoomService (
	RoomNum integer references Room(Num),
	service varchar2(20),
	constraint pk_roomservice primary key (RoomNum, service)
);

CREATE TABLE StayIn (
	AdmissionNum integer references Admission(Num),
	RoomNum integer references Room(Num),
	startDate timestamp,
	endDate timestamp,
	constraint pk_stayin primary key (AdmissionNum, RoomNum, startDate)
);

CREATE TABLE EquipmentType (
	ID integer primary key, 
	description varchar2(50),
	model varchar2(20),
	instructions varchar2(200)
);
	
CREATE TABLE Equipment (
	SerialNum char(7) primary key,
	TypeID integer references EquipmentType(ID),
	PurchaseYear integer,
	LastInspection timestamp,
	roomNum integer references Room(Num)
);

CREATE TABLE Employee (
	ID integer primary key,
	firstName varchar2(20),
	lastName varchar2(20),
	salary float,
	jobTitle varchar2(20),
	officeNum integer,
	employeeRank varchar2(3) check (employeeRank='gen' or employeeRank='reg' or employeeRank='div'),
	supervisorID references Employee(ID)
);

CREATE TABLE RoomAccess (
	roomNum integer references Room(Num),
	employeeID integer references Employee(ID),
	constraint pk_roomaccess primary key (roomNum, employeeID)
);
	
-- populate tables
INSERT INTO Patient 
VALUES ('100-00-0000', 'Smith', 'Bob', '732-000-0000', '123 Sesame Street');
INSERT INTO Patient 
VALUES ('100-00-0001', 'Man', 'Muffin', '732-000-0001', 'Dreary Lane');
INSERT INTO Patient
VALUES ('100-00-0002', 'Potts', 'Mrs.', '732-000-0002', '1600 Pennsylvania Ave');
INSERT INTO Patient
VALUES ('100-00-0003', 'Lebowski', 'Big', '732-000-0003', '1 Dude Mansion Ave');
INSERT INTO Patient
VALUES ('100-00-0004', 'Meed', 'Fratt', '732-000-0004', '63 Wachusett Street');
INSERT INTO Patient
VALUES ('100-00-0005', 'Freed', 'Matt', '732-000-0005', '63 Wachusett Street');
INSERT INTO Patient
VALUES ('100-00-0006', 'Name', 'Fake', '732-000-0006', '1313 Fake Drive');
INSERT INTO Patient
VALUES ('100-00-0007', 'Nose', 'Nobody', '732-000-0007', '1000 Mystery Lane');
INSERT INTO Patient
VALUES ('100-00-0008', 'Gates', 'Bill', '732-000-0008', 'Bill Gates House Road');
INSERT INTO Patient
VALUES ('111-22-3333', 'Chamberlin', 'Donald', '732-000-0009', '16 INSERT INTO DRIVE');

INSERT INTO Doctor
VALUES (1, 'Django', 'Dr.', 'M', 'Euthanasia');
INSERT INTO Doctor
VALUES (2, 'Krieger', 'Dr.', 'M', 'Espionage');
INSERT INTO Doctor
VALUES (3, 'Guth', 'Kevin', 'M', 'Math');
INSERT INTO Doctor
VALUES (4, 'Bag', 'Bean', 'M', 'Cancer');
INSERT INTO Doctor
VALUES (5, 'Bag', 'Mean', 'M', 'Urinology');
INSERT INTO Doctor
VALUES (6, 'Hill', 'Mr.', 'M', 'Saltology');
INSERT INTO Doctor
VALUES (7, 'Slab', 'K', 'F', 'Diseases');
INSERT INTO Doctor
VALUES (8, 'Wireman', 'Beverly', 'F', 'Scientology');
INSERT INTO Doctor
VALUES (9, 'Up', 'Square', 'F', 'Drama');
INSERT INTO Doctor
VALUES (10, 'White', 'Betty', 'F', 'Nursing');

INSERT INTO Room VALUES (100, 'T');
INSERT INTO RoomService VALUES (100, 'Emergency Room');
INSERT INTO RoomService VALUES (100, 'Operating Room');
INSERT INTO Room VALUES (101, 'F');
INSERT INTO Room VALUES (102, 'F');
INSERT INTO Room VALUES (103, 'F');
INSERT INTO RoomService VALUES (103, 'Consulting Room');
INSERT INTO RoomService VALUES (103, 'ICU');
INSERT INTO Room VALUES (104, 'F');
INSERT INTO Room VALUES (105, 'F');
INSERT INTO Room VALUES (106, 'T');
INSERT INTO Room VALUES (107, 'F');
INSERT INTO RoomService VALUES (107, 'Ward Room');
INSERT INTO RoomService VALUES (107, 'ICU');
INSERT INTO Room VALUES (108, 'F');
INSERT INTO Room VALUES (109, 'F');

INSERT INTO EquipmentType
VALUES (0, 'MRI', '300', 'Turn it off and back on');
INSERT INTO Equipment
VALUES ('A01-02X', 0, 2010, TIMESTAMP'2016-01-01 08:00:00', 103);
INSERT INTO Equipment
VALUES ('B01-01A', 0, 2010, TIMESTAMP'2016-02-01 08:00:00', 100);
INSERT INTO Equipment
VALUES ('A01-03X', 0, 2011, TIMESTAMP'2016-03-01 08:00:00', 104);

INSERT INTO EquipmentType
VALUES (1, 'Ultrasound', '1000', 'Stick it in peoples faces');
INSERT INTO Equipment
VALUES ('A09-03P', 1, 2010, TIMESTAMP'2016-12-01 08:00:00', 101);
INSERT INTO Equipment
VALUES ('B49-19Z', 1, 2011, TIMESTAMP'2016-11-01 08:00:00', 103);
INSERT INTO Equipment
VALUES ('D04-12Q', 1, 2010, TIMESTAMP'2016-10-01 08:00:00', 107);
INSERT INTO Equipment
VALUES ('D00-00D', 1, 2011, TIMESTAMP'2016-09-01 08:00:00', 108);

INSERT INTO EquipmentType
VALUES (2, 'CT Scanner', '200', 'Its like a radar for disease');
INSERT INTO Equipment
VALUES ('A00-00A', 2, 2010, TIMESTAMP'2016-08-01 08:00:00', 102);
INSERT INTO Equipment
VALUES ('B00-00B', 2, 2010, TIMESTAMP'2016-07-01 08:00:00', 105);
INSERT INTO Equipment
VALUES ('C00-00C', 2, 2010, TIMESTAMP'2016-06-01 08:00:00', 109);

INSERT INTO Admission
VALUES (0, '111-22-3333', TIMESTAMP'2016-12-01 08:00:00', TIMESTAMP'2016-12-24 22:00:00', 200, 100.50, TIMESTAMP'2017-01-01 12:00:00');
INSERT INTO Admission
VALUES (10, '111-22-3333', TIMESTAMP'2017-01-01 12:00:00', TIMESTAMP'2017-02-01 22:00:00', 300, 200, TIMESTAMP'2017-12-01 08:00:00');
INSERT INTO Admission
VALUES (1, '111-22-3333', TIMESTAMP'2017-12-01 08:00:00', TIMESTAMP'2016-12-24 22:00:00', 200, 100.50, TIMESTAMP'2018-01-01 12:00:00');

INSERT INTO Admission
VALUES (2, '100-00-0001', TIMESTAMP'2016-12-01 08:00:00', TIMESTAMP'2016-12-24 22:00:00', 300, 200, TIMESTAMP'2017-01-01 12:00:00');
INSERT INTO Admission
VALUES (11, '100-00-0001', TIMESTAMP'2017-01-01 12:00:00', TIMESTAMP'2017-02-01 22:00:00', 300, 200, TIMESTAMP'2017-12-01 08:00:00');
INSERT INTO Admission
VALUES (3, '100-00-0001', TIMESTAMP'2017-12-01 08:00:00', TIMESTAMP'2016-12-24 22:00:00', 300, 250, NULL);

INSERT INTO Admission
VALUES (4, '100-00-0003', TIMESTAMP'2016-12-01 08:00:00', TIMESTAMP'2016-12-24 22:00:00', 200, 100.50, NULL);
INSERT INTO Admission
VALUES (5, '100-00-0003', TIMESTAMP'2017-12-01 08:00:00', TIMESTAMP'2016-12-24 22:00:00', 200, 200, NULL);

INSERT INTO Admission
VALUES (6, '100-00-0006', TIMESTAMP'2016-12-01 08:00:00', TIMESTAMP'2016-12-24 22:00:00', 400, 300.50, TIMESTAMP'2017-01-01 12:00:00');
INSERT INTO Admission
VALUES (7, '100-00-0006', TIMESTAMP'2017-12-01 08:00:00', TIMESTAMP'2016-12-24 22:00:00', 400, 100.50, TIMESTAMP'2018-01-01 12:00:00');

INSERT INTO Admission
VALUES (8, '100-00-0008', TIMESTAMP'2016-12-01 08:00:00', TIMESTAMP'2016-12-24 22:00:00', 500, 100.50, NULL);
INSERT INTO Admission
VALUES (9, '100-00-0008', TIMESTAMP'2017-12-01 08:00:00', TIMESTAMP'2016-12-24 22:00:00', 500, 500, NULL);

INSERT INTO Admission
VALUES (12, '100-00-0000', TIMESTAMP'2016-12-01 08:00:00', TIMESTAMP'2016-12-24 22:00:00', 200, 100.50, NULL);
INSERT INTO Admission
VALUES (13, '100-00-0002', TIMESTAMP'2016-12-01 08:00:00', TIMESTAMP'2016-12-24 22:00:00', 200, 100.50, NULL);
INSERT INTO Admission
VALUES (14, '100-00-0004', TIMESTAMP'2016-12-01 08:00:00', TIMESTAMP'2016-12-24 22:00:00', 200, 100.50, NULL);
INSERT INTO Admission
VALUES (15, '100-00-0005', TIMESTAMP'2016-12-01 08:00:00', TIMESTAMP'2016-12-24 22:00:00', 200, 100.50, NULL);
INSERT INTO Admission
VALUES (16, '100-00-0007', TIMESTAMP'2016-12-01 08:00:00', TIMESTAMP'2016-12-24 22:00:00', 200, 100.50, NULL);

INSERT INTO Examine
VALUES (7, 2, 'Patient seems to be sick.');
INSERT INTO Examine
VALUES (7, 11, 'Still sick.');
INSERT INTO Examine
VALUES (7, 3, 'Patient has two years to live.');
INSERT INTO Examine
VALUES (7, 0, 'Patient seems to be sick.');
INSERT INTO Examine
VALUES (7, 10, 'Still sick.');
INSERT INTO Examine
VALUES (7, 1, 'Patient has two years to live.');
INSERT INTO Examine
VALUES (7, 4, 'Patient seems to be sick.');
INSERT INTO Examine
VALUES (7, 5, 'Still sick.');
INSERT INTO Examine
VALUES (7, 6, 'Patient has two years to live.');
INSERT INTO Examine
VALUES (7, 7, 'Patient seems to be sick.');
INSERT INTO Examine
VALUES (7, 8, 'Still sick.');
INSERT INTO Examine
VALUES (7, 9, 'Patient has two years to live.');

INSERT INTO Examine
VALUES (5, 0, 'Patient seems perfectly healthy.');
INSERT INTO Examine
VALUES (5, 5, 'I dont even know why this guy is still here...');

INSERT INTO Employee
VALUES (19, 'Bobby', 'Ronacher', 200000, 'general manager', 300, 'gen', NULL);
INSERT INTO Employee
VALUES (20, 'Matt', 'McDonald', 200000, 'general manager', 301, 'gen', NULL);

INSERT INTO Employee
VALUES (10, 'division1', 'last1', 100000, 'division manager', 210, 'div', 19);
INSERT INTO Employee
VALUES (11, 'division2', 'last2', 100000, 'division manager', 211, 'div', 19);
INSERT INTO Employee
VALUES (12, 'division3', 'last3', 100000, 'division manager', 212, 'div', 20);
INSERT INTO Employee
VALUES (13, 'division4', 'last4', 100000, 'division manager', 213, 'div', 20);
INSERT INTO Employee
VALUES (14, 'division5', 'last5', 100000, 'division manager', 214, 'div', 20);

INSERT INTO Employee
VALUES (0, 'first1', 'last1', 60000, 'secretary', 200, 'reg', 10);
INSERT INTO Employee
VALUES (1, 'first2', 'last2', 60000, 'secretary', 201, 'reg', 10);
INSERT INTO Employee
VALUES (2, 'first3', 'last3', 70000, 'IT', 202, 'reg', 11);
INSERT INTO Employee
VALUES (3, 'first4', 'last4', 70000, 'IT', 203, 'reg', 11);
INSERT INTO Employee
VALUES (4, 'first5', 'last5', 50000, 'janitor', 204, 'reg', 12);
INSERT INTO Employee
VALUES (5, 'first6', 'last6', 50000, 'janitor', 205, 'reg', 12);
INSERT INTO Employee
VALUES (6, 'first7', 'last7', 80000, 'nurse', 206, 'reg', 13);
INSERT INTO Employee
VALUES (7, 'first8', 'last8', 80000, 'nurse', 207, 'reg', 13);
INSERT INTO Employee
VALUES (8, 'first9', 'last9', 60000, 'receptionist', 208, 'reg', 14);
INSERT INTO Employee
VALUES (9, 'first10', 'last10', 60000, 'receptionist', 209, 'reg', 14);


INSERT INTO RoomAccess VALUES (100, 19);
INSERT INTO RoomAccess VALUES (101, 19);
INSERT INTO RoomAccess VALUES (102, 19);
INSERT INTO RoomAccess VALUES (103, 19);
INSERT INTO RoomAccess VALUES (104, 19);
INSERT INTO RoomAccess VALUES (105, 19);
INSERT INTO RoomAccess VALUES (106, 19);
INSERT INTO RoomAccess VALUES (107, 19);
INSERT INTO RoomAccess VALUES (108, 19);
INSERT INTO RoomAccess VALUES (109, 19);
INSERT INTO RoomAccess VALUES (100, 20);
INSERT INTO RoomAccess VALUES (101, 20);
INSERT INTO RoomAccess VALUES (102, 20);
INSERT INTO RoomAccess VALUES (103, 20);
INSERT INTO RoomAccess VALUES (104, 20);
INSERT INTO RoomAccess VALUES (105, 20);
INSERT INTO RoomAccess VALUES (106, 20);
INSERT INTO RoomAccess VALUES (107, 20);
INSERT INTO RoomAccess VALUES (108, 20);
INSERT INTO RoomAccess VALUES (109, 20);
INSERT INTO RoomAccess VALUES (100, 10);
INSERT INTO RoomAccess VALUES (101, 10);
INSERT INTO RoomAccess VALUES (102, 10);
INSERT INTO RoomAccess VALUES (103, 11);
INSERT INTO RoomAccess VALUES (104, 11);
INSERT INTO RoomAccess VALUES (105, 11);
INSERT INTO RoomAccess VALUES (106, 12);
INSERT INTO RoomAccess VALUES (107, 12);
INSERT INTO RoomAccess VALUES (108, 12);
INSERT INTO RoomAccess VALUES (105, 13);
INSERT INTO RoomAccess VALUES (104, 13);
INSERT INTO RoomAccess VALUES (103, 13);
INSERT INTO RoomAccess VALUES (102, 14);
INSERT INTO RoomAccess VALUES (101, 14);
INSERT INTO RoomAccess VALUES (100, 14);
INSERT INTO RoomAccess VALUES (100, 0);
INSERT INTO RoomAccess VALUES (101, 1);
INSERT INTO RoomAccess VALUES (102, 2);
INSERT INTO RoomAccess VALUES (103, 3);
INSERT INTO RoomAccess VALUES (104, 4);
INSERT INTO RoomAccess VALUES (105, 5);
INSERT INTO RoomAccess VALUES (106, 6);
INSERT INTO RoomAccess VALUES (107, 7);
INSERT INTO RoomAccess VALUES (108, 8);
INSERT INTO RoomAccess VALUES (109, 9);

INSERT INTO StayIn
VALUES (1, 100, TIMESTAMP'2017-02-10 08:00:00', TIMESTAMP'2017-02-28 08:00:00');
INSERT INTO StayIn
VALUES (5, 106, TIMESTAMP'2017-01-20 12:00:00', TIMESTAMP'2017-02-16 14:00:00');
INSERT INTO StayIn
VALUES (7, 103, TIMESTAMP'2016-01-16 14:00:00', TIMESTAMP'2016-01-17 08:00:00');
INSERT INTO StayIn
VALUES (6, 107, TIMESTAMP'2016-02-16 14:00:00', TIMESTAMP'2016-02-17 08:00:00');
INSERT INTO StayIn
VALUES (6, 103, TIMESTAMP'2016-02-16 14:00:00', TIMESTAMP'2016-02-17 08:00:00');
INSERT INTO StayIn
VALUES (0, 103, TIMESTAMP'2016-01-16 14:00:00', TIMESTAMP'2016-01-17 08:00:00');
INSERT INTO StayIn
VALUES (0, 107, TIMESTAMP'2016-02-16 14:00:00', TIMESTAMP'2016-02-17 08:00:00');
INSERT INTO StayIn
VALUES (1, 103, TIMESTAMP'2016-02-16 14:00:00', TIMESTAMP'2016-02-17 08:00:00');
INSERT INTO StayIn
VALUES (1, 107, TIMESTAMP'2016-01-16 14:00:00', TIMESTAMP'2016-01-17 08:00:00');
INSERT INTO StayIn
VALUES (10, 107, TIMESTAMP'2016-02-16 14:00:00', TIMESTAMP'2016-02-17 08:00:00');
INSERT INTO StayIn
VALUES (10, 103, TIMESTAMP'2016-02-16 14:00:00', TIMESTAMP'2016-02-17 08:00:00');



-- run queries
-- Q1. Report the hospital rooms (the room number) that are currently occupied.
SELECT Num
FROM Room
WHERE occupied='T';

-- Q2. For a given division manager (say, ID = 10), report all regular employees that are supervised by this manager. Display the employees ID, names, and salary
SELECT ID, firstName, lastName, salary
FROM Employee
WHERE supervisorID=10;

-- Q3. For each patient, report the sum of amounts paid by the insurance company for that patient, i.e., report the patients SSN, and the sum of insurance payments over all visits.
SELECT SSN, SUM(insurancePayment) AS totalInsurance
FROM Admission
GROUP BY SSN;

-- Q4. Report the number of visits done for each patient, i.e., for each patient, report the patient SSN, first and last names, and the count of visits done by this patient.
SELECT SSN, firstName, lastName, visits
FROM (
	SELECT SSN, COUNT(Num) as visits
	FROM Admission
	GROUP BY SSN
) NATURAL JOIN PATIENT
ORDER BY SSN;


-- Q5. Report the room number that has an equipment unit with serial number ‘A01-02X’.
SELECT roomNum 
FROM Equipment
WHERE SerialNum='A01-02X';

-- Q6.  Report the employee who has access to the largest number of rooms. We need the employee ID, and the number of rooms (s)he can access.
SELECT employeeID, permissions
FROM (
	SELECT employeeID, COUNT(roomNum) AS permissions
	FROM RoomAccess 
	GROUP BY employeeID
)
WHERE permissions = (SELECT MAX(COUNT(roomNum)) from RoomAccess GROUP BY employeeID);

-- Q7. Report the number of regular employees, division managers, and general managers in the hospital
((SELECT 'Regular Employees' AS Type, COUNT(ID) AS Count
FROM Employee
WHERE employeeRank='reg'
GROUP BY employeeRank)
UNION
(SELECT 'Division Managers' AS Type, COUNT(ID) AS Count
FROM Employee
WHERE employeeRank='div'
GROUP BY employeeRank)
UNION
(SELECT 'General Managers' AS Type, COUNT(ID) AS Count
FROM Employee
WHERE employeeRank='gen'
GROUP BY employeeRank))
ORDER BY Count;

-- Q8. : For patients who have a scheduled future visit (which is part of their most recent visit), report that patient (SSN, and first and last names) and the visit date. Do not report patients who do not have scheduled visit.
SELECT SSN, firstName, lastName
FROM (
	SELECT SSN
	FROM Admission
	WHERE futureVisit IS NOT NULL
) NATURAL JOIN Patient;

-- Q9.  For each equipment type that has more than 3 units, report the equipment type ID, model, and the number of units this type has. 
SELECT typeID, model, count
FROM (
	SELECT typeID, COUNT(SerialNum) AS count
	FROM Equipment
	GROUP BY typeID
) E, EquipmentType T
WHERE E.typeID=T.ID AND count > 3;

-- Q10. Report the date of the coming future visit for patient with SSN = 111-22-333
SELECT MAX(futureVisit) AS nextVisit
FROM Admission
WHERE SSN='111-22-3333';

-- Q11. For patient with SSN = 111-22-3333, report the doctors (only ID) who have examined this patient more than 2 times.
SELECT DocID
FROM (
	SELECT DocID, comments
	FROM Examine E, Admission A
	WHERE E.AdmissionNum = A.num AND A.SSN='111-22-3333'
) GROUP BY DocID
HAVING COUNT(comments) > 2;

-- Q12. Report the equipment types (only the ID) for which the hospital has purchased equipments (units) in both 2010 and 2011. Do not report duplication. 
(SELECT typeID 
FROM Equipment
WHERE purchaseYear=2010)
INTERSECT
(SELECT typeID
FROM Equipment
WHERE purchaseYear=2011);



-- views
DROP VIEW CriticalCases;
DROP VIEW DoctorsLoad;

-- Q1. Create a database view named CriticalCases that selects the patients who have been admitted to Intensive Care Unit (ICU) at least 2 times. The view columns should be: Patient_SSN, firstName, lastName, numberOfAdmissionsToICU.
CREATE VIEW CriticalCases AS
SELECT SSN as Patient_SSN, firstName, lastName, numberOfAdmissionsToICU
FROM (
	SELECT SSN, SUM(ICUPerAdmit) AS numberOfAdmissionsToICU
	FROM (
		SELECT AdmissionNum, COUNT(AdmissionNum) AS ICUPerAdmit
		FROM StayIn NATURAL JOIN RoomService
		WHERE service='ICU'
		GROUP BY AdmissionNum
	) S, Admission A
	WHERE A.Num = S.AdmissionNum
	GROUP BY SSN
) NATURAL JOIN Patient;
SELECT * FROM CriticalCases;

-- Q2. Create a database view named DoctorsLoad that reports for each doctor whether this doctor has an overload or not. A doctor has an overload if (s)he has more than 10 distinct admission cases, otherwise the doctor has an underload. Notice that if a doctor examined a patient multiple times in the same admission, that still counts as one admission case. The view columns should be: DoctorID, gender, load.
CREATE VIEW DoctorsLoad AS
SELECT DocID AS DoctorID, gender, 
	case	
		when Cases > 10 then 'Overloaded'
		else 'Underloaded'
	end AS load
FROM (
	SELECT DocID, COUNT(AdmissionNum) AS Cases
	FROM Examine
	GROUP BY DocID
) S, Doctor D
WHERE S.DocID = D.ID;
SELECT * FROM DoctorsLoad;

-- Q3. Use the views created above (you may need the original tables as well) to report the critical-case patients with number of admissions to ICU greater than 4.
SELECT *
FROM CriticalCases
WHERE numberOfAdmissionsToICU > 4;

-- Q4. Use the views created above (you may need the original tables as well) to report the female overloaded doctors. You should report the doctor ID, firstName, and lastName
SELECT DoctorID, firstName, lastName
FROM DoctorsLoad L, Doctor D
WHERE D.ID = L.DoctorID
AND L.gender = 'F';

-- Q5. Use the views created above (you may need the original tables as well) to report the comments inserted by underloaded doctors when examining critical-case patients. You should report the doctor Id, patient SSN, and the comment.
SELECT SSN, DoctorID, comments
FROM (
	SELECT SSN, DoctorID, comments
	FROM (
		SELECT *
		FROM DoctorsLoad L, Examine E
		WHERE L.DoctorID = E.DocID
		AND L.load = 'Underloaded'
	) S, Admission A
	WHERE S.AdmissionNum = A.Num
) S, CriticalCases C
WHERE S.SSN = C.Patient_SSN;


-- Triggers 
-- Q1. Any room in the hospital cannot offer more than three services
CREATE TRIGGER RoomServiceTrigger
	AFTER INSERT OR UPDATE ON RoomService
DECLARE 
	CURSOR C1 IS SELECT RoomNum FROM RoomService HAVING COUNT(SERVICE) > 3 GROUP BY RoomNum;
BEGIN
	FOR rec IN C1 LOOP
		RAISE_APPLICATION_ERROR(-20004, 'Too many services!');
	END LOOP;
END;
/

--INSERT INTO RoomService VALUES (100, 'test');
--INSERT INTO RoomService VALUES (100, 'This should fail!');



-- Q3. Ensure that regular employees (with rank 0) must have their supervisors as division managers (with rank 1). Also each regular employee must have a supervisor at all times. 
-- Q4. Similarly, division managers (with rank 1) must have their supervisors as general managers (with rank 2). Division managers must have supervisors at all times
CREATE TRIGGER EmployeeTrigger
	BEFORE INSERT OR UPDATE ON Employee
	FOR EACH ROW
DECLARE
	superRank varchar2(3);
BEGIN
	IF :new.supervisorID = NULL AND :new.employeeRank != 'gen' THEN
		RAISE_APPLICATION_ERROR(-20004, 'Invalid supervisor');
	END IF;
	
	IF :new.employeeRank = 'reg' THEN
		SELECT employeeRank into superRank
		FROM Employee
		WHERE ID = :new.supervisorID;
		
		IF superRank != 'div' THEN
			RAISE_APPLICATION_ERROR(-20004, 'Regular employees must be supervised by a division manager.');
		END IF;
	END IF;
	
	IF :new.employeeRank = 'div' THEN
		SELECT employeeRank into superRank
		FROM Employee
		WHERE ID = :new.supervisorID;
		
		IF superRank != 'gen' THEN
			RAISE_APPLICATION_ERROR(-20004, 'Division managers must be supervised by a general manager.');
		END IF;
	END IF;
	
	IF :new.employeeRank = 'gen' THEN
		IF :new.supervisorID != NULL THEN
			RAISE_APPLICATION_ERROR(-20004, 'General managers must be unsupervised.');
		END IF;
	END IF;
END;
/

-- Q5. When a patient is admitted to ICU room on date D, the futureVisitDate should be automatically set to 3 months after that date, i.e., D + 3 months. The futureVisitDate may be manually changed later, but when the ICU admission happens, the date should be set to default as mentioned above.
CREATE TRIGGER StayInTrigger
	BEFORE INSERT ON StayIn
	FOR EACH ROW
DECLARE
	newDate timestamp;
	CURSOR C1 IS SELECT RoomNum FROM RoomService WHERE service = 'ICU';
BEGIN
	FOR rec IN C1 LOOP
		IF rec.RoomNum = :new.RoomNum THEN
			newDate := :new.startDate + INTERVAL '2' MONTH;
		
			UPDATE Admission
			SET futureVisit = newDate
			WHERE Num = :new.AdmissionNum;
		END IF;
	END LOOP;
	
END;
/

-- Q6. If an equipment of type ‘MRI’, then the purchase year must be not null and after 2005.
CREATE TRIGGER EquipmentTrigger
	BEFORE INSERT OR UPDATE ON Equipment
	FOR EACH ROW
DECLARE
	mriID integer;
BEGIN
	 SELECT ID INTO mriID
	 FROM EquipmentType 
	 WHERE Description='MRI';
	 
	IF :new.TypeID = mriID THEN
		IF :new.PurchaseYear = NULL OR :new.PurchaseYear <= 2005 THEN
			RAISE_APPLICATION_ERROR(-20004, 'Invalid MRI purchase year');
		END IF;
	END IF;
END;
/	



-- Q2. The insurance payment should be calculated automatically as 70% of the total payment. If the total payment changes then the insurance amount should also change.
-- Q7. When a patient is admitted to the hospital, i.e., a new record is inserted into the Admission table; the system should print out the names of the doctors who previously examined this patient (if any).
CREATE TRIGGER AdmissionTrigger
	BEFORE INSERT OR UPDATE ON Admission
	FOR EACH ROW
DECLARE
	cursor admits (patssn char) IS SELECT Num FROM Admission WHERE SSN=patssn;
	cursor doctors (adnum int) IS SELECT DocID FROM Examine WHERE AdmissionNum=adnum;
	fName varchar2(20);
	lName varchar2(20);
BEGIN
	:new.insurancePayment := 0.7 * :new.totalPayment;
	
	IF inserting THEN
		dbms_output.put_line('Doctors that have helped this patient previously:');
		FOR rec IN admits(:new.SSN) LOOP
			FOR rec2 IN doctors(rec.num) LOOP
				SELECT firstName, lastName INTO fName, lName
				FROM Doctor
				WHERE ID = rec2.DocID;
		
				
				dbms_output.put_line(fName || ' ' || lName);
			END LOOP;
		END LOOP;
	END IF;
END;
/

--INSERT INTO Admission VALUES (30, '111-22-3333', TIMESTAMP'2016-01-01 01:01:01', TIMESTAMP'2016-02-02 01:01:01', 200, 100, TIMESTAMP'2016-01-01 01:01:01');