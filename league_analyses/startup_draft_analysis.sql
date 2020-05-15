COPY (
SELECT
	u.display_name
	,d.round
	,d.pick_no
	,d.overall_pick_no
	,pl.player_id
	,CONCAT(TRIM(pl.first_name),' ',TRIM(pl.last_name)) AS full_name
	,pl.position
	,s.any_pts AS pts
	,s.points_above_replacement
	,s.avg_points_above_replacement
FROM
	draft_tbl d
LEFT JOIN
	players_tbl pl
ON
	d.player_id = pl.player_id
LEFT JOIN
	map_user_roster_tbl u
ON
	d.roster_id = u.roster_id
LEFT JOIN
	(
	SELECT
		player_id
		,SUM(any_pts) AS any_pts
		,SUM(points_above_replacement) AS points_above_replacement
		,AVG(points_above_replacement) AS avg_points_above_replacement
	FROM
		(
		SELECT
			s.year
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
		) i
	WHERE
		year = '2019'
	GROUP BY
		player_id
	) s
ON
	d.player_id = s.player_id
WHERE
	draft_year = '2019' --AND u.display_name = 'notoriousTRON'
ORDER BY
	CAST(d.round AS INT), CAST(d.pick_no AS INT)
) TO 'C:\projects\sleeper_data\data\startup_draft_analysis.csv'
DELIMITER ',' CSV HEADER;