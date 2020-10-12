DROP VIEW data.kicking_stats_view; 
CREATE VIEW data.kicking_stats_view AS
SELECT
	kick.game_id
	,kick.posteam
	,kick.kicker_player_id
	,kick.kicker_player_name
	,kick.year
	,kick.week
	,kick.week_padded
	,kick.fg_attempt
	,kick.fg_missed
	,kick.fg_missed * s.fg_missed_pts AS fg_missed_pts
	,kick.fg_0_19_made
	,kick.fg_0_19_made * s.fg_0_19_pts AS fg_0_19_pts
	,kick.fg_20_29_made
	,kick.fg_20_29_made * s.fg_20_29_pts AS fg_20_29_pts
	,kick.fg_30_39_made
	,kick.fg_30_39_made * s.fg_30_39_pts AS fg_30_39_pts
	,kick.fg_40_49_made
	,kick.fg_40_49_made * s.fg_40_49_pts AS fg_40_49_pts
	,kick.fg_50_made
	,kick.fg_50_made * s.fg_50_pts AS fg_50_pts
	,kick.xp_attempt
	,kick.xp_made
	,kick.xp_made * s.pat_pts AS xp_pts
	,kick.xp_missed
	,kick.xp_missed * s.pat_missed_pts AS xp_missed_pts
FROM
	(
	SELECT
		game_id
		,posteam
		,kicker_player_id
		,kicker_player_name
		,CAST(LEFT(game_id,4) AS character(4)) AS year
		,CAST(CAST(SUBSTRING(game_id,6,2) AS int) AS character(2)) AS week
		,SUBSTRING(game_id,6,2) AS week_padded
		,SUM(CASE WHEN field_goal_attempt = 1 THEN 1 ELSE 0 END) AS fg_attempt
		,SUM(CASE WHEN field_goal_attempt = 1 AND field_goal_result = 'missed' THEN 1 ELSE 0 END) AS fg_missed
		,SUM(CASE WHEN field_goal_attempt = 1 AND field_goal_result = 'made' AND kick_distance BETWEEN 0 AND 19 THEN 1 ELSE 0 END) AS fg_0_19_made
		,SUM(CASE WHEN field_goal_attempt = 1 AND field_goal_result = 'made' AND kick_distance BETWEEN 20 AND 29 THEN 1 ELSE 0 END) AS fg_20_29_made
		,SUM(CASE WHEN field_goal_attempt = 1 AND field_goal_result = 'made' AND kick_distance BETWEEN 30 AND 39 THEN 1 ELSE 0 END) AS fg_30_39_made
		,SUM(CASE WHEN field_goal_attempt = 1 AND field_goal_result = 'made' AND kick_distance BETWEEN 40 AND 49 THEN 1 ELSE 0 END) AS fg_40_49_made
		,SUM(CASE WHEN field_goal_attempt = 1 AND field_goal_result = 'made' AND kick_distance >= 50 THEN 1 ELSE 0 END) AS fg_50_made
		,SUM(CASE WHEN extra_point_attempt = 1 THEN 1 ELSE 0 END) AS xp_attempt
		,SUM(CASE WHEN extra_point_attempt = 1 AND extra_point_result = 'good' THEN 1 ELSE 0 END) AS xp_made
		,SUM(CASE WHEN extra_point_attempt = 1 AND extra_point_result = 'failed' THEN 1 ELSE 0 END) AS xp_missed
	FROM 
		nflfast.pbp_stats_tbl
	WHERE
		field_goal_attempt = 1 OR extra_point_attempt = 1
	GROUP BY
		game_id,posteam,kicker_player_id,kicker_player_name
	) kick
LEFT JOIN
	data.scoring_rules s
ON
	kick.year = s.year