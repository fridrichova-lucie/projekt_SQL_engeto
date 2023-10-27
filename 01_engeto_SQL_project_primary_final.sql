-- Finální příkaz pro vytvoření tabulky

CREATE OR REPLACE TABLE t_lucie_fridrichova_project_sql_primary_final AS  
	SELECT
		cpl.industry_branch_code AS ib_code,
		cpib.name AS ib_name,
		round(avg(cpl.value),2) AS avg_payroll_year,
		cpl.payroll_year AS in_year, 
		cpe.category_code,
		cpc.name AS category_name,
		round(avg(cpe.value),2) AS value_price
	FROM czechia_payroll cpl
	JOIN czechia_price cpe 
		ON cpl.payroll_year = year(cpe.date_from)
	JOIN czechia_payroll_industry_branch cpib 
		ON cpl.industry_branch_code = cpib.code 
	JOIN czechia_price_category cpc 
		ON cpe.category_code = cpc.code 
	WHERE cpl.value_type_code = 5958
		AND cpl.unit_code = 200
		AND cpl.calculation_code = 200
		AND cpl.industry_branch_code IS NOT NULL
		AND cpl.payroll_year BETWEEN 2006 AND 2018
	GROUP BY ib_code, cpl.payroll_year, cpe.category_code, year(cpe.date_from)
	ORDER BY ib_code, cpl.payroll_year, cpe.category_code, date_from;

-- MYŠLENKOVÉ POCHODY :)
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

-- jak spojit TABLE PRICE a CATEGORY CODE
-- spojím price s name of category 27 categories * 13 years = 351 rows
-- je o 9 řádků míň,protože u vína probíhalo měření pouze v letech 2015-2018 = 342 rows
-- zprůměruj na roční ceny
SELECT 
	cpe.category_code,
	cpc.name AS name_category,
	round(avg(cpe.value),2) AS value_price,
	year(cpe.date_from) AS price_year
	FROM czechia_price cpe 
JOIN czechia_price_category cpc 
	ON cpe.category_code = cpc.code
GROUP BY cpe.category_code, year(cpe.date_from)
ORDER BY cpe.category_code, date_from;

-- jak spojit TABLE PAYROLL a INDUSTRY_BRANCH
-- spojím payroll s name of industry_branch -- pozor musíš omezit na roky 2006 -2018
-- czechia_payroll: 19 branch * 13 let * 4 roční období = 988 řádků / odstranila jsem NULL hodnoty
-- zprůměruj na roční výplaty = 19 branch * 13 let = 247 řádků
-- připoj název industry_branch_code

SELECT
	cpl.industry_branch_code AS ip_code,
	cpib.name AS ip_name,
	round(avg(cpl.value),2) AS avg_payroll_year,
	cpl.payroll_year
FROM czechia_payroll cpl
JOIN czechia_payroll_industry_branch cpib 
	ON cpl.industry_branch_code = cpib.code
WHERE cpl.value_type_code = 5958
	AND cpl.unit_code = 200
	AND cpl.calculation_code = 200
	AND cpl.industry_branch_code IS NOT NULL
	AND cpl.payroll_year BETWEEN 2006 AND 2018
GROUP BY ip_code, cpl.payroll_year 
ORDER BY ip_code, cpl.payroll_year

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

   

