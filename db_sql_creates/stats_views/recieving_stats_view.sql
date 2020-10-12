DROP VIEW data.receiving_stats_view; 
CREATE VIEW data.receiving_stats_view AS
SELECT
	rec.game_id
	,rec.posteam
	,rec.receiver_player_id
	,rec.receiver_player_name
	,rec.year
	,rec.week
	,rec.week_padded
	,rec.rec_tgt
	,rec.rec
	,rec.rec * s.rec_pts AS rec_pts
	,rec.rec_yd
	,rec.rec_yd * s.rec_yds_pts AS rec_yd_pts
	,rec.rec_td
	,rec.rec_td * s.rec_td_pts AS rec_td_pts
	,rec.rec_fum
	,rec.rec_fum_lost
	,rec.rec_fum_lost * s.fum_lost_pts_pts AS fum_lost_pts_pts
	,rec.rec_2pt
	,rec.rec_2pt * s.rec_2pt_pts AS rec_2pt_pts
FROM
	(
	SELECT
		game_id,
		posteam, 
		receiver_player_id,
		receiver_player_name,
		CAST(LEFT(game_id,4) AS character(4)) AS year,
		CAST(CAST(SUBSTRING(game_id,6,2) AS int) AS character(2)) AS week,
		SUBSTRING(game_id,6,2) AS week_padded,
		SUM(pass_attempt) AS rec_tgt, 
		SUM(complete_pass) AS rec,
		SUM(yards_gained) AS rec_yd, 
		SUM(touchdown) AS rec_td,
		SUM(fumble_forced+fumble_not_forced+fumble_out_of_bounds) AS rec_fum, 
		SUM(fumble_lost) AS rec_fum_lost,
		SUM(CASE WHEN two_point_conv_result = 'success' THEN two_point_attempt ELSE 0 END) AS rec_2pt
	FROM 
		nflfast.pbp_stats_tbl
	WHERE 
		pass_attempt = 1 AND qb_spike = 0 AND sack = 0 AND receiver_player_name IS NOT NULL
	GROUP BY
		game_id, posteam, receiver_player_id, receiver_player_name
	) rec
LEFT JOIN
	data.scoring_rules s
ON
	rec.year = s.year