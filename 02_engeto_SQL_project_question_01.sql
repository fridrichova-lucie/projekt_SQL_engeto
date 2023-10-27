-- question 1: Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

SELECT *
FROM t_lucie_fridrichova_project_sql_primary_final pf;

SELECT
	ib_code,
	ib_name,
	avg_payroll_year, 
	payroll_year 
FROM t_lucie_fridrichova_project_sql_primary_final pf 
WHERE payroll_year = '2006'
GROUP BY ib_code, ib_name, payroll_year;
