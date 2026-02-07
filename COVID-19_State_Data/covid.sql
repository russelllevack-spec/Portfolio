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

CREATE TABLE covid_state(
	State	varchar,
	Tested	integer,
	Infected	integer,
	Deaths	integer,
	Population	integer,
	Pop_Density	real,
	Gini	real,
	ICU_Beds	integer,
	Income	integer,
	GDP	integer,
	Unemployment	real,
	Sex_Ratio	real,
	Smoking_Rate	real,
	Flu_Deaths	real,
	Respiratory_Deaths	real,
	Physicians	integer,
	Hospitals	integer,
	Health_Spending	integer,
	Pollution	real,
	Med_Large_Airports	real,
	Temperature	real,
	Urban	real,
	Age_0_25	real,
	Age_26_54	real,
	Age_55_up real,
	School_Closure_Date date);

\copy covid_state FROM '\covd_state.csv'
DELIMITER ','
CSV 
HEADER;


WITH duplicates AS(
	SELECT *, ROW_NUMBER() OVER(
		PARTITION BY combined_key
		ORDER BY id
	) AS row_num
	FROM covid)
	
SELECT *
FROM duplicates
WHERE row_num > 1;



CREATE TEMP TABLE covid_combined AS
SELECT Province_State, MIN(first_case_date) AS first_date
FROM covid
GROUP BY Province_STATE;

WITH ranked AS(
	SELECT *, RANK()
	OVER(ORDER BY first_date) as ranks
	FROM covid_combined)

SELECT * FROM ranked
INNER JOIN covid_state
ON ranked.Province_State = covid_state.State
ORDER BY first_date;



