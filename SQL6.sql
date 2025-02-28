--STADIUM ANALYSIS
--31. Which stadium has the highest capacity?

SELECT s.CAPACITY AS CAPACITY,s.NAME_S AS STADIUM_NAME FROM STADIUM s
GROUP BY s.NAME_S,s.CAPACITY
 ORDER BY s.CAPACITY DESC LIMIT 1;

--32. How many stadiums are located in a ‘Russia’ country or ‘London’ city?

SELECT COUNT(*)
FROM Stadium
WHERE COUNTRY = 'Russia' OR CITY = 'London';

-- 33. Which stadium hosted the most matches during a season?

SELECT SEASON, STADIUM, COUNT(*) AS match_count
FROM Matches
GROUP BY SEASON, STADIUM
ORDER BY match_count DESC
LIMIT 1;

-- 34. What is the average stadium capacity for teams participating in each season?
SELECT SEASON,AVG(s.CAPACITY) as avg_capcity
from matches m
join stadium s on m.stadium=s.NAME_S
GROUP BY SEASON
ORDER BY SEASON;


-- 35. How many teams play in stadiums with a capacity of more than 50,000?

SELECT COUNT(DISTINCT t.TEAM_NAME)
FROM TEAMS t
JOIN Stadium S ON t.HOME_STADIUM = S.NAME_S
WHERE S.CAPACITY > 50000;

-- 36. Which stadium had the highest average attendance during a season?

SELECT SEASON, STADIUM, AVG(ATTENDANCE) AS avg_attendance
FROM Matches
GROUP BY SEASON, STADIUM
ORDER BY avg_attendance DESC
LIMIT 1;


-- 37. What is the distribution of stadium capacities by country?

SELECT COUNTRY, COUNT(*) AS stadium_count, AVG(CAPACITY) AS avg_capacity
FROM Stadium
GROUP BY COUNTRY
ORDER BY stadium_count DESC;
