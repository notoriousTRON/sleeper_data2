SELECT
	display_name
	,team_name
	,SUM(any_pts) AS total_proj_pts
FROM (
    SELECT
        r.user_id
    	,u.display_name
    	,CASE WHEN u.team_name IS NULL THEN u.display_name ELSE u.team_name END AS team_name
        ,CASE WHEN pl.position = 'DEF' THEN r.player_id ELSE pl.full_name END AS Full_Name
        ,pl.position
        ,pr.any_pts
    FROM
        rosters_tbl r
    LEFT JOIN
        projections_tbl pr
    ON
        r.player_id = pr.player_id
    LEFT JOIN
        players_tbl pl
    ON
        r.player_id = pl.player_id
   	LEFT JOIN
    	users_tbl u
    ON
    	r.user_id = u.user_id
   ) tbl_a
GROUP BY 
	display_name
	,team_name
ORDER BY
	total_proj_pts DESC