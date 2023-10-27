-- question 1: Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

SELECT *
FROM t_lucie_fridrichova_project_sql_primary_final pf;

SELECT
	ib_code,
	ib_name,
	avg(CASE WHEN in_year = 2006 THEN avg_payroll_year END) AS payroll_2006,
	avg(CASE WHEN in_year = 2007 THEN avg_payroll_year END) AS payroll_2007,
	(avg(CASE WHEN in_year = 2007 THEN avg_payroll_year END) - avg(CASE WHEN in_year = 2006 THEN avg_payroll_year END)) / avg(CASE WHEN in_year = 2006 THEN avg_payroll_year END) * 100 AS pokus
FROM t_lucie_fridrichova_project_sql_primary_final pf 
WHERE in_year IN ('2006','2007')
GROUP BY ib_name, ib_code;

SELECT 
	pf.ib_code,
	pf.ib_name, 
	pf.in_year,
	pf.avg_payroll_year,
	pf2.in_year,
	pf2.avg_payroll_year 
FROM t_lucie_fridrichova_project_sql_primary_final pf
JOIN t_lucie_fridrichova_project_sql_primary_final pf2
	ON pf.in_year = pf2.in_year -1
	AND pf.ib_code = pf2.ib_code;
	
SELECT DISTINCT e.year, e2.year,
	e.population, e2.population, e.country
FROM economies e
JOIN economies e2
	ON e.`year` = e2.`year` - 1
	AND e.country = e2.country
	
