DROP VIEW data.rushing_stats_view; 
CREATE VIEW data.rushing_stats_view AS
SELECT
	rush.game_id
	,rush.posteam
	,rush.rusher_player_id
	,rush.rusher_player_name
	,rush.year
	,rush.week
	,rush.week_padded
	,rush.rush_att
	,rush.rush_yds
	,rush.rush_yds * s.rush_yds_pts AS rush_yd_pts
	,rush.rush_td
	,rush.rush_td * s.rush_td_pts AS rush_td_pts
	,rush.rush_fum
	,rush.rush_fum_lost
	,rush.rush_fum_lost * s.fum_lost_pts_pts AS fum_lost_pts_pts
	,rush.rush_2pt
	,rush.rush_2pt * s.rush_2pt_pts AS rush_2pt_pts
FROM
	(
	SELECT
		game_id,
		posteam, 
		rusher_player_id,
		rusher_player_name,
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
		game_id, posteam, rusher_player_id, rusher_player_name
	) rush
LEFT JOIN
	data.scoring_rules s
ON
	rush.year = s.year