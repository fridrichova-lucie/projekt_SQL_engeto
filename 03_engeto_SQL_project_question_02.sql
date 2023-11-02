-- Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
-- první období je rok 2006 a poslední je rok 2018 (dalo by se použít i čtvrtletí, ale tabulku mám připravenou na roční hodnoty)
-- Nebylo přesně zadáno, zda v jednotlivých odvětvích nebo pouze z průměrné mzdy, zvolila jsem variantu, že jsem počítala množství z průměrné mzdy

-- výsledek:
-- mléka bychom si mohli koupit v roce 2006 1026 litrů a v roce 2018 už 1285 litrů
-- chleba bychom si mohli koupit v roce 2006 919 kilo a v roce 2018 už 1051 kilo

SELECT 
	in_year
	, category_name
	, round(avg(avg_payroll_year),0) AS avg_all_payroll
	, avg_price_year
	, round(avg_payroll_year / avg_price_year,0) AS how_many
FROM t_lucie_fridrichova_project_sql_primary_final tlfpspf
WHERE in_year IN ('2006', '2018')
	AND category_code IN ('114201', '111301')
GROUP BY in_year, category_code;


-- ještě jsem si ověřila pro jaké hodnoty jsou uveden ceny
SELECT *
FROM czechia_price_category cpc
WHERE code IN ('114201', '111301');