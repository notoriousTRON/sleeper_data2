SELECT
	top.*
    ,tm.display_name
    ,tm.team_name
FROM
    (
    SELECT
        mp.player_id
        ,CONCAT(pl.first_name,' ',pl.last_name) AS full_name
        ,pl.fantasy_positions AS position
        ,COUNT(DISTINCT mp.week) AS starts
        ,SUM(s.any_pts)/COUNT(DISTINCT mp.week) AS points_per_start
        ,SUM(s.any_pts) AS total_points
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
    WHERE
        mp.is_starter = True AND
        mp.year = '2019' AND
        mp.week IN ('1','2','3','4','5','6','7','8','9',
                    '10','11','12','13') 
        --AND position = 'QB'            
    GROUP BY
        mp.player_id
        ,CONCAT(pl.first_name,' ',pl.last_name)
        ,pl.fantasy_positions
    --ORDER BY
        --pl.fantasy_positions,
        --SUM(s.any_pts) DESC
        --CONCAT(pl.first_name,' ',pl.last_name)
    ) top
LEFT JOIN
    (
    SELECT
        r.player_id
        ,mp.display_name
        ,mp.team_name
    FROM
        map_user_roster_tbl mp
    LEFT JOIN
        rosters_tbl r
    ON
        mp.roster_id = r.roster_id
    ) tm
ON
	top.player_id = tm.player_id
WHERE
	--POSITION IN ('{QB}')
	POSITION IN ('{RB}')
	--POSITION IN ('{WR}')-- AND top.player_id = '2309'
	--POSITION IN ('{TE}')
	--POSITION IN ('{RB}','{WR}','{TE}')
    --POSITION IN ('{DEF}')
    --POSITION IN ('{K}')
ORDER BY
	--top.position
    top.total_points DESC