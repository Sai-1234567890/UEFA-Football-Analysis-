--ADDITIONAL COMPLEX QUERIES

--51. What is the average number of goals scored by each team in the first 30 minutes of a match

SELECT goals_30.TEAM, 
       ROUND(AVG(goals_30.TOTAL_GOALS), 2) AS AVG_GOALS_FIRST_30_MIN
FROM (
    SELECT g.PID, p.TEAM, COUNT(g.GOAL_ID) AS TOTAL_GOALS
    FROM goals g
    JOIN players p ON g.PID = p.PLAYER_ID
    WHERE g.DURATION <= 30  
    GROUP BY g.PID, p.TEAM
) AS goals_30
GROUP BY goals_30.TEAM
ORDER BY AVG_GOALS_FIRST_30_MIN DESC;

--52. Which stadium had the highest average score difference between home and away teams?

SELECT m.STADIUM,ROUND(AVG(ABS(m.HOME_TEAM_SCORE - m.AWAY_TEAM_SCORE)), 2) AS AVG_SCORE_DIFF
FROM matches m
GROUP BY m.STADIUM
ORDER BY AVG_SCORE_DIFF DESC
LIMIT 1;

--53. How many players scored in every match they played during a given season?

SELECT g.PID AS PLAYER_ID, p.FIRST_NAME, p.LAST_NAME, COUNT(DISTINCT g.MATCH_ID) AS MATCHES_PLAYED
FROM goals g
JOIN players p ON g.PID = p.PLAYER_ID
JOIN matches m ON g.MATCH_ID = m.MATCH_ID
WHERE m.SEASON = '2021-2022'  
GROUP BY g.PID, p.FIRST_NAME, p.LAST_NAME
HAVING COUNT(DISTINCT g.MATCH_ID) = ( 
    SELECT COUNT(DISTINCT m2.MATCH_ID) 
    FROM matches m2 
    WHERE m2.SEASON = '2021-2022' 
    AND m2.MATCH_ID IN (SELECT g2.MATCH_ID FROM goals g2 WHERE g2.PID = g.PID)
);

--54. Which teams won the most matches with a goal difference of 3 or more in the 2021-2022 season?

SELECT 
    CASE 
        WHEN HOME_TEAM_SCORE > AWAY_TEAM_SCORE THEN HOME_TEAM 
        ELSE AWAY_TEAM 
    END AS WINNING_TEAM, 
    COUNT(*) AS MATCHES_WON
FROM matches
WHERE SEASON = '2021-2022'
AND ABS(HOME_TEAM_SCORE - AWAY_TEAM_SCORE) >= 3
GROUP BY WINNING_TEAM
ORDER BY MATCHES_WON DESC;

--55. Which player from a specific country has the highest goals per match ratio?

SELECT p.FIRST_NAME, p.LAST_NAME, p.NATIONALITY, ROUND(COUNT(g.GOAL_ID) * 1.0 / COUNT(DISTINCT g.MATCH_ID), 2) AS GOALS_PER_MATCH
FROM goals g
JOIN players p ON g.PID = p.PLAYER_ID
JOIN matches m ON g.MATCH_ID = m.MATCH_ID
WHERE p.NATIONALITY = 'Argentina'  -- Change the country as needed
GROUP BY p.PLAYER_ID, p.FIRST_NAME, p.LAST_NAME, p.NATIONALITY
ORDER BY GOALS_PER_MATCH DESC
LIMIT 1;