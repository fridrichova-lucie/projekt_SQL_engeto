-- Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin 
-- či mzdách ve stejném nebo následujícím roce výraznějším růstem?

-- Interpretace, nejsem ekonom, abych mohla dobře interpretovat, ale předpokládám, že když nám jeden rok vzroste HDP, tak by to mohlo mít pozitivní
-- vliv v následujícím roce na zvýšení mezd a snížení cen? 
-- Tabulky bych na interpretaci nechala ekonomům, každopádně tam přímou úměru nevidím, takže by se zdálo, že nemá.

-- VÝSLEDEK:
-- 1.vytvořím pohled pro porovnání cen a mezd 
CREATE OR REPLACE VIEW v_lucie_fridrichova_price_payroll AS
	SELECT DISTINCT 
		pf.in_year AS FIRST_year_pp
		, pf2.in_year AS NEXT_year_pp
		, round(avg(pf2.avg_price_year) / avg(pf.avg_price_year) * 100 - 100,2) AS price_percentage
		, round(avg(pf2.avg_payroll_year) / avg(pf.avg_payroll_year) * 100 - 100,2) AS payroll_percentage
	FROM t_lucie_fridrichova_project_sql_primary_final pf 
	JOIN t_lucie_fridrichova_project_sql_primary_final pf2
		ON pf.in_year = pf2.in_year - 1
		AND pf.category_code = pf2.category_code
	GROUP BY pf.in_year;

-- 2.vytvořím pohled pro porovnání HDP
CREATE OR REPLACE VIEW v_lucie_fridrichova_GDP AS
	SELECT 
		e.`year` AS first_year_gdp
		, e2.`year` AS next_year_gdp 
		, round(e2.GDP / e.GDP * 100 - 100,2) AS GDP_different
	FROM economies e 
	JOIN economies e2 
		ON e.`year` = e2.`year` - 1
		AND e.country = e2.country
	WHERE e.country LIKE 'Czech Republic'
		AND e.year BETWEEN 2006 AND 2018
	ORDER BY e.`year`;

-- 3.výsledná tabulka, kdy porovnávám stejná období
SELECT
	g.first_year_gdp AS first_year
	, g.next_year_gdp AS next_year
	, g.gdp_different
	, pp.payroll_percentage
	, pp.price_percentage 
FROM v_lucie_fridrichova_gdp g
JOIN v_lucie_fridrichova_price_payroll pp
	ON g.first_year_gdp = pp.first_year_pp;

-- 4.výsledná tabulka, kdy se ukazuje jak změna HDP měla vliv na stav průměrné ceny a průměrné mdzy v následujícím roce
SELECT
	g.first_year_gdp AS GDP_year
	, g.next_year_gdp AS GDP2_year
	, g.gdp_different
	, pp.FIRST_year_pp AS pp_year
	, pp.NEXT_year_pp AS pp2_year
	, pp.payroll_percentage AS payroll_diff
	, pp.price_percentage AS price_diff
FROM v_lucie_fridrichova_gdp g
JOIN v_lucie_fridrichova_price_payroll pp
	ON g.first_year_gdp = pp.first_year_pp - 1
	AND g.next_year_gdp = pp.FIRST_year_pp;

-- postup, pomocné, ostatní:

SELECT *
FROM v_lucie_fridrichova_price_payroll pp;

SELECT *
FROM v_lucie_fridrichova_gdp g;

-- provnání roků = percentuální nárůst s přepočteným GDP na hlavu = průměr, prý není potřeba
SELECT
	e.`year` AS first_year
	, e2.`year` AS next_year
	, round((e2.gdp / e2.population) / (e.gdp / e.population) * 100 - 100,2) AS GDP_different
FROM economies e 
JOIN economies e2 
	ON e.`year` = e2.`year` - 1
	AND e.country = e2.country
WHERE e.country LIKE 'Czech Republic'
	AND e.year BETWEEN 2006 AND 2018
ORDER BY e.`year`;


SELECT 
	country 	
	, `year` 
	, GDP 
FROM economies e
WHERE country = 'Czech Republic'
	AND YEAR BETWEEN 2006 AND 2018
ORDER BY year;