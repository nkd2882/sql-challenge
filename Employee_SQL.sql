-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.


CREATE TABLE "salaries" (
    "emp_no" CHAR(10)   NOT NULL,
    "salary" FLOAT   NOT NULL,
    CONSTRAINT "pk_salaries" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "employees" (
    "emp_no" CHAR(10)   NOT NULL,
    "emp_title_id" CHAR(10)   NOT NULL,
    "birth_date" VARCHAR(50)   NOT NULL,
    "first_name" VARCHAR(50)   NOT NULL,
    "last_name" VARCHAR(50)   NOT NULL,
    "sex" VARCHAR(50)   NOT NULL,
    "hire_date" VARCHAR(50)   NOT NULL,
    CONSTRAINT "pk_employees" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "titles" (
    "title_id" CHAR(10)   NOT NULL,
    "title" VARCHAR(50)   NOT NULL,
    CONSTRAINT "pk_titles" PRIMARY KEY (
        "title_id"
     )
);

CREATE TABLE "dept_emp" (
    "emp_no" CHAR(10)   NOT NULL,
    "dept_no" CHAR(10)   NOT NULL
);

CREATE TABLE "departments" (
    "dept_no" CHAR(10)   NOT NULL,
    "dept_name" VARCHAR(50)   NOT NULL,
    CONSTRAINT "pk_departments" PRIMARY KEY (
        "dept_no"
     )
);

CREATE TABLE "dept_manager" (
    "dept_no" CHAR(10)   NOT NULL,
    "emp_no" CHAR(10)   NOT NULL
);

ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "employees" ADD CONSTRAINT "fk_employees_emp_title_id" FOREIGN KEY("emp_title_id")
REFERENCES "titles" ("title_id");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

SELECT * FROM titles;

SELECT * FROM departments;

SELECT * FROM employees;

SELECT * FROM dept_emp;

SELECT * FROM dept_manager;


--1. List the employee number, last name, first name, sex, 
--and salary of each employee.

SELECT e.emp_no,
    e.last_name,
    e.first_name,
    e.sex,
    s.salary
FROM employees AS e
JOIN salaries AS s
ON e.emp_no = s.emp_no;

--2. List the first name, last name, and hire date for the employees 
--who were hired in 1986.

SELECT first_name,
    last_name,
    hire_date
FROM employees
WHERE 
    YEAR (hire_date) = 1986;

--3. List the manager of each department along with their department number, 
--department name, employee number, last name, and first name.

SELECT d.dept_no,
       d.dept_name,
       e.emp_no,
       e.last_name,
       e.first_name
FROM departments AS d
JOIN dept_emp AS de
ON d.dept_no = de.dept_no
JOIN employees AS e
ON e.emp_no = de.emp_no
JOIN titles
ON e.emp_title_id = titles.title_id
WHERE titles.title = 'Manager';

-- Using SUBQUERY

SELECT d.dept_no,
       d.dept_name,
       e.emp_no,
       e.last_name,
       e.first_name
FROM departments AS d
JOIN dept_emp AS de
ON d.dept_no = de.dept_no
JOIN (
    SELECT e.emp_no,
           e.last_name,
           e.first_name,
           e.emp_title_id
    FROM employees AS e
    JOIN titles AS t
    ON e.emp_title_id = t.title_id
    WHERE t.title = 'Manager'
) AS e
ON de.emp_no = e.emp_no;

SELECT * FROM titles WHERE title = 'manager';

--4.List the department number for each employee along with 
--that employee’s employee number, last name, first name, and department name.

SELECT d.dept_no,
	   e.emp_no,
	   e.last_name,
	   e.first_name,
	   d.dept_name
FROM employees AS e
JOIN dept_emp as de
ON e.emp_no = de.emp_no
JOIN departments AS d
ON d.dept_no = de.dept_no;

--5. List first name, last name, and sex of each employee 
--whose first name is Hercules and whose last name begins 
--with the letter B.
	   

SELECT first_name,
       last_name,
       sex
FROM employees
WHERE first_name = 'Hercules'
    AND last_name LIKE 'B%';

--6. List each employee in the Sales department, 
--including their employee number, last name, and first name.

SELECT * FROM departments
WHERE dept_name = 'Sales'
OR dept_name = 'Development'; 

SELECT e.emp_no,
       e.last_name,
	   e.first_name
FROM employees AS e
JOIN dept_emp as de
ON e.emp_no = de.emp_no
JOIN departments AS d
ON d.dept_no = de.dept_no
WHERE d.dept_name = 'Sales';

--7. List each employee in the Sales and Development departments, 
--including their employee number, last name, first name, and department name.

SELECT e.emp_no,
       e.last_name,
	   e.first_name,
	   d.dept_name
FROM employees AS e
JOIN dept_emp as de
ON e.emp_no = de.emp_no
JOIN departments AS d
ON d.dept_no = de.dept_no
WHERE d.dept_name = 'Sales'
OR d.dept_name = 'Development';

--8. List the frequency counts, in descending order, 
--of all the employee last names (that is, how many employees 
--share each last name).

SELECT last_name,
	   COUNT(*) AS frequency 
FROM employees 
GROUP BY last_name
ORDER BY frequency DESC;
