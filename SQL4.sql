--MATCH ANALYSIS
--18. Which players have the highest total goals scored (including assists)?

SELECT g.PID AS PLAYER_ID, p.FIRST_NAME, p.LAST_NAME, 
       (COUNT(g.GOAL_ID) + COUNT(g.ASSIST)) AS TOTAL_CONTRIBUTIONS
FROM goals g
JOIN players p ON g.PID = p.PLAYER_ID
GROUP BY g.PID, p.FIRST_NAME, p.LAST_NAME
ORDER BY TOTAL_CONTRIBUTIONS DESC
LIMIT 1;

--19. What is the average height and weight of players per position?

SELECT POSITIONS, 
       ROUND(CAST(AVG(HEIGHT) AS NUMERIC), 2) AS AVG_HEIGHT, 
       ROUND(CAST(AVG(WEIGHT) AS NUMERIC), 2) AS AVG_WEIGHT
FROM players
GROUP BY POSITIONS
ORDER BY AVG_HEIGHT DESC;

--20. Which player has the most goals scored with their left foot?

SELECT g.PID AS PLAYER_ID, p.FIRST_NAME, p.LAST_NAME, COUNT(*) AS LEFT_FOOT_GOALS
FROM goals g
JOIN players p ON g.PID = p.PLAYER_ID
WHERE g.GOAL_DESC = 'left Footed shot'  
GROUP BY g.PID, p.FIRST_NAME, p.LAST_NAME
ORDER BY LEFT_FOOT_GOALS DESC
LIMIT 1;

--21. What is the average age of players per team?

SELECT p.TEAM, ROUND(AVG(EXTRACT(YEAR FROM AGE(p.DOB))), 2) AS AVG_AGE
FROM players p
GROUP BY p.TEAM
ORDER BY AVG_AGE DESC;

--22. How many players are listed as playing for each team in a season?

SELECT p.TEAM, m.SEASON, COUNT(DISTINCT p.PLAYER_ID) AS TOTAL_PLAYERS
FROM players p
JOIN matches m ON p.TEAM = m.HOME_TEAM OR p.TEAM = m.AWAY_TEAM
GROUP BY p.TEAM, m.SEASON
ORDER BY m.SEASON, TOTAL_PLAYERS DESC;

--23. Which player has played in the most matches in each season?

SELECT m.SEASON, g.PID AS PLAYER_ID, p.FIRST_NAME, p.LAST_NAME, COUNT(DISTINCT g.MATCH_ID) AS MATCHES_PLAYED
FROM goals g
JOIN matches m ON g.MATCH_ID = m.MATCH_ID
JOIN players p ON g.PID = p.PLAYER_ID
GROUP BY m.SEASON, g.PID, p.FIRST_NAME, p.LAST_NAME
ORDER BY m.SEASON, MATCHES_PLAYED DESC;

--24. What is the most common position for players across all teams?

SELECT POSITIONS, COUNT(*) AS TOTAL_PLAYERS
FROM players
GROUP BY POSITIONS
ORDER BY TOTAL_PLAYERS DESC
LIMIT 1;

--25. Which players have never scored a goal?

SELECT p.PLAYER_ID, p.FIRST_NAME, p.LAST_NAME, p.TEAM
FROM players p
LEFT JOIN goals g ON p.PLAYER_ID = g.PID
WHERE g.GOAL_ID IS NULL;