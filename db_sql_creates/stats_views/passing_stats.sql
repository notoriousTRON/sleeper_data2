DROP VIEW data.passing_stats_view;
CREATE VIEW data.passing_stats_view AS
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
