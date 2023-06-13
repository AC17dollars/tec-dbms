-- 1
CREATE TABLE
    tbl_Employee (
        employee_name VARCHAR(255) NOT NULL,
        street VARCHAR(255) NOT NULL,
        city VARCHAR(255) NOT NULL,
        PRIMARY KEY(employee_name)
);
 
CREATE TABLE
    tbl_Works (
        employee_name VARCHAR(255) NOT NULL,
        FOREIGN KEY (employee_name) REFERENCES tbl_Employee(employee_name),
        company_name VARCHAR(255),
        salary DECIMAL(10, 2)
);
 
CREATE TABLE
    tbl_Company (
        company_name VARCHAR(255) NOT NULL,
        city VARCHAR(255),
        PRIMARY KEY(company_name)
);
 
CREATE TABLE
    tbl_Manages (
        employee_name VARCHAR(255) NOT NULL,
        FOREIGN KEY (employee_name) REFERENCES tbl_Employee(employee_name),
        manager_name VARCHAR(255)
    );
 
INSERT INTO
    tbl_Employee (employee_name, street, city)
VALUES (
        'Alice Williams',
        '321 Maple St',
        'Houston'
    ), (
        'Sara Davis',
        '159 Broadway',
        'New York'
    ), (
        'Mark Thompson',
        '235 Fifth Ave',
        'New York'
    ), (
        'Ashley Johnson',
        '876 Market St',
        'Chicago'
    ), (
        'Emily Williams',
        '741 First St',
        'Los Angeles'
    ), (
        'Michael Brown',
        '902 Main St',
        'Houston'
    ), (
        'Samantha Smith',
        '111 Second St',
        'Chicago'
    ), (
        'Patrick',
        '123 Main St',
        'New Mexico'
    );
 
INSERT INTO
    tbl_Works (
        employee_name,
        company_name,
        salary
    )
VALUES (
        'Sara Davis',
        'First Bank Corporation',
        82500.00
    ), (
        'Mark Thompson',
        'Small Bank Corporation',
        78000.00
    ), (
        'Ashley Johnson',
        'Small Bank Corporation',
        92000.00
    ), (
        'Emily Williams',
        'Small Bank Corporation',
        86500.00
    ), (
        'Michael Brown',
        'Small Bank Corporation',
        81000.00
    ), (
        'Samantha Smith',
        'Small Bank Corporation',
        77000.00
    ), (
        'Patrick',
        'Pongyang Corporation',
        500000
    );
 INSERT INTO tbl_Works
 VALUES
 (
        'Mark Thompson',
        'Small Bank Corporation',
        78000.00
    ), (
        'Ashley Johnson',
        'Small Bank Corporation',
        92000.00
    ), (
        'Emily Williams',
        'Small Bank Corporation',
        86500.00
    ), (
        'Michael Brown',
        'Small Bank Corporation',
        81000.00
    ), (
        'Samantha Smith',
        'Small Bank Corporation',
        77000.00
    );
INSERT INTO
    tbl_Company (company_name, city)
VALUES (
        'Small Bank Corporation', 'Chicago'), 
        ('ABC Inc', 'Los Angeles'), 
        ('Def Co', 'Houston'), 
        ('First Bank Corporation','New York'), 
        ('456 Corp', 'Chicago'), 
        ('789 Inc', 'Los Angeles'), 
        ('321 Co', 'Houston'),
        ('Pongyang Corporation','Chicago'
    );
 
INSERT INTO
    tbl_Manages(employee_name, manager_name)
VALUES 
    ('Mark Thompson', 'Emily Williams'),
    ('Michael Brown', 'Ashley Johnson'),
    ('Alice Williams', 'Emily Williams'),
    ('Samantha Smith', 'Sara Davis'),
    ('Patrick', 'Ashley Johnson');
   
INSERT INTO tbl_Employee
VALUES ('Persia Douglas', '559 Cow Street', 'Washington'),
		('Alice Chains', '559 Cow Street', 'Washington');
	
INSERT INTO tbl_Works 
VALUES ('Persia Douglas', 'First Bank Corporation', 76000), ('Alice Chains', 'First Bank Corporation', 87000);

INSERT INTO tbl_Manages
VALUES ('Persia Douglas', 'Alice Chains');

ALTER TABLE tbl_Works
ADD FOREIGN KEY (company_name) REFERENCES tbl_Company(company_name);

SELECT * FROM tbl_Employee;
SELECT * FROM tbl_Works;
SELECT * FROM tbl_Manages;



-- 2
--  a
SELECT te.employee_name FROM tbl_Employee te
INNER JOIN tbl_Works tw ON te.employee_name = tw.employee_name AND tw.company_name = 'First Bank Corporation';

--  b
SELECT te.employee_name, te.city from tbl_Employee te
INNER JOIN tbl_Works tw ON te.employee_name = tw.employee_name AND tw.company_name = 'First Bank Corporation';

--  c
SELECT te.employee_name, te.street, te.city from tbl_Employee te
INNER JOIN tbl_Works tw ON te.employee_name = tw.employee_name AND tw.company_name = 'First Bank Corporation' AND tw.salary > 10000;

--  d
SELECT te.employee_name FROM tbl_Employee te
INNER JOIN tbl_Works tw ON te.employee_name = tw.employee_name
INNER JOIN tbl_Company tc ON tw.company_name = tc.company_name AND te.city = tc.city;

--  e
-- Employee who lives in the same city as manager
-- Since manager is also an employee but he doesn't have a manager ( he himself is a manager ) don't show manager.
SELECT employee_name FROM (SELECT te.employee_name, te.city, tm.manager_name, (SELECT te2.city FROM tbl_Employee te2 WHERE te2.employee_name = tm.manager_name ) AS m_city
							FROM tbl_Employee te 
							INNER JOIN tbl_Manages tm ON te.employee_name = tm.employee_name) tx
WHERE tx.m_city = tx.city;

SELECT te.employee_name, tm.manager_name, te.city FROM tbl_Manages tm
INNER JOIN tbl_Employee te ON tm.employee_name = te.employee_name
AND te.city = (SELECT city from tbl_Employee te2 WHERE te2.employee_name = tm.manager_name);

--  f
SELECT te.employee_name FROM tbl_Employee te 
INNER JOIN tbl_Works tw ON te.employee_name = tw.employee_name AND tw.company_name <> 'First Bank Corporation';

--  g
SELECT te.employee_name FROM tbl_Employee te 
INNER JOIN tbl_Works tw ON tw.employee_name = te.employee_name 
INNER JOIN tbl_Company tc ON tc.company_name = tw.company_name
AND tw.salary > (SELECT MAX(salary) FROM tbl_Works twks
WHERE twks.company_name = 'Small Bank Corporation'
GROUP BY twks.company_name);

-- h
SELECT tc.company_name FROM tbl_Company tc
WHERE tc.city IN (SELECT city FROM tbl_Company WHERE company_name='Small Bank Corporation') AND tc.company_name <> 'Small Bank Corporation';

-- i 
SELECT te.employee_name, tw.salary  FROM tbl_Employee te
INNER JOIN tbl_Works tw ON tw.employee_name = te.employee_name AND tw.salary >
		(SELECT AVG(salary) FROM tbl_Works twks
		WHERE twks.company_name = tw.company_name 
		GROUP BY twks.company_name);

--  j
SELECT TOP 1 tw.company_name, COUNT(tw.employee_name) AS 'count' FROM tbl_Works tw 
GROUP BY tw.company_name
ORDER BY 'count' DESC;

SELECT twks.company_name FROM (SELECT tw.company_name, COUNT(tw.company_name) AS "Employee Count" FROM tbl_Works tw
GROUP BY tw.company_name) AS twks
WHERE twks."Employee Count" = (SELECT MAX(temp."Employee Count") FROM (SELECT tmp.company_name, COUNT(tmp.company_name) AS "Employee Count" FROM tbl_Works tmp
GROUP BY tmp.company_name) temp);

--  k
SELECT TOP 1 tw.company_name, SUM(tw.salary) AS payroll FROM tbl_Works tw 
GROUP BY tw.company_name
ORDER BY payroll ASC;

-- l
SELECT company_name, avg_salary FROM (SELECT tw.company_name, AVG(tw.salary) AS avg_salary
									FROM tbl_Works tw 
									GROUP BY tw.company_name) AS temp
WHERE temp.avg_salary > (SELECT AVG(tmp.salary) FROM tbl_Works tmp WHERE tmp.company_name='First Bank Corporation');


-- 3
--  a
UPDATE tbl_Employee 
SET city = 'Newton'
WHERE employee_name = 'Persia Douglas';

--  b
UPDATE tbl_Works
SET salary = salary + (0.1 * salary)
WHERE company_name = 'First Bank Corporation';

--  c
UPDATE tbl_Works 
SET salary = salary + (0.1 * salary)
WHERE employee_name IN
		(SELECT manager_name FROM tbl_Manages WHERE manager_name IN
				(SELECT employee_name from tbl_Works WHERE company_name = 'First Bank Corporation'));


-- d 
UPDATE tbl_Works
SET salary = CASE 
	WHEN (salary + (0.1 * salary)) > 100000 THEN (salary + (0.03 * salary))
	ELSE (salary + (0.1 * salary))
END
WHERE employee_name IN
		(SELECT manager_name FROM tbl_Manages WHERE manager_name IN
				(SELECT employee_name from tbl_Works WHERE company_name = 'First Bank Corporation'));

--  e
DELETE FROM tbl_Works
WHERE company_name = 'Small Bank Corporation';


