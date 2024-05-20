-- World Life Expectancy Project (Exploratory Data Analysis)

-- Viewing all columns in the table
SELECT *
FROM world_life_expectancy 
;

-- Finding and rounding the MIN and MAX of 'Life expectancy' by each Country
SELECT Country, 
	   min(`Life expectancy`), 
	   max(`Life expectancy`),
       round(max(`Life expectancy`) - min(`Life expectancy`), 1) as Life_Increase_15_Years
FROM world_life_expectancy 
GROUP BY Country
HAVING min(`Life expectancy`) <> 0
AND max(`Life expectancy`) <> 0
ORDER BY Life_Increase_15_Years ASC
;


-- Finding and rounding the overall average of 'Life expectancy' in each Year and filtering out data with 0 'Life expectancy'
SELECT Year, round(avg(`Life expectancy`),1)
FROM world_life_expectancy 
WHERE `Life expectancy` <> 0
AND `Life expectancy` <> 0
GROUP BY Year 
ORDER BY Year 
;


SELECT *
FROM world_life_expectancy 
;


-- Finding and rounding the average of each Country 'Life Expectancy' and 'GDP' from highest to lowest
SELECT 	Country, round(avg(`Life expectancy`),1) as Life_Exp, round(avg(GDP),1) as GDP
FROM world_life_expectancy 
GROUP BY Country 
HAVING Life_Exp > 0
AND GDP > 0
ORDER BY GDP DESC
;


-- Finding how many Countries have a High and Low GDP and their average Life expectancy
SELECT 
sum(CASE WHEN GDP >= 1500 THEN 1 ELSE 0 END) as High_GDP_Count,
avg(CASE WHEN GDP >= 1500 THEN `Life expectancy` ELSE NULL END) as High_GDP_Life_Expectancy,
sum(CASE WHEN GDP <= 1500 THEN 1 ELSE 0 END) as Low_GDP_Count,
avg(CASE WHEN GDP <= 1500 THEN `Life expectancy` ELSE NULL END) as Low_GDP_Life_Expectancy
FROM world_life_expectancy
;


SELECT *
FROM world_life_expectancy 
;


-- Finding and rounding the average Life expectancy by Status 
SELECT Status, round(avg(`Life expectancy`),1)
FROM world_life_expectancy 
GROUP BY Status
;


-- Finding and rounding the average Life expectancy by Status and how many Countries belong to each Status 
SELECT Status, count(distinct(Country)), round(avg(`Life expectancy`),1)
FROM world_life_expectancy 
GROUP BY Status
;


-- Finding each Coutries average Life expectancy and BMI while filtering out any data with zero
SELECT 	Country, round(avg(`Life expectancy`),1) as Life_Exp, round(avg(BMI),1) as BMI
FROM world_life_expectancy 
GROUP BY Country 
HAVING Life_Exp > 0
AND BMI > 0
ORDER BY BMI ASC
;


-- Finding Countries with 'United' with Year, Life expectancy, Adult Mortality, and Rolling Total
SELECT Country, Year, `Life expectancy`, `Adult Mortality`, 
	   sum(`Adult Mortality`) over(partition by Country order by Year) as Rolling_Total 
FROM world_life_expectancy 
WHERE Country LIKE '%United%'
;



