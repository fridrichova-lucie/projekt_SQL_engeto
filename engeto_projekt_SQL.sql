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

 