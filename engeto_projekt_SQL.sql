-- Zjišťování časového období
-- czechia_payroll: v payroll_year a payroll_quarter nějaká hodnota nulová?
SELECT *
FROM czechia_payroll --
WHERE payroll_quarter IS NULL; -- žádná hodnota není nulová 

-- czechia_payroll: min a max roku
SELECT 
	min(payroll_year),
	max(payroll_year)
FROM czechia_payroll; -- rok 2000 až 2021

SELECT 	
	DISTINCT payroll_year -- i pro quarter 
FROM czechia_payroll
ORDER BY payroll_year; -- prověření, zda není nějaké nevyhovující hodnota, překlep, datavý typ není date, ale int(11)


-- czechia_price: je v date_from a date_to nějaká hodnota nulová?
SELECT *
FROM czechia_price  
WHERE date_from IS NULL
	OR date_to IS NULL; -- žádná hodnota není nulová 
	
-- czechia_price: min a max roku
SELECT 
	min(YEAR(date_from)),
	max(YEAR(date_from)),
	min(YEAR(date_to)),
	max(YEAR(date_to))
FROM czechia_price; -- rok 2006 až 2018
-- jelikož je datový typ definován datetime nemůže zde být nevyhovující hodnota

-- czechia_price: je k dispozici měření za celý rok 2006 a za celý rok 2018? 
SELECT 
	date_from
FROM czechia_price
WHERE YEAR(date_from) = 2006
ORDER BY date_from;

SELECT 
	date_to
FROM czechia_price
WHERE YEAR(date_to) LIKE 2018
ORDER BY date_to DESC; -- ano můžu počítat celé roky 2006 a 2018

-- economies: je nějaká hodnota nulová?
SELECT *
FROM economies 
WHERE year IS NULL; -- žádná hodnota není nulová 

-- min a max roku
SELECT 
	min(year),
	max(year)
FROM economies; -- rok 1960 až 2020

-- HDP pro CZ v letech 2006 až 2018
SELECT 
	country,
	YEAR,
	GDP
FROM economies
WHERE country LIKE 'Cz%'
	AND year BETWEEN 2006 AND 2018
ORDER BY YEAR

-- Specifikace mezd:
-- value_type 5958 mzda + unit 200 Kč + calculation 200 přepočtená za plný úvazek

SELECT *
FROM czechia_payroll cp 	
WHERE cp.value_type_code = '5958'
	AND cp.unit_code = '200'
	AND cp.calculation_code = '200'
	AND industry_branch_code = 'A'
	AND payroll_year = '2006';

-- spojím price s name of category
-- ??!! ještě zprůměruj na roční ceny
SELECT 
	cp.category_code,
	cpc.name AS name_category,
	cp.value AS value_category,
	date_format(cp.date_from, '%Y-%m-%d') AS date_from,
	date_format(cp.date_to, '%Y-%m-%d') AS date_to
FROM czechia_price cp 
JOIN czechia_price_category cpc 
	ON cp.category_code = cpc.code
ORDER BY cp.category_code, date_from;

-- spojím payroll s name of industry_branch -- pozor musíš omezit na roky 2006 -2018
-- czechia_payroll: 19 branch * 13 let * 4 roční období = 988 řádků / odstranila jsem NULL hodnoty

SELECT
	cp.industry_branch_code,
	cp.value,
	cp.payroll_year,
	cp.payroll_quarter 
FROM czechia_payroll cp 
WHERE cp.value_type_code = 5958
	AND cp.unit_code = 200
	AND cp.calculation_code = 200
	AND cp.industry_branch_code IS NOT NULL
	AND payroll_year BETWEEN 2006 AND 2018
ORDER BY cp.industry_branch_code, cp.payroll_year, cp.payroll_quarter -- 988 řádků

-- musím ověřit, zda jsou pro každý branch všechny hodnoty?
SELECT
	cp.industry_branch_code,
	cp.value,
	cp.payroll_year,
	cp.payroll_quarter 
FROM czechia_payroll cp 
WHERE cp.value_type_code = 5958
	AND cp.unit_code = 200
	AND cp.calculation_code = 200
	AND cp.payroll_year BETWEEN 2006 AND 2018
	AND cp.industry_branch_code = 'S'
ORDER BY cp.industry_branch_code, cp.payroll_year, cp.payroll_quarter;

-- kontrola průměrného platu pro kategorii a rok, 19 branch * 13 let = 247 řádků 
-- czechia_payroll: vytvořím průměry za rok 
-- spojím s payroll kvůli názvu odvětví
SELECT
	cp.industry_branch_code,
	cpib.name,
	avg(cp.value) AS avg_year_payroll,
	cp.payroll_year
FROM czechia_payroll cp
JOIN czechia_payroll_industry_branch cpib 
	ON cp.industry_branch_code = cpib.code
WHERE cp.value_type_code = 5958
	AND cp.unit_code = 200
	AND cp.calculation_code = 200
	AND cp.payroll_year BETWEEN 2006 AND 2018
	AND cp.industry_branch_code IS NOT NULL
GROUP BY cp.industry_branch_code, cp.payroll_year;

-- zjištění jaká je délka jednotlivého měření u potravin
SELECT
    date_from,
    date_to,
    DATEDIFF(date_to, date_from) AS difference
FROM czechia_price cp
WHERE DATEDIFF(date_to, date_from) != '6';  -- všechna měření jsou za 6 dní

-- pokus: srovnání cen jednotlivých kategorií vedle sebe - ale nemám odkontrolovaná data?
SELECT
    cp.category_code,
    round(AVG(CASE WHEN year(date_from) = 2006 THEN value END),2) AS avg_price_2006,
    round(AVG(CASE WHEN year(date_from) = 2007 THEN value END),2) AS avg_price_2007,
    round(AVG(CASE WHEN year(date_from) = 2007 THEN value END) - AVG(CASE WHEN year(date_from) = 2006 THEN value END),2) AS 2007_2006, 
    round(AVG(CASE WHEN year(date_from) = 2008 THEN value END),2) AS avg_price_2008,
    round(AVG(CASE WHEN year(date_from) = 2009 THEN value END),2) AS avg_price_2009,
    round(AVG(CASE WHEN year(date_from) = 2010 THEN value END),2) AS avg_price_2010,
    round(AVG(CASE WHEN year(date_from) = 2011 THEN value END),2) AS avg_price_2011,
    round(AVG(CASE WHEN year(date_from) = 2012 THEN value END),2) AS avg_price_2012,
    round(AVG(CASE WHEN year(date_from) = 2013 THEN value END),2) AS avg_price_2013,
    round(AVG(CASE WHEN year(date_from) = 2014 THEN value END),2) AS avg_price_2014,
    round(AVG(CASE WHEN year(date_from) = 2015 THEN value END),2) AS avg_price_2015,
    round(AVG(CASE WHEN year(date_from) = 2016 THEN value END),2) AS avg_price_2016,
    round(AVG(CASE WHEN year(date_from) = 2017 THEN value END),2) AS avg_price_2017,
    round(AVG(CASE WHEN year(date_from) = 2018 THEN value END),2) AS avg_price_2018
FROM czechia_price cp 
WHERE
    year(date_from ) IN ('2006', '2007', '2008','2009','2010','2011','2012','2013','2014', '2015', '2016','2017','2018')
GROUP BY
    category_code;

-- pokus: průměrné výplaty, ale zkontrolovat, zda jsou výsledky správně
SELECT
    industry_branch_code, 
    round(AVG(CASE WHEN payroll_year = 2006 THEN value END)) AS avg_payroll_2006,
    round(AVG(CASE WHEN payroll_year = 2007 THEN value END)) AS avg_payroll_2007,
    round(AVG(CASE WHEN payroll_year = 2018 THEN value END)) AS avg_payroll_2018
FROM czechia_payroll cp 
WHERE
    value_type_code = 5958
	AND unit_code = 200
	AND calculation_code = 200
GROUP BY
    industry_branch_code;   
   

-- otázka č. 3 nápověda od AI
SELECT
    category_code,
    YEAR(date_from) AS year,
    AVG(value) AS avg_price,
    (AVG(value) - lag(AVG(value)) OVER (PARTITION BY category_code ORDER BY EXTRACT(YEAR FROM date_from))) / lag(AVG(value)) OVER (PARTITION BY category_code ORDER BY EXTRACT(YEAR FROM date_from)) * 100 AS yearly_change
FROM czechia_price
WHERE YEAR(date_from) BETWEEN 2006 AND 2018
GROUP BY category_code, year;

WITH YearlyChanges AS (
    SELECT
        category_code,
        AVG(value) AS avg_price,
        (AVG(value) - lag(AVG(value)) OVER (PARTITION BY category_code ORDER BY YEAR(date_from))) / lag(AVG(value)) OVER (PARTITION BY category_code ORDER BY YEAR(date_from)) * 100 AS yearly_change
    FROM czechia_price
    WHERE YEAR(date_from) BETWEEN 2006 AND 2018
    GROUP BY category_code
)
SELECT
    category_code,
    SUM(yearly_change) AS total_change
FROM YearlyChanges
GROUP BY category_code
ORDER BY total_change ASC
LIMIT 1; -- výsledkem je kategorie 115201 = roztíratelný tuk

-- pokus odečítání
SELECT
    category_code,
    AVG(CASE WHEN year(date_from) = 2006 THEN value END) AS avg_price_2006,
    AVG(CASE WHEN year(date_from) = 2007 THEN value END) - AVG(CASE WHEN year(date_from) = 2006 THEN value END) AS diff,
    AVG(CASE WHEN year(date_from) = 2007 THEN value END) AS avg_price_2007,
    AVG(CASE WHEN year(date_from) = 2008 THEN value END) AS avg_price_2008
FROM czechia_price cp  
GROUP BY
   category_code;   

 -- dodatečná tabulka HDP, GINI a populace dalších evropských států 2006-2018 
 -- kontrola, zda continent má nějaké NULL hodnoty
 SELECT *
 FROM countries c 
 WHERE continent IS NULL

-- final tabulka: evropské země, kromě Czech Republic = 47 zemí
CREATE OR REPLACE TABLE t_lucie_fridrichova_project_SQL_secondary_final AS
	SELECT 
		country,
		year,
		GDP,
		gini,
		population 
	FROM economies e  
	WHERE country IN (
		SELECT country
		FROM countries c 
		WHERE continent = 'Europe'
			AND country != 'Czech Republic'
		)
		AND YEAR BETWEEN 2006 AND 2018
	ORDER BY country, year;
