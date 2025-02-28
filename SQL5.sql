--TEAM ANALYSIS
--26. Which team has the largest home stadium in terms of capacity?

SELECT t.TEAM_NAME, s.NAME_S AS STADIUM_NAME, s.CAPACITY
FROM teams t
JOIN stadium s ON t.HOME_STADIUM = s.NAME_S
ORDER BY s.CAPACITY DESC
LIMIT 1;

--27. Which teams from each country participated in the UEFA competition in a season?
SELECT DISTINCT t.COUNTRY, t.TEAM_NAME, m.SEASON
FROM teams t
JOIN matches m ON t.TEAM_NAME = m.HOME_TEAM OR t.TEAM_NAME = m.AWAY_TEAM
WHERE m.SEASON = '2021-2022'  
AND (t.TEAM_NAME IN (SELECT DISTINCT HOME_TEAM FROM matches) 
     OR t.TEAM_NAME IN (SELECT DISTINCT AWAY_TEAM FROM matches))
ORDER BY t.COUNTRY, m.SEASON;


--28. Which team scored the most goals across home and away matches in a given season?

SELECT TEAM, SUM(GOALS) AS TOTAL_GOALS
FROM (
    SELECT HOME_TEAM AS TEAM, SUM(HOME_TEAM_SCORE) AS GOALS
    FROM matches
    WHERE SEASON = '2021-2022'  
    GROUP BY HOME_TEAM
    UNION ALL
    SELECT AWAY_TEAM AS TEAM, SUM(AWAY_TEAM_SCORE) AS GOALS
    FROM matches
    WHERE SEASON = '2021-2022'  
    GROUP BY AWAY_TEAM
) AS team_goals
GROUP BY TEAM
ORDER BY TOTAL_GOALS DESC
LIMIT 1;

--29. How many teams have home stadiums in each city or country?

SELECT s.CITY, s.COUNTRY, COUNT(t.TEAM_NAME) AS TEAM_COUNT
FROM stadium s
JOIN teams t ON s.NAME_s = t.HOME_STADIUM
GROUP BY s.CITY, s.COUNTRY
ORDER BY TEAM_COUNT DESC;

--30. Which teams had the most home wins in the 2021-2022 season?

SELECT HOME_TEAM, COUNT(*) AS HOME_WINS
FROM matches
WHERE SEASON = '2021-2022'  -- Replace with desired season
AND HOME_TEAM_SCORE > AWAY_TEAM_SCORE
GROUP BY HOME_TEAM
ORDER BY HOME_WINS DESC
LIMIT 1;