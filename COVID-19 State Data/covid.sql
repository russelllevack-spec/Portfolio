CREATE TABLE covid(
		id integer PRIMARY KEY,
		UID	integer,
		iso2 varchar,
		iso3 varchar,
		code3 integer,
		FIPS integer,
		Admin2 varchar,
		Province_State varchar,
		Country_Region varchar,
		Lat	real,
		Long_ real,
		Combined_Key varchar,
		first_case_date date);

\copy covid FROM '\covd_first_infected.csv'
DELIMITER ','
CSV 
HEADER;

SELECT * FROM covid LIMIT 10;

WITH duplicates AS(
	SELECT *, ROW_NUMBER() OVER(
		PARTITION BY combined_key
		ORDER BY id
	) AS row_num
	FROM covid)
SELECT *
FROM duplicates
WHERE row_num > 1;

DELETE FROM 




