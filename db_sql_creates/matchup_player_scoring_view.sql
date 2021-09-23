--DROP VIEW IF EXISTS data.matchup_player_scoring_view;
CREATE OR REPLACE VIEW data.matchup_player_scoring_view AS
SELECT
	mp.matchup_rost_key
	,mp.year||mp.week||mp.matchup_id AS matchup_key
	,mp.year
	,mp.week
	,mp.matchup_id
	,m.display_name
	,m.opp_name
	,ct.time_of_year
	,ct.round
	,ct.competition_type
	,p.first_name||' '||p.last_name AS full_name
	,p.position
	,mp.is_starter
	,mp.player_points
FROM
	sleeper_raw.matchups_plr_tbl mp
LEFT JOIN
	sleeper_raw.players_tbl p
ON
	mp.player_id = p.player_id
LEFT JOIN
	data.competition_type_view ct
ON
	mp.year||mp.week||mp.matchup_id = ct.matchup_key
LEFT JOIN
	data.matchup_wl_view m
ON
	mp.matchup_rost_key = m.matchup_rost_key