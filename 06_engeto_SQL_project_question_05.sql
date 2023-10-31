-- Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin 
-- či mzdách ve stejném nebo následujícím roce výraznějším růstem?

-- vytvořím pohled pro porovnání cen a mezd 

CREATE VIEW v_lucie_fridrichova_price_payroll AS
	SELECT DISTINCT 
		pf.in_year AS FIRST_year,
		pf2.in_year AS NEXT_year,
		ROUND(AVG(pf2.avg_price_year) / AVG(pf.avg_price_year) *100 -100,2) AS price_percentage,
		ROUND(AVG(pf2.avg_payroll_year) / AVG(pf.avg_payroll_year) *100 -100,2) AS payroll_percentage,
		ROUND(AVG(pf2.avg_payroll_year) / AVG(pf.avg_payroll_year) *100 -100,2) - ROUND(AVG(pf2.avg_price_year) / AVG(pf.avg_price_year) *100 -100,2) AS different
	FROM t_lucie_fridrichova_project_sql_primary_final pf 
	JOIN t_lucie_fridrichova_project_sql_primary_final pf2
		ON pf.in_year = pf2.in_year -1
		AND pf.category_code = pf2.category_code
	GROUP BY pf.in_year;

-- vytvořím pohled pro porovnání HDP
CREATE OR REPLACE VIEW v_lucie_fridrichova_GDP AS
	SELECT 
		e.`year` AS first_year,
		e2.`year` AS next_year, 
		round((e2.gdp / e2.population) / (e.gdp / e.population) * 100 - 100,2) AS GDP_different
	FROM economies e 
	JOIN economies e2 
		ON e.`year` = e2.`year` - 1
		AND e.country = e2.country
	WHERE e.country LIKE 'Czech Republic'
		AND e.year BETWEEN 2006 AND 2018
	ORDER BY e.`year`;

-- jdeme spojovat

SELECT
	g.first_year,
	g.next_year,
	g.gdp_different,
	pp.different
FROM v_lucie_fridrichova_gdp g
JOIN v_lucie_fridrichova_price_payroll pp
	ON g.first_year = pp.FIRST_year 
	AND g.next_year = pp.NEXT_year;


-- bez průměru HDP
SELECT 
	e.`year`,
	e2.`year`, 
	e.gdp,
	e2.gdp,
	round(e2.gdp / e.gdp * 100 - 100,2) AS pokus
FROM economies e 
JOIN economies e2 
	ON e.`year` = e2.`year` - 1
	AND e.country = e2.country
WHERE e.country LIKE 'Czech Republic'
	AND e.year BETWEEN 2006 AND 2018
ORDER BY e.`year`;

