-- Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
-- Jak je otázka myšlena, byl meziroční nárůst cen potravin větší než 10% nebo zda byl nárůst cen větší o více než 10% než nárůst cen mezd, 
-- naštěstí v obou případech nebyl.

-- výsledná tabulka:
SELECT DISTINCT 
	pf.in_year
	, pf2.in_year AS in_year_next
	, round(avg(pf2.avg_price_year) / avg(pf.avg_price_year) * 100 - 100,2) AS price_percentage
	, round(avg(pf2.avg_payroll_year) / avg(pf.avg_payroll_year) * 100 - 100,2) AS payroll_percentage
	, ROUND(AVG(pf2.avg_payroll_year) / AVG(pf.avg_payroll_year) * 100 - 100,2) - round(avg(pf2.avg_price_year) / avg(pf.avg_price_year) * 100 - 100,2) AS different
FROM t_lucie_fridrichova_project_sql_primary_final pf 
JOIN t_lucie_fridrichova_project_sql_primary_final pf2
	ON pf.in_year = pf2.in_year - 1
	AND pf.category_code = pf2.category_code
GROUP BY pf.in_year;

-- kompletní příkaz
SELECT DISTINCT 
	pf.in_year
	, pf2.in_year
	, round(avg(pf.avg_price_year),2) AS avg_price_all
	, round(avg(pf2.avg_price_year),2) AS avg_price_all
	, round(avg(pf.avg_payroll_year)) AS avg_payroll_all
	, round(avg(pf2.avg_payroll_year)) AS avg_payroll_all
	, round(avg(pf2.avg_price_year) / avg(pf.avg_price_year) * 100 - 100,2) AS price_percentage
	, round(avg(pf2.avg_payroll_year) / avg(pf.avg_payroll_year) * 100 - 100,2) AS payroll_percentage
FROM t_lucie_fridrichova_project_sql_primary_final pf 
JOIN t_lucie_fridrichova_project_sql_primary_final pf2
	ON pf.in_year = pf2.in_year - 1
	AND pf.category_code = pf2.category_code
GROUP BY pf.in_year;