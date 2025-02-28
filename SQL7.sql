--CROSS TABLE ANALYSIS

-- 38. Which players scored the most goals in matches held at a specific stadium?

SELECT p.FIRST_NAME, p.LAST_NAME, g.MATCH_ID, COUNT(*) AS goal_count
FROM goals g
JOIN Players p ON g.PID = p.PLAYER_ID
JOIN Matches m ON g.MATCH_ID = m.MATCH_ID
WHERE m.STADIUM = 'Red Bull Arena' -- Replace with actual stadium name
GROUP BY p.FIRST_NAME, p.LAST_NAME, g.MATCH_ID
ORDER BY goal_count DESC
LIMIT 1;


-- 39. Which team won the most home matches in the season 2021-2022?

SELECT HOME_TEAM, COUNT(*) AS home_wins
FROM Matches
WHERE SEASON = '2021-2022' AND HOME_TEAM_SCORE > AWAY_TEAM_SCORE
GROUP BY HOME_TEAM
ORDER BY home_wins DESC
LIMIT 1;

-- 40. Which players played for a team that scored the most goals in the 2021-2022 season?

SELECT DISTINCT p.FIRST_NAME, p.LAST_NAME, tg.total_goals
FROM Players p
JOIN (
    SELECT TEAM, SUM(SCORE) AS total_goals
    FROM (
        SELECT HOME_TEAM AS TEAM, HOME_TEAM_SCORE + AWAY_TEAM_SCORE AS SCORE 
        FROM Matches 
        WHERE SEASON = '2021-2022'
    ) AS TeamGoals
    GROUP BY TEAM
    ORDER BY total_goals DESC
    LIMIT 1
) tg ON p.TEAM = tg.TEAM;

-- 41. How many goals were scored by home teams in matches where attendance was above 50,000?

SELECT SUM(HOME_TEAM_SCORE) AS home_goals
FROM Matches
WHERE ATTENDANCE > 50000;

-- 42. Which players played in matches where the score difference was the highes

SELECT DISTINCT p.FIRST_NAME, p.LAST_NAME
FROM Players p
JOIN Goals g ON p.PLAYER_ID = g.PID
WHERE g.MATCH_ID = (
    SELECT MATCH_ID 
    FROM Matches 
    ORDER BY ABS(HOME_TEAM_SCORE - AWAY_TEAM_SCORE) DESC 
    LIMIT 1
);

-- 43. How many goals did players score in matches that ended in penalty shootouts?

SELECT COUNT(*) TOTAL_GOALS
FROM goals g
JOIN matches m ON g.MATCH_ID=m.MATCH_ID
WHERE m.PENALTY_SHOOT_OUT=1;

-- 44. What is the distribution of home team wins vs away team wins by country?

SELECT s.Country,
SUM(CASE WHEN m.HOME_TEAM_SCORE > m.AWAY_TEAM_SCORE THEN 1 ELSE 0 END) AS home_wins,
SUM(CASE WHEN m.AWAY_TEAM_SCORE > m.HOME_TEAM_SCORE THEN 1 ELSE 0 END) AS away_wins
FROM Matches m
JOIN Stadium s ON m.STADIUM = s.NAME_S
GROUP BY s.Country
ORDER BY home_wins DESC;

-- 45. Which team scored the most goals in the highest-attended matches?

SELECT p.TEAM , COUNT(*) AS total_goals
FROM Goals g
JOIN Players p ON g.PID = p.PLAYER_ID
WHERE g.MATCH_ID IN (
    SELECT MATCH_ID 
    FROM Matches 
    ORDER BY ATTENDANCE DESC 
    LIMIT 10
)
GROUP BY p.TEAM
ORDER BY total_goals DESC
LIMIT 1;

-- 46. Which players assisted the most goals in matches where their team lost?

SELECT p.FIRST_NAME, p.LAST_NAME, COUNT(*) AS assist_count
FROM Goals g
JOIN Players p ON g.ASSIST = p.PLAYER_ID
JOIN Matches m ON g.MATCH_ID = m.MATCH_ID
WHERE (m.HOME_TEAM = p.TEAM AND m.HOME_TEAM_SCORE < m.AWAY_TEAM_SCORE)
   OR (m.AWAY_TEAM = p.TEAM AND m.AWAY_TEAM_SCORE < m.HOME_TEAM_SCORE)
GROUP BY p.FIRST_NAME, p.LAST_NAME
ORDER BY assist_count DESC
LIMIT 3;

-- 47. What is the total number of goals scored by players who are positioned as defenders?

SELECT COUNT(*) AS TOTAL_GOALS FROM goals g
JOIN Players p on g.PID=p.PLAYER_ID
where p.POSITIONS='Defender';

-- 48. Which players scored goals in matches that were held in stadiums with a capacity over 60,000?

SELECT DISTINCT p.FIRST_NAME, p.LAST_NAME
FROM Goals g
JOIN Matches m ON g.MATCH_ID = m.MATCH_ID
JOIN Stadium s ON m.STADIUM = s.NAME_S
JOIN Players p ON g.PID = p.PLAYER_ID
WHERE s.Capacity > 60000;

-- 49. How many goals were scored in matches played in cities with specific stadiums in a season?

SELECT m.SEASON, s.City, COUNT(*) AS total_goals
FROM Matches m
JOIN Goals g ON m.MATCH_ID = g.MATCH_ID
JOIN Stadium s ON m.STADIUM = s.NAME_s
WHERE m.SEASON = '2021-2022' 
GROUP BY m.SEASON, s.City
ORDER BY total_goals DESC;

-- 50. Which players scored goals in matches with the highest attendance (over 100,000)?
SELECT DISTINCT p.FIRST_NAME, p.LAST_NAME
FROM Goals g
JOIN Matches m ON g.MATCH_ID = m.MATCH_ID
JOIN Players p ON g.PID = p.PLAYER_ID
WHERE m.ATTENDANCE > 100000;
