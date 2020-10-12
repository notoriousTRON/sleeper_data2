DROP VIEW data.rushing_stats_view; 
CREATE VIEW data.rushing_stats_view AS
SELECT
	game_id,
	posteam, 
	rusher_player_id,
	name,
	CAST(LEFT(game_id,4) AS character(4)) AS year,
	CAST(CAST(SUBSTRING(game_id,6,2) AS int) AS character(2)) AS week,
	SUBSTRING(game_id,6,2) AS week_padded,
	SUM(rush_attempt) AS rush_att, 
	SUM(yards_gained) AS rush_yds, 
	SUM(touchdown) AS rush_td,
	SUM(fumble_forced+fumble_not_forced+fumble_out_of_bounds) AS rush_fum, 
	SUM(fumble_lost) AS rush_fum_lost,
	SUM(CASE WHEN two_point_conv_result = 'success' THEN two_point_attempt ELSE 0 END) AS rush_2pt
FROM 
	nflfast.pbp_stats_tbl
WHERE 
	rush_attempt = 1
GROUP BY
	game_id, posteam, rusher_player_id, name
