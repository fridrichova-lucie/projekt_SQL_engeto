-- question 1: Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

-- A = zemědělství, lesnictví, rybářství = mzdy klesly pouze v roce 2009 
-- B = těžba a dobývání = mzdy klesly v letech 2009, 2013, 2014, 2016
-- C = zpracovatelský průmysl = mzdy vždy rostly
-- D = výroba a rozvod elektřiny ... = mzdy klesly v roce 2011, 2013, 2015
-- E = zásobování vodou, ... = mzdy klesly v roce 2013
-- F = stavebnitví = mzdy klesly v roce 2013
-- G = velkoobchod a maloobchod, ... = mzdy klesly v roce 2013
-- H = doprava a skladování = mzdy rostly, akorát v roce 2011 ne
-- I = ubytování, stravování a ... = mzdy klesly v letech 2009 a 2011
-- J = informační a komunikační činnosti = mzdy v roce 2013 klesly
-- K = peněžnictví a pojišťovnictví = mzdy klesly v roce 2013
-- L = činnosti v oblasti nemovitostí = mzdy klesly v letech 2009 a 2013
-- M = profesní, vědecké a technické činnosti = mzdy klesly v letech 2010 a 2013
-- N = administrativní a podpůrné činnosti = mzdy klesky akorát v roce 2013
-- O = veřejná správa a obrana, ... = mzdy klesly v letech 2010, 2011
-- P = vzdělávání = mzdy klesly akorát v roce 2010
-- Q = zdravotní a sociální péče = mzdy šly vždy nahoru
-- R = kulturní, zábavní a rekreační činnosti = mzdy klesly akorát v roce 2013
-- S = ostatní činnosti = mzdy šly vždy nahoru

SELECT DISTINCT 
	pf.ib_code,
	pf.ib_name, 
	pf.in_year,
	pf2.in_year,
	pf.avg_payroll_year,
	pf2.avg_payroll_year,
	round(pf2.avg_payroll_year / pf.avg_payroll_year * 100 - 100,2) AS percentage
FROM t_lucie_fridrichova_project_sql_primary_final pf
JOIN t_lucie_fridrichova_project_sql_primary_final pf2
	ON pf.in_year = pf2.in_year -1
	AND pf.ib_code = pf2.ib_code;


