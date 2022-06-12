 
CREATE TABLE 



 /* Q1. for each of the six continents listed in 2015, identify which country had the maximum inflation rate in each continent */ 

SELECT name, continent, inflation_rate
  FROM countries AS c
    INNER JOIN economies AS e
      ON c.code = e.code
  WHERE year = 2015
  AND inflation_rate IN

    (SELECT MAX(inflation_rate) AS inflation_rate
        FROM countries
          INNER JOIN economies
            USING (code)
        WHERE year = 2015
    GROUP BY continent
    ) 

  ORDER BY inflation_rate DESC;


/* Q2. Identify 2015 economic data for countries that do not have 
gov_form of 'Constitutional Monarchy' or 'Republic' in their gov_form */ 

SELECT c.name, c.code, inflation_rate, unemployment_rate
    FROM economies AS e
      LEFT JOIN countries AS c
        USING (code)
    WHERE year = 2015
    AND code NOT IN
        (SELECT code
          FROM countries
          WHERE gov_form = 'Constitutional Monarchy'
          OR gov_form LIKE '%Republic%')
    
ORDER BY inflation_rate;


/* Q3. Identify the country names and other 2015 data in the economies table and the countries table 
for Central American countries with an official language */ 

SELECT c.name, total_investment, imports
  FROM countries AS c
    LEFT JOIN economies AS e
      ON (c.code = e.code
        AND c.code IN (
          SELECT l.code
            FROM languages AS l
            WHERE official = 'true'
        ) )
  WHERE region = 'Central America' AND year = 2015
ORDER BY name;


/* Q4. Calculate the average fertility rate for each region and continent in 2015 */ 

SELECT region, continent, AVG(fertility_rate) AS avg_fert_rate
  FROM countries AS c
    LEFT JOIN populations AS p
      ON c.code = p.country_code
  WHERE year = 2015
GROUP BY region, continent
ORDER BY avg_fert_rate;


/* Q5. determining the top 10 capital cities in Europe and the Americas in terms of a calculated percentage */ 

SELECT name, country_code, city_proper_pop, metroarea_pop,  
      city_proper_pop / metroarea_pop * 100 AS city_perc 
  FROM cities
  WHERE name IN
    (SELECT capital
       FROM countries
       WHERE (continent = 'Europe'
        OR continent LIKE '%America'))
        AND metroarea_pop IS NOT NULL
ORDER BY city_perc DESC
LIMIT 10;