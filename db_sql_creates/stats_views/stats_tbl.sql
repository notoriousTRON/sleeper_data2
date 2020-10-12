--SELECT * FROM data.player_yr_week_view WHERE week IN ('1','2','3','4')--players 30052;
SELECT
	pass.year||pass.week_padded||p.player_id AS week_player_id
	,pass.year
	,pass.week
	,p.player_id
	,pass.posteam AS team
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
FROM
	(SELECT * FROM data.player_yr_week_view WHERE CAST(week AS int) IN (1,2,3,4)) p
LEFT JOIN
	data.passing_stats_view pass
ON
	p.gsis_id = pass.passer_id AND
	p.year = pass.year AND p.week = pass.week
LEFT JOIN	
	data.rushing_stats_view rush
ON
	p.gsis_id = rush.rusher_player_id AND
	pass.year = rush.year AND pass.week = rush.week
--WHERE
--	pass.year||pass.week_padded||p.player_id = '202004167'