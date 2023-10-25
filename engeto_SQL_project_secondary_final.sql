-- dodatečná tabulka secondary_final
-- HDP, GINI a populace dalších evropských států 2006-2018 
-- kontrola, zda continent má nějaké NULL hodnoty
SELECT *
FROM countries c 
WHERE continent IS NULL

-- final tabulka: evropské země, kromě Czech Republic = 47 zemí
CREATE OR REPLACE TABLE t_lucie_fridrichova_project_SQL_secondary_final AS
	SELECT 
		country,
		'year',
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

-- odstranění tabulky
DROP TABLE t_lucie_fridrichova_project_SQL_secondary_final;
