--SELECT * FROM data.player_yr_week_view WHERE week IN ('1','2','3','4')--players 30052;
--Still needs def data to be added
DROP TABLE IF EXISTS data.game_log_tbl;
CREATE TABLE data.game_log_tbl AS
SELECT
	p.year||p.week||p.player_id AS week_player_id
	,p.year
	,p.week
	,p.player_id
	,p.gsis_id
	,CASE WHEN pass.posteam IS NOT NULL THEN pass.posteam
		  WHEN rush.posteam IS NOT NULL THEN rush.posteam
		  WHEN rec.posteam IS NOT NULL THEN rec.posteam
		  END AS team
	,p.position
	,p.first_name
	,p.last_name
	,p.first_name||' '||p.last_name AS full_name
	,p.years_exp
	,p.status
	,p.age
	,pass.pass_att
	,pass.pass_cmp
	,pass.pass_yd
	,pass.pass_td
	,pass.pass_int
	,pass.pass_2pt
	,rush.rush_att
	,rush.rush_yds
	,rush.rush_td
	,rush.rush_2pt
	,pass.pass_fum + rush.rush_fum AS fum
	,pass.pass_fum_lost + rush.rush_fum_lost fum_lost
	,rec.rec_tgt
	,rec.rec
	,rec.rec_yd
	,rec.rec_td
	,rec.rec_fum
	,rec.rec_fum_lost
	,rec.rec_2pt
	,kick.fg_attempt
	,kick.fg_missed
	,kick.fg_0_19_made
	,kick.fg_20_29_made
	,kick.fg_30_39_made
	,kick.fg_40_49_made
	,kick.fg_50_made
	,kick.xp_attempt
	,kick.xp_made
	,kick.xp_missed
	,pass.pass_yd_pts + pass.pass_td_pts + pass.pass_int_pts + pass.fum_lost_pts_pts + pass.pass_2pt_pts AS any_pass_pts
	,rush.rush_yd_pts + rush.rush_td_pts + rush.fum_lost_pts_pts + rush.rush_2pt_pts AS any_rush_pts
	,rec.rec_pts + rec.rec_yd_pts + rec.rec_td_pts + rec.fum_lost_pts_pts + rec.rec_2pt_pts AS any_rec_pts
	,fg_missed_pts + fg_0_19_pts + fg_20_29_pts + fg_30_39_pts + fg_40_49_pts + fg_50_pts + xp_pts + xp_missed_pts AS any_k_pts
FROM
	(SELECT * FROM data.player_yr_week_view WHERE CAST(week AS int) IN (1,2,3,4)) p
LEFT JOIN
	data.passing_stats_view pass
ON
	p.gsis_id = pass.passer_id AND
	p.year = pass.year AND CAST(p.week AS INT) = CAST(pass.week AS INT)
LEFT JOIN	
	data.rushing_stats_view rush
ON
	p.gsis_id = rush.rusher_player_id AND
	p.year = rush.year AND CAST(p.week AS INT) = CAST(rush.week AS INT)
LEFT JOIN
	data.receiving_stats_view rec
ON
	p.gsis_id = rec.receiver_player_id AND
	p.year = rec.year AND CAST(p.week AS INT) = CAST(rec.week AS INT)
LEFT JOIN
	data.kicking_stats_view kick
ON
	p.gsis_id = kick.kicker_player_id AND
	p.year = kick.year AND CAST(p.week AS INT) = CAST(kick.week AS INT)