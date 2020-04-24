COPY (
SELECT
    s.year
    ,s.week
	,CASE WHEN u.display_name IS NULL THEN 'FA' ELSE u.display_name END AS owner
	,CASE WHEN u.display_name IS NULL THEN 'Free Agent' 
		  WHEN u.team_name IS NULL THEN u.display_name ELSE u.team_name END AS team
    ,pl.position
    ,s.player_id
    ,CONCAT(TRIM(pl.first_name),' ',TRIM(pl.last_name)) AS full_name
    ,s.any_pts
    ,RANK() OVER(PARTITION BY s.year, s.week, pl.position ORDER BY s.any_pts DESC) AS posRank_week
    --,CASE WHEN pl.position = 'QB' AND RANK() OVER(PARTITION BY s.year, s.week, pl.position ORDER BY s.any_pts DESC) <= 12 THEN 1 ELSE 0 END AS starter
    --,AVG(s.any_pts) OVER(PARTITION BY s.year, s.week, pl.position)
    ,s.any_pts - ws.replacement AS points_above_replacement
    ,s.any_pts - ws.avg_starter AS pts_above_avg_starter
    ,(s.any_pts - ws.avg_starter)/ws.sd_starter AS zscore_above_avg_starter
	,s.pass_att
	,s.pass_cmp
	,s.pass_int
	,s.pass_td
	,s.pass_yd
	,s.pass_2pt
	,s.rush_att
	,s.rush_yd
	,s.rush_td
	,s.rush_2pt
	,s.fum
	,s.fum_lost
	,s.rec
	,s.rec_tgt
	,s.rec_yd
	,s.rec_td
	,s.rec_2pt
	,s.fga
	,s.fgm
	,s.xpa
	,s.xpm
	,s.fgm_50p
	,s.fgm_40_49
	,s.fgm_30_39
	,s.fgm_20_29
FROM
    stats_tbl s
LEFT JOIN
    players_tbl pl
ON
    s.player_id = pl.player_id
LEFT JOIN
	rosters_tbl r
ON
	r.player_id = pl.player_id
LEFT JOIN
	map_user_roster_tbl u
ON
	r.roster_id = u.roster_id
LEFT JOIN
	weekly_position_scoring_view ws
ON
	s.year = ws.year AND
    s.week = ws.week AND
    pl.position = ws.position
WHERE
    pl.position IN ('QB','RB','WR','TE','K','DEF')
    --pl.position IN ('QB')
ORDER BY
    s.any_pts DESC
) TO 'P:\Projects\sleeper_data\data\points_above_replacement.csv'
   DELIMITER ',' CSV HEADER;