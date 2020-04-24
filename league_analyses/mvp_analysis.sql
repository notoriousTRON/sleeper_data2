SELECT
	CONCAT(pl.first_name,' ',pl.last_name) AS full_name
    ,pl.fantasy_positions AS position
    ,usr.display_name
    ,usr.team_name
    ,tp.total_points AS team_tot_pts
    ,tp.record AS team_record
    ,COUNT(DISTINCT mp.week) AS starts
    ,SUM(s.any_pts)/COUNT(DISTINCT mp.week) AS points_per_start
    ,SUM(s.any_pts) AS total_points
    ,SUM(s.any_pts)/tp.total_points * 100 AS pct_team_production
FROM
	matchups_plr_tbl mp
LEFT JOIN
   	stats_tbl s
ON
	mp.year = s.year AND
	mp.week = s.week AND
    mp.player_id = s.player_id
LEFT JOIN
    players_tbl pl
ON
	mp.player_id = pl.player_id
LEFT JOIN
	map_user_roster_tbl usr
ON
	mp.roster_id = usr.roster_id
LEFT JOIN
	(
    SELECT
        roster_id
        ,SUM(points) AS total_points
        ,CONCAT(SUM(win),' - ',SUM(loss)) AS record
    FROM
        (
        SELECT 
            roster_id
            ,points
            ,CASE WHEN RANK() OVER(PARTITION BY year,week,matchup_id ORDER BY points DESC) = 1 THEN 1 ELSE 0 END AS win
            ,CASE WHEN RANK() OVER(PARTITION BY year,week,matchup_id ORDER BY points DESC) = 1 THEN 0 ELSE 1 END AS loss
        FROM
            matchups_tbl
        ) a
    GROUP BY
        roster_id
    ) tp
ON
	mp.roster_id = tp.roster_id
WHERE
	mp.is_starter = True AND
    mp.year = '2019'
GROUP BY
	CONCAT(pl.first_name,' ',pl.last_name)
    ,pl.fantasy_positions
    ,usr.display_name
    ,usr.team_name
    ,tp.total_points
    ,tp.record
ORDER BY
	SUM(s.any_pts)/tp.total_points DESC
    --pl.full_name