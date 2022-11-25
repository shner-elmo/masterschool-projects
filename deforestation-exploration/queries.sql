-- Some of the queries that were used for the project

SELECT la_name, region, pct_forest_area_sqkm, la_year
FROM forestation
WHERE la_name = 'Italy'
AND la_year = 2016


SELECT
	la_name,
    pct_forest_area_sqkm,
	la_year
FROM forestation
WHERE la_year = 2016
--AND la_name = 'World'
ORDER BY 2 DESC


SELECT forest_area_sqkm, fa_year, la_year
FROM forestation
WHERE fa_name = 'World'
AND fa_year = 1990



WITH year_1990 AS (SELECT fa_code, fa_name, region,
                   forest_area_sqkm
                   FROM forestation
	 				WHERE fa_year = 1990),
year_2016 AS (SELECT fa_code, fa_name, forest_area_sqkm
              FROM forestation
               WHERE fa_year = 2016)
SELECT
	y1.fa_code,
    y1.fa_name,
    y1.region,
    y1.forest_area_sqkm AS y_1990,
    y2.forest_area_sqkm AS y_2016,
    ((y1.forest_area_sqkm - y2.forest_area_sqkm) /
     	y1.forest_area_sqkm) * 100 AS pct_diff,
    (y1.forest_area_sqkm - y2.forest_area_sqkm) AS diff
FROM year_1990 y1
JOIN year_2016 y2
	ON y2.fa_code = y1.fa_code
ORDER BY pct_diff DESC

DROP VIEW IF EXISTS forestation;
CREATE VIEW forestation AS
  (SELECT
   	fa.country_code AS fa_code,
   	fa.country_name AS fa_name,
   	fa.year AS fa_year,
   	fa.forest_area_sqkm,

   	la.country_code AS la_code,
   	la.country_name AS la_name,
   	la.year AS la_year,
   	la.total_area_sq_mi,
   	((la.total_area_sq_mi * 2.59)::numeric)
    	AS total_area_sqkm,
   	(
      ((fa.forest_area_sqkm / ROUND((la.total_area_sq_mi *
      2.59)::numeric, 2)) * 100)::numeric)
    	AS pct_forest_area_sqkm,

   	re.country_code AS re_code,
   	re.country_name AS re_name,
   	re.region,
   	re.income_group

   FROM forest_area AS fa
     JOIN land_area AS la
         ON la.country_code = fa.country_code
         AND la.year = fa.year

     JOIN regions AS re
         ON re.country_code = la.country_code);

SELECT
	region,
    AVG(pct_forest_area_sqkm)
FROM forestation
WHERE fa_year = 2016
	AND pct_forest_area_sqkm IS NOT NULL
GROUP BY 1
ORDER BY 2



SELECT
	fa_name, region, fa_year, pct_forest_area_sqkm,
    CASE
    WHEN pct_forest_area_sqkm > 75 THEN 100
    WHEN pct_forest_area_sqkm > 50 THEN 75
    WHEN pct_forest_area_sqkm > 25 THEN 50
    ELSE 25
	END AS quartile
FROM forestation
WHERE fa_year = 2016
ORDER BY 4 DESC


WITH year_1990 AS (SELECT fa_code, fa_name, region,
                   forest_area_sqkm
                   FROM forestation
	 				WHERE fa_year = 1990),
year_2016 AS (SELECT fa_code, fa_name, forest_area_sqkm
              FROM forestation
               WHERE fa_year = 2016)
SELECT
	y1.fa_code,
    y1.fa_name,
    y1.region,
    y1.forest_area_sqkm AS y_1990,
    y2.forest_area_sqkm AS y_2016,
    ((y1.forest_area_sqkm - y2.forest_area_sqkm) /
     	y1.forest_area_sqkm) * 100 AS pct_diff,
    (y1.forest_area_sqkm - y2.forest_area_sqkm) AS diff
FROM year_1990 y1
JOIN year_2016 y2
	ON y2.fa_code = y1.fa_code
ORDER BY pct_diff DESC


DROP VIEW IF EXISTS forestation;
CREATE VIEW forestation AS
  (SELECT
   	fa.country_code AS fa_code,
   	fa.country_name AS fa_name,
   	fa.year AS fa_year,
   	fa.forest_area_sqkm,

   	la.country_code AS la_code,
   	la.country_name AS la_name,
   	la.year AS la_year,
   	la.total_area_sq_mi,
   	ROUND((la.total_area_sq_mi * 2.59)::numeric, 2)
    	AS total_area_sqkm,
   	ROUND(
      ((fa.forest_area_sqkm / ROUND((la.total_area_sq_mi *
      2.59)::numeric, 2)) * 100)::numeric, 2)
    	AS pct_forest_area_sqkm,

   	re.country_code AS re_code,
   	re.country_name AS re_name,
   	re.region,
   	re.income_group

   FROM forest_area AS fa
     JOIN land_area AS la
         ON la.country_code = fa.country_code
         AND la.year = fa.year

     JOIN regions AS re
         ON re.country_code = la.country_code);

SELECT
	Count(*),
    CASE
    WHEN pct_forest_area_sqkm > 75 THEN 100
    WHEN pct_forest_area_sqkm > 50 THEN 75
    WHEN pct_forest_area_sqkm > 25 THEN 50
    ELSE 25
	END AS quartile
FROM forestation
WHERE fa_year = 2016
	AND pct_forest_area_sqkm IS NOT NULL
GROUP BY 2
ORDER BY 1
