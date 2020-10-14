DROP VIEW data.def_stats_view; 
CREATE VIEW data.def_stats_view AS
SELECT
	c.game_id
	,c.team
	,c.year
	,c.week
	,c.week_padded
	,c.yds_allowed
	,c.pts_allowed
	,c.def_sacks
	,c.def_sacks * s.def_sacks_pts AS def_sacks_pts
	,c.def_int
	,c.def_int * s.def_int_pts AS def_int_pts
	,c.def_fum
	,c.def_fum * s.def_fr_pts AS def_fr_pts
	,c.def_blocked
	,c.def_blocked * s.def_blocked_kick_pts AS def_blocked_kick_pts
	,c.def_td
	,c.def_td * s.def_st_td_pts AS def_st_td_pts
	,c.st_td
	,c.st_td * s.st_td_pts AS st_td_pts
	,(CASE WHEN c.pts_allowed = 0 THEN 1 ELSE 0 END) * s.def_pa_0_pts AS def_pa_0_pts
	,(CASE WHEN c.pts_allowed BETWEEN 1 AND 6 THEN 1 ELSE 0 END) * s.def_pa_1_6_pts AS def_pa_1_6_pts
	,(CASE WHEN c.pts_allowed BETWEEN 7 AND 13 THEN 1 ELSE 0 END) * s.def_pa_7_13_pts AS def_pa_7_13_pts
	,(CASE WHEN c.pts_allowed BETWEEN 14 AND 20 THEN 1 ELSE 0 END) * s.def_pa_14_20_pts AS def_pa_14_20_pts
	,(CASE WHEN c.pts_allowed BETWEEN 21 AND 27 THEN 1 ELSE 0 END) * s.def_pa_21_27_pts AS def_pa_21_27_pts
	,(CASE WHEN c.pts_allowed BETWEEN 28 AND 34 THEN 1 ELSE 0 END) * s.def_pa_28_34_pts AS def_pa_28_34_pts
	,(CASE WHEN c.pts_allowed >= 35 THEN 1 ELSE 0 END) * s.def_pa_35_pts AS def_pa_35_pts
FROM
	(
	SELECT
		a.game_id
		,CASE WHEN a.defteam = 'LA' THEN 'LAR' ELSE a.defteam END AS team
		,CAST(LEFT(a.game_id,4) AS character(4)) AS year
		,CAST(CAST(SUBSTRING(a.game_id,6,2) AS int) AS character(2)) AS week
		,SUBSTRING(a.game_id,6,2) AS week_padded
		,SUM(a.yards_gained) AS yds_allowed
		,SUM(a.pass_touchdown+a.rush_touchdown) * 6 + 
			SUM(CASE WHEN b.turnovers_tds_allowed IS NULL THEN 0 ELSE b.turnovers_tds_allowed END) * 6 +
			SUM(CASE WHEN a.extra_point_attempt = 1 AND a.extra_point_result = 'good' THEN 1 ELSE 0 END) * 1 +
			SUM(CASE WHEN a.field_goal_attempt = 1 AND a.field_goal_result = 'made' THEN 1 ELSE 0 END) * 3 +
			SUM(CASE WHEN a.two_point_attempt = 1 AND a.two_point_conv_result = 'success' THEN 1 ELSE 0 END) * 2
			AS pts_allowed
		,SUM(CASE WHEN (interception = 1 OR fumble_lost = 1) AND return_touchdown = 1 THEN 1 ELSE 0 END) AS def_td
		,SUM(a.sack) AS def_sacks
		,SUM(a.interception) AS def_int
		,SUM(a.fumble_lost) AS def_fum
		,SUM(CASE WHEN a.punt_blocked = 1 OR a.field_goal_result = 'blocked' OR extra_point_result = 'blocked' THEN 1 ELSE 0 END) AS def_blocked
		,SUM(CASE WHEN (a.punt_blocked = 1 OR a.field_goal_result = 'blocked' OR extra_point_result = 'blocked') AND return_touchdown = 1 THEN 1 ELSE 0 END) +
			(CASE WHEN SUM(b.st_td) IS NULL THEN 0 ELSE SUM(b.st_td) END) AS st_td
	FROM
		nflfast.pbp_stats_tbl a
	LEFT JOIN
		(
		SELECT
			game_id
			,CASE WHEN posteam = 'LA' THEN 'LAR' ELSE posteam END AS posteam
			,SUM(CASE WHEN interception = 1 AND return_touchdown = 1 THEN 1 ELSE 0 END) +
				SUM(CASE WHEN fumble_lost = 1 AND return_touchdown = 1 THEN 1 ELSE 0 END) AS turnovers_tds_allowed
			,SUM(CASE WHEN play_type IN ('punt','kickoff') AND return_touchdown = 1 THEN 1 ELSE 0 END) AS st_td
		FROM
			nflfast.pbp_stats_tbl
		GROUP BY
			game_id,posteam
		) b
	ON
		a.game_id = b.game_id AND
		a.defteam = b.posteam AND
		(a.interception = 1 OR a.fumble_lost = 1)
	WHERE
		a.defteam IS NOT NULL
	GROUP BY
		a.game_id,a.defteam	
	) c
LEFT JOIN
	data.scoring_rules s
ON
	c.year = s.year