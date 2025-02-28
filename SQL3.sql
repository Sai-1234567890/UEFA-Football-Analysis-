--MATCH ANALYSIS
--10. What was the highest-scoring match in a particular season?

SELECT m.MATCH_ID, m.SEASON, m.HOME_TEAM, m.AWAY_TEAM, 
       (m.HOME_TEAM_SCORE + m.AWAY_TEAM_SCORE) AS TOTAL_GOALS
FROM matches m
WHERE m.SEASON = '2021-2022'  
ORDER BY TOTAL_GOALS DESC
LIMIT 1;

--11. How many matches ended in a draw in a given season?

SELECT COUNT(*) AS DRAW_MATCHES
FROM matches
WHERE SEASON = '2021-2022'  
AND HOME_TEAM_SCORE = AWAY_TEAM_SCORE;

--12. Which team had the highest average score (home and away) in the season 2021-2022?

SELECT TEAM, ROUND(AVG(SCORE), 2) AS AVG_SCORE
FROM (
    SELECT HOME_TEAM AS TEAM, HOME_TEAM_SCORE AS SCORE FROM matches WHERE SEASON = '2021-2022'
    UNION ALL
    SELECT AWAY_TEAM AS TEAM, AWAY_TEAM_SCORE AS SCORE FROM matches WHERE SEASON = '2021-2022'
) AS team_scores
GROUP BY TEAM
ORDER BY AVG_SCORE DESC
LIMIT 1;

--13. How many penalty shootouts occurred in each season?

SELECT SEASON, COUNT(*) AS PENALTY_SHOOTOUTS
FROM matches
WHERE PENALTY_SHOOT_OUT > 0
GROUP BY SEASON
ORDER BY SEASON;

--14. What is the average attendance for home teams in the 2021-2022 season?

SELECT ROUND(AVG(ATTENDANCE), 2) AS AVG_ATTENDANCE
FROM matches
WHERE SEASON = '2021-2022';  

--15. Which stadium hosted the most matches in each season?

SELECT SEASON, STADIUM, COUNT(*) AS TOTAL_MATCHES
FROM matches
GROUP BY SEASON, STADIUM
ORDER BY SEASON, TOTAL_MATCHES DESC;

--16. What is the distribution of matches played in different countries in a season?

SELECT s.COUNTRY, COUNT(m.MATCH_ID) AS MATCH_COUNT
FROM matches m
JOIN stadium s ON m.STADIUM = s.NAME_S
WHERE m.SEASON = '2021-2022'  
GROUP BY s.COUNTRY
ORDER BY MATCH_COUNT DESC;

--17. What was the most common result in matches (home win, away win, draw)?

SELECT RESULT, COUNT(*) AS COUNT
FROM (
    SELECT MATCH_ID,
           CASE 
               WHEN HOME_TEAM_SCORE > AWAY_TEAM_SCORE THEN 'Home Win'
               WHEN AWAY_TEAM_SCORE > HOME_TEAM_SCORE THEN 'Away Win'
               ELSE 'Draw'
           END AS RESULT
    FROM matches
) AS match_results
GROUP BY RESULT
ORDER BY COUNT DESC;