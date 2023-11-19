CREATE DATABASE FORDCARS;
USE FORDCARS;

CREATE TABLE ford (
model VARCHAR (255),
year_registration VARCHAR (255),
price VARCHAR (255),
transmission VARCHAR (255),
mileage VARCHAR (255),
fueltype VARCHAR (255),
roadtax VARCHAR (255),
milespergallon VARCHAR (255),
enginesize VARCHAR (255)
);
--------------------------------------------------------------------------------------
-- EXPLORATORY DATA ANALYSIS

DESCRIBE ford;
-- Create a primaty key column for unique identicfication of cars for saleG
ALTER TABLE ford
ADD COLUMN car_id INT PRIMARY KEY AUTO_INCREMENT;

ALTER TABLE ford
MODIFY car_id INT FIRST;

ALTER TABLE ford
MODIFY mileage INT;

-- DETERMINE IF THERE IS A NULL VALUE 
SELECT * FROM ford 
WHERE (
car_id IS NULL OR
model IS NULL OR
year_registration IS NULL OR
price IS NULL OR
transmission IS NULL OR
mileage IS NULL OR
fueltype IS NULL OR
roadtax IS NULL OR
milespergallon IS NULL OR
enginesize IS NULL
);

/*
In the table there is an outlier in the coulunm year of registration.
It is said to be outler beacuse the value is equals to 2060, and we are still in the year 2023.
In order to keep our data valid, the entire row containing that value should be deleted.
*/

DELETE FROM ford WHERE year_registration = 2060;

SELECT 
	car_id,
	date,
    (car_Id - avg(car_id) OVER())/ STDDEV(car_id) OVER() AS zscore
	FROM ford

--------------------------------------------------------------------------------------
-- What is the total number of cars available for selling?
SELECT DISTINCT COUNT(car_id) 
FROM ford; 

-- There are a Total of 17965 cars availble

-- How many distinct car model is available?
SELECT COUNT(DISTINCT model)
FROM ford;

-- There are a Total of 23 car models available

--------------------------------------------------------------------------------------
-- How many cars available in each registration year? 
SELECT 
    year_registration,
    COUNT(car_id) AS car_count
FROM ford
GROUP BY year_registration
ORDER BY car_count DESC;

--------------------------------------------------------------------------------------
-- What are available car models in year 2017,2018, and 2019
SELECT 
	DISTINCT(model) AS car_model, 
    year_registration 
FROM ford
WHERE year_registration IN (2017,2018,2019)
ORDER BY year_registration;
--------------------------------------------------------------------------------------
-- Determine the number car unit by car model?
SELECT 
	DISTINCT model,
	COUNT(model) AS carmodel_count
FROM ford
GROUP BY model
ORDER BY carmodel_count DESC;

-- Determine the top 5 car model with the most number of unit.
SELECT 
	model,
	COUNT(model) AS carmodel_count
FROM ford
GROUP BY model
ORDER BY carmodel_count DESC
LIMIT 5;
--------------------------------------------------------------------------------------
-- What is the total number of cars by fuel type?
SELECT 
    fueltype,
	COUNT(fueltype) AS fueltype_count
FROM ford
GROUP BY fueltype
ORDER BY fueltype_count DESC;

-- Give me the number of car by carmodel and fuel type
SELECT 
	model,
    fueltype,
	COUNT(fueltype) AS fueltype_count
FROM ford
GROUP BY model, fueltype
ORDER BY fueltype_count DESC;
--------------------------------------------------------------------------------------
-- First thing to consider in buying a second hand car is the mileage and age of the car
-- Here are the list of cars sorted by mileage in ascending order
SELECT
	model,
    year_registration,
    mileage
FROM ford
ORDER BY mileage

-- Here are the list of cars sorted by year of registration in ascending order
SELECT
	model,
    year_registration,
    mileage
FROM ford
ORDER BY year_registration

-- According to moneymax.ph, "avoid cars with mile age above 60,000 km because these unit's parts are likely to be worn out
SELECT
	model,
    year_registration,
    mileage
FROM ford
WHERE mileage < 60000
ORDER BY mileage;

-- mileage bracket oF cars
SELECT
	model,
    year_registration,
	mileage,
CASE
WHEN mileage >= 1 AND mileage <= 10000 THEN 'Good as New'
WHEN mileage > 10000 AND mileage <= 60000 THEN 'Moderately Used'
WHEN mileage > 60000 AND mileage <= 70000 THEN 'Averagely Used'
ELSE  'Overused'
END AS car_age
FROM ford
ORDER BY mileage;
---------------------------------------------------------------------------------------
-- THE NUMBER OF GOOD AS NEW CARS
-- THE NUMBER MODERATELY USED CARS
-- THE NUMBER OF AVERAGELY USED CARS
-- THE NUMBER OF OVERUSED CARS

SELECT
	count(car_id) AS total_car_by_age,
CASE
WHEN mileage >= 1 AND mileage <= 10000 THEN 'Good as New'
WHEN mileage > 10000 AND mileage <= 60000 THEN 'Moderately Used'
WHEN mileage > 60000 AND mileage <= 70000 THEN 'Averagely Used'
ELSE  'Overused'
END AS car_age
FROM ford
GROUP BY car_age
ORDER BY total_car_by_age DESC;
