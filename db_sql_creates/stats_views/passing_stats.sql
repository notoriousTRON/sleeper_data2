DROP VIEW data.passing_stats_view; 
CREATE VIEW data.passing_stats_view AS
SELECT
	pass.game_id
	,pass.posteam
	,pass.passer_id
	,pass.passer_player_name
	,pass.year
	,pass.week
	,pass.week_padded
	,pass.pass_att
	,pass.pass_cmp
	,pass.pass_yd
	,pass.pass_yd * s.pass_yd_pts AS pass_yd_pts
	,pass.pass_td
	,pass.pass_td * s.pass_td_pts AS pass_td_pts
	,pass.pass_int
	,pass.pass_int * s.int_pts AS pass_int_pts
	,pass.pass_fum
	,pass.pass_fum_lost
	,pass.pass_fum_lost * s.fum_lost_pts_pts AS fum_lost_pts_pts
	,pass.pass_2pt
	,pass.pass_2pt * s.pass_2pt_pts AS pass_2pt_pts
FROM
	(
	SELECT
		game_id, 
		posteam, 
		passer_id,
		passer_player_name,
		CAST(LEFT(game_id,4) AS character(4)) AS year,
		CAST(CAST(SUBSTRING(game_id,6,2) AS int) AS character(2)) AS week,
		SUBSTRING(game_id,6,2) AS week_padded,
		SUM(pass_attempt) AS pass_att, 
		SUM(complete_pass) AS pass_cmp, 
		SUM(complete_pass * yards_gained) AS pass_yd,
		SUM(touchdown) AS pass_td, 
		SUM(interception) AS pass_int,
		SUM(fumble_forced+fumble_not_forced+fumble_out_of_bounds) AS pass_fum, 
		SUM(fumble_lost) AS pass_fum_lost,	
		SUM(CASE WHEN two_point_conv_result = 'success' THEN two_point_attempt ELSE 0 END) AS pass_2pt
	FROM 
		nflfast.pbp_stats_tbl
	WHERE 
		pass_attempt = 1 AND qb_spike = 0
	GROUP BY
		game_id, posteam, passer_id, passer_player_name
	) pass
LEFT JOIN
	data.scoring_rules s
ON
	pass.year = s.year