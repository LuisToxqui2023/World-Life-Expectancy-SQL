-- World Life Expectancy Project (Data Cleaning)

-- Viewing all columns from the table
SELECT * 
FROM world_life_expectancy
;


-- Finding duplicates 
SELECT Country, Year, concat(Country, Year), count(concat(Country, Year))
FROM world_life_expectancy
GROUP BY  Country, Year, concat(Country, Year)
HAVING  count(concat(Country, Year)) > 1
; 


-- Finding duplicates with Row_Num
SELECT *
FROM(
	SELECT Row_ID,
	concat(Country, Year), 
	row_number()over(partition by concat(Country, Year) order by concat(Country, Year)) as Row_Num
	FROM world_life_expectancy
    ) as Row_table
WHERE Row_Num > 1
; 


-- Removing duplicates
DELETE FROM world_life_expectancy
WHERE 
	Row_ID IN (
	SELECT Row_ID
	FROM(
		SELECT Row_ID,
		concat(Country, Year), 
		row_number()over(partition by concat(Country, Year) order by concat(Country, Year)) as Row_Num
		FROM world_life_expectancy
		) as Row_table
	WHERE Row_Num > 1)
    ;
    

-- Finding blank data in Status
SELECT *
FROM world_life_expectancy
WHERE Status = ''
;


-- Determining what is the expected data output options in the Status column 
SELECT distinct(Status)
FROM world_life_expectancy
WHERE Status <> ''
;

-- Finding which Countries are labled 'Developing'
SELECT distinct(Country)
FROM world_life_expectancy
WHERE Status = 'Developing'
; 

-- First attempt to update the Status column (failed)
UPDATE world_life_expectancy
SET Status = 'Developing' 
WHERE Country IN (SELECT distinct(Country)
				  FROM world_life_expectancy
				  WHERE Status = 'Developing'); 

-- 2nd attempt to update  blank data in Status column to 'Developing' (successful)
UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
SET t1.Status = 'Developing' 
WHERE t1.Status = ''
AND t2.Status <> ''
AND t2.Status = 'Developing';


-- Finding few blank datas when Country is 'United States of America'
SELECT *
FROM world_life_expectancy
WHERE Country = 'United States of America' 
; 

-- Updating blank data in Status column to 'Developed'
UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
SET t1.Status = 'Developed' 
WHERE t1.Status = ''
AND t2.Status <> ''
AND t2.Status = 'Developed'; 


-- Finding any blanks in Life expectancy
SELECT *
FROM world_life_expectancy
WHERE `Life expectancy` = ''
;


-- Determing and comparing what is the expected data for Life expectancy
SELECT Country, Year, `Life expectancy`
FROM world_life_expectancy
#WHERE `Life expectancy` = ''
;


-- Joining tables to compare years and find the average for the blanks in Life expectancy
SELECT t1.Country, t1.Year, t1.`Life expectancy`, 
	   t2.Country, t2.Year, t2.`Life expectancy`,
       t3.Country, t3.Year, t3.`Life expectancy`,
       round((t2.`Life expectancy` + t3.`Life expectancy`)/2,1)
FROM world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
    AND t1.Year = t2.Year - 1
JOIN world_life_expectancy t3
	ON t1.Country = t3.Country
    AND t1.Year = t3.Year + 1
WHERE t1.`Life expectancy` = ''
;


-- Updating the blank data in Life expectancy with the new average
UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
    AND t1.Year = t2.Year - 1
JOIN world_life_expectancy t3
	ON t1.Country = t3.Country
    AND t1.Year = t3.Year + 1
SET t1.`Life expectancy` =  round((t2.`Life expectancy` + t3.`Life expectancy`)/2,1)
WHERE t1.`Life expectancy` = ''
;
