# projekt_SQL_engeto
projekt_SQL_engeto

Odpovědi na otázky: 

Sledované období je 2006 - 2018, kdy máme všechna potřebná data.

1. Rostou v průběhu let mzdy ve všech odvětvích nebo v některých klesají?
Jednoznačně se nedá odpovědět, většinou mzdy rostly kromě roku 2013, kdy většinou mzdy klesly.
Pouze ve třech odvětvích průmysl + zdravotnictví + ostatní činnost mzdy vždy rostly.

2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
Mléka jsme si mohli koupit v roce 2006 1.026 litrů a v roce 2018 už 1.285 litrů a 
chleba jsme si mohli koupit v roce 2006 919 kilo a v roce 2018 už 1.051 kilo
Pozn. první období je rok 2006 a poslední je rok 2018 (dalo by se použít i čtvrtletí, ale tabulku mám připravenou na roční hodnoty)
Dále nebylo přesně zadáno, zda v jednotlivých odvětvích nebo pouze z průměrné mzdy, zvolila jsem variantu, že jsem počítala množství z průměrné mzdy všech oborů

3. Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)? 
Pokud počítáme i období, kdy cena klesla, tak cukr a rajčata zlevnily a nejpomaleji cena stoupala u banánů, dále vepřové pečeně a pak minerální vody, jen musím upozornit, že u vína proběhlo měření pouze posledních 4 let 2015-2018.

4. Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
Jak je otázka myšlena, byl meziroční nárůst cen potravin větší než 10% nebo zda byl nárůst cen větší o více než 10% než nárůst cen mezd, naštěstí v obou případech je stejná odpověď: neexistuje.

5. Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?
Nejsem ekonom, abych mohla dobře interpretovat, ale pokud předpokládám správně, že když jeden rok vzroste HDP, tak by to mohlo mít pozitivní vliv v následujícím roce na zvýšení mezd a snížení cen? Tabulky bych na interpretaci nechala ekonomům, každopádně tam přímou úměru nevidím, takže by se zdálo, že HDP nemá na mzdy a potraviny vliv.

V případě, že pro Vás interpretace není dostačující, nebo jsem znění otázky nepochopila přesně, kontaktujte mě, a informace doplním.

Postup:
Nejdříve jsem začala rozborem jednotlivých tabulek, pro moji přehlednost, jsem si zpracovala v excelu schéma - viz. přílohy.
Dále jsem zjiŠťovala pro které roky mám všechna potřebná data, jak jsem výše uvedla, vyšlo mi období 2006 -2018.

Následně jsem vytvořila pomocí JOIN tabulku primary, abych měla všechná potřebná data pohromadě. I zde jsem si pomohlo nákresem nové tabulky v excelu.

Tvorba druhé tabulky, mi připadala snadná, opět vznikla spojením tabulek, tentokrát jen spojením dvou tabulek. V zadání bylo, že má být tabulka pro ostatní země Evropy, proto jsem vynechala Českou republiku, i když jsem výši HDP potřebovala pro odpověď na pátou otázku.
