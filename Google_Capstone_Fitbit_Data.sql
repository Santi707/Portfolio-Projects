SELECT *
FROM Daily_Activity


--Show only the top 10 rows
SELECT TOP 10 *
FROM Daily_Activity


--Drop columns
ALTER TABLE Daily_Activity
DROP COLUMN TrackerDistance, LoggedActivitiesDistance, VeryActiveDistance, ModeratelyActiveDistance, LightActiveDistance, SedentaryActiveDistance


--Counts the number of Distinct users 
SELECT COUNT(DISTINCT Id)
FROM Daily_Activity


--Showing the data with zero steps, may drop since this can scew my analysis
SELECT *
FROM Daily_Activity
WHERE TotalSteps = 0


--Delete Rows where Total Steps are zero
DELETE FROM Daily_Activity
WHERE TotalSteps = 0

--Change date to only show yyyy-mm-dd
ALTER TABLE Daily_Activity
ADD Activity_Date_Converted DATE;

UPDATE Daily_Activity
SET Activity_Date_Converted = CONVERT(Date, ActivityDate)

ALTER TABLE	Daily_Activity
DROP COLUMN	ActivityDate


--Create new column with total active minutes
ALTER TABLE Daily_Activity
ADD Total_Minutes_Active INT;

UPDATE Daily_Activity
SET Total_Minutes_Active = (VeryActiveMinutes + FairlyActiveMinutes + LightlyActiveMinutes)


--finding averages and rounding for days of week and convert to hours
SELECT Day_of_week,
	ROUND(AVG(TotalSteps),0) AS Avg_steps,
	ROUND(AVG(Calories),0) AS Avg_Calories,
	ROUND(AVG(VeryActiveMinutes / 60), 2) AS Avg_VeryActiveHours,
	ROUND(AVG(FairlyActiveMinutes / 60), 2) AS Avg_FairlyActiveHours,
	ROUND(AVG(LightlyActiveMinutes / 60),0) AS Avg_LightlyActiveHours,
	ROUND(AVG(Sedentary_Hours),0) AS Avg_SedentaryHours
FROM Daily_Activity
GROUP BY Day_of_week
ORDER BY Avg_steps DESC


--Show number of entries, avg steps, and avg calories per user
SELECT DISTINCT Id, COUNT(Id) AS Entries, ROUND(AVG(TotalSteps),0) AS Avg_total_steps, ROUND(AVG(calories),0) AS Avg_calories
FROM Daily_Activity
GROUP BY Id
ORDER BY Entries DESC


--determine if user is more active or sedentary
SELECT DISTINCT Id,
CASE
	WHEN AVG(Total_Minutes_Active) > AVG(SedentaryMinutes) THEN 'More active than sedentary'
	ELSE 'More sedentary than active'
	END AS Active_vs_sedentary
FROM Daily_Activity
GROUP BY Id	
