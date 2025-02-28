--1.)Which player scored the most goals in each season?

SELECT m.SEASON, p.FIRST_NAME, p.LAST_NAME, COUNT(g.GOAL_ID) AS TOTAL_GOALS
FROM goals g
JOIN matches m ON g.MATCH_ID = m.MATCH_ID
JOIN players p ON g.PID = p.PLAYER_ID
GROUP BY m.SEASON, p.FIRST_NAME, p.LAST_NAME
HAVING COUNT(g.GOAL_ID) = (
    SELECT MAX(goal_count)
    FROM (
        SELECT m.SEASON, p.PLAYER_ID, COUNT(g.GOAL_ID) AS goal_count
        FROM goals g
        JOIN matches m ON g.MATCH_ID = m.MATCH_ID
        JOIN players p ON g.PID = p.PLAYER_ID
        GROUP BY m.SEASON, p.PLAYER_ID
    ) AS season_goals
    WHERE season_goals.SEASON = m.SEASON
)
ORDER BY m.SEASON;

--2.)How many goals did each player score in a given season?

SELECT m.SEASON, p.FIRST_NAME, p.LAST_NAME, COUNT(g.GOAL_ID) AS TOTAL_GOALS
FROM goals g
JOIN matches m ON g.MATCH_ID = m.MATCH_ID
JOIN players p ON g.PID = p.PLAYER_ID
WHERE m.SEASON = '2021-2022' 
GROUP BY m.SEASON, p.FIRST_NAME, p.LAST_NAME
ORDER BY TOTAL_GOALS DESC;

--3.)Total number of goals scored in ‘mt403’ match
SELECT COUNT(g.GOAL_ID) AS TOTAL_GOALS
FROM goals g
WHERE g.MATCH_ID = 'mt403';

--4.)Which player assisted the most goals in each season?

SELECT p.FIRST_NAME,p.LAST_NAME,m.SEASON,COUNT(g.GOAL_ID) AS TOTAL_ASSISTS
FROM goals g
JOIN matches m ON g.MATCH_ID = m.MATCH_ID
JOIN players p ON g.PID = p.PLAYER_ID
WHERE g.ASSIST IS NOT NULL
GROUP BY m.SEASON, p.FIRST_NAME, p.LAST_NAME
HAVING COUNT(g.GOAL_ID)=(
    SELECT MAX(assist_count)
	FROM(
          SELECT m.SEASON,p.PLAYER_ID,COUNT(g.GOAL_ID) AS assist_count
		    FROM goals g
        JOIN matches m ON g.MATCH_ID = m.MATCH_ID
        JOIN players p ON g.ASSIST = p.PLAYER_ID
        WHERE g.ASSIST IS NOT NULL
        GROUP BY m.SEASON, p.PLAYER_ID
    ) AS season_assists
    WHERE season_assists.SEASON = m.SEASON
)
ORDER BY m.SEASON;

--5.)Which players have scored goals in more than 10 matches?

SELECT p.FIRST_NAME, p.LAST_NAME, COUNT(DISTINCT g.MATCH_ID) AS MATCHES_PLAYED
FROM goals g
JOIN players p ON g.PID = p.PLAYER_ID
GROUP BY p.FIRST_NAME, p.LAST_NAME
HAVING COUNT(DISTINCT g.MATCH_ID)>10
ORDER BY MATCHES_PLAYED DESC;

--6.)What is the average number of goals scored per match in a given season?

SELECT m.SEASON, ROUND(AVG(m.HOME_TEAM_SCORE + m.AWAY_TEAM_SCORE), 2) AS AVG_GOALS_PER_MATCH
FROM matches m
WHERE m.SEASON = '2021-2022'  
GROUP BY m.SEASON;

--7.)Which player has the most goals in a single match?

SELECT g.PID AS PLAYER_ID, p.FIRST_NAME, p.LAST_NAME, g.MATCH_ID, COUNT(g.GOAL_ID) AS TOTAL_GOALS
FROM goals g
JOIN players p ON g.PID = p.PLAYER_ID
GROUP BY g.PID, p.FIRST_NAME, p.LAST_NAME, g.MATCH_ID
ORDER BY TOTAL_GOALS DESC
LIMIT 1;

--8. Which team scored the most goals in all seasons?

SELECT p.TEAM,COUNT(g.GOAL_ID) AS T_G
FROM goals g
JOIN players p ON g.PID = p.PLAYER_ID
WHERE p.TEAM IS NOT NULL
GROUP BY p.TEAM
ORDER BY T_G DESC
LIMIT 1

--9.) Which stadium hosted the most goals scored in a single season?

SELECT m.STADIUM, m.SEASON, SUM(m.HOME_TEAM_SCORE + m.AWAY_TEAM_SCORE) AS TOTAL_GOALS
FROM matches m
GROUP BY m.STADIUM, m.SEASON
ORDER BY TOTAL_GOALS DESC
LIMIT 1;
LIMIT 1;
