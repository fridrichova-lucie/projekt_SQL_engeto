-- Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)? 
-- Pokud počítáme i období, kdy cena klesla, tak cukr a rajčata zlevnily a nejpomaleji cena stoupala
-- u banánů, dále vepřové pečeně a pak minerální vody, jen musím upozornit, že u vína je jen měření posledních 4 let 2015-2018

SELECT DISTINCT 
	pf.category_code
	, pf.category_name
	, round(avg(round(pf2.avg_price_year / pf.avg_price_year *100 - 100,2)),2) AS avg_percentage
FROM t_lucie_fridrichova_project_sql_primary_final pf
JOIN t_lucie_fridrichova_project_sql_primary_final pf2
	ON pf.in_year = pf2.in_year - 1
	AND pf.category_code = pf2.category_code
GROUP BY pf.category_code
ORDER BY avg_percentage
LIMIT 5;

 

