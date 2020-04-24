SELECT
	display_name
    --,user_id
    ,SUM(points) AS total_points
    ,SUM(possible_pts) AS possible_pts
    ,SUM(points) / SUM(possible_pts) * 100 AS manager_efficency
    ,CONCAT(SUM(win),' - ',SUM(loss)) AS record
    ,CONCAT(SUM(max_win),' - ',SUM(max_loss)) AS would_be_record
    ,CONCAT(SUM(top_6_win),' - ',SUM(top_6_loss)) AS top6_record
    ,SUM(CASE WHEN win = 0 AND max_win = 1 THEN 1 ELSE 0 END) AS lineup_mistake_losses
    ,SUM(CASE WHEN win = 1 AND max_win = 0 THEN 1 ELSE 0 END) AS opponent_mistake_wins
    ,SUM(CASE WHEN win = 1 AND top_6_win = 0 THEN 1 ELSE 0 END) AS weak_opponent_wins
    ,SUM(CASE WHEN win = 0 AND top_6_win = 1 THEN 1 ELSE 0 END) AS strong_opponent_loss
FROM (
    SELECT
        m.year
        ,m.week
        ,m.matchup_id
        ,m.roster_id
        ,usr.display_name
        ,usr.user_id
        ,m.points
        ,CASE WHEN RANK() OVER(PARTITION BY m.year, m.week, m.matchup_id ORDER BY m.points DESC) = 1 THEN 1 ELSE 0 END AS win
        ,CASE WHEN RANK() OVER(PARTITION BY m.year, m.week, m.matchup_id ORDER BY m.points DESC) = 1 THEN 0 ELSE 1 END AS loss
        ,mp.possible_pts
        ,CASE WHEN RANK() OVER(PARTITION BY m.year, m.week, m.matchup_id ORDER BY mp.possible_pts DESC) = 1 THEN 1 ELSE 0 END AS max_win
        ,CASE WHEN RANK() OVER(PARTITION BY m.year, m.week, m.matchup_id ORDER BY mp.possible_pts DESC) = 1 THEN 0 ELSE 1 END AS max_loss
    	,CASE WHEN RANK() OVER(PARTITION BY m.year, m.week ORDER BY mp.possible_pts DESC) <= 6 THEN 1 ELSE 0 END AS top_6_win
    	,CASE WHEN RANK() OVER(PARTITION BY m.year, m.week ORDER BY mp.possible_pts DESC) <= 6 THEN 0 ELSE 1 END AS top_6_loss
    FROM
        matchups_tbl m
    LEFT JOIN
        map_user_roster_tbl usr
    ON
        m.roster_id = usr.roster_id
    LEFT JOIN (
        SELECT 
            year
            ,week
            ,display_name
            ,user_id
            ,SUM(started_pts) AS total_pts
            ,SUM(max_pts) AS possible_pts
        FROM
            manager_effectiveness_view
        GROUP BY
            year
            ,week
            ,display_name
            ,user_id
       ) mp
    ON
        usr.user_id = mp.user_id AND
        m.year = mp.year AND
        m.week = mp.week
   ) mp1
GROUP BY
	display_name
    ,user_id
ORDER BY
	manager_efficency DESC