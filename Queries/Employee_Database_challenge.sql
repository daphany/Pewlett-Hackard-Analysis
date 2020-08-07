--Deliverable 1 
--Create retirement_title table
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	t.title,
	t.from_date,
	t.to_date
INTO retirement_titles
FROM employees as e
    LEFT JOIN title as t
    ON (e.emp_no = t.emp_no)
WHERE e.birth_date BETWEEN '1952-01-01' AND '1955-12-31'
ORDER BY e.emp_no;

-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (emp_no) rt.emp_no,
rt.first_name,
rt.last_name,
rt.title
INTO unique_titles
FROM retirement_titles as rt
ORDER BY
	rt.emp_no ASC,
	(rt.to_date, rt.title) DESC;
	
--retrieve the number of employees by their most recent job title who are about to retire.
SELECT
    COUNT(ut.title),
	ut.title
INTO retiring_titles	
FROM unique_titles as ut
GROUP BY ut.title
ORDER BY COUNT(ut.title) DESC;

SELECT * FROM retiring_titles;

--Deliverable 2

SELECT
	DISTINCT ON (emp_no) e.emp_no,
	e.first_name,
	e.last_name,
	e.birth_date,
	de.from_date,
	de.to_date,
	t.title
INTO mentorship_eligibility
FROM employees as e
	LEFT JOIN dept_emp as de
	ON e.emp_no = de.emp_no
	LEFT JOIN title as t
	ON e.emp_no = t.emp_no
WHERE (de.to_date = '9999-01-01')
AND (birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY
	e.emp_no ASC;

SELECT * FROM mentorship_eligibility;

---experiment

SELECT
rt.title,
rt.count,
mt.count

FROM retiring_titles as rt
LEFT JOIN mentorship_titles as mt
ON rt.title = mt.title
ORDER BY rt.count DESC;

--Create combined table wit percentage by title
CREATE TABLE combined AS
SELECT rt.title, rt.count as rt_count, mt.count2 as mt_count2, round(((nullif(mt.count2 * 1.0, 0) / (rt.count))) * 100, 2) AS percentage
FROM retiring_titles as rt
FULL JOIN mentorship_titles as mt 
ON rt.title = mt.title
GROUP BY rt.count, rt.title, mt.count2
ORDER BY rt.count DESC;

SELECT * FROM combined;
