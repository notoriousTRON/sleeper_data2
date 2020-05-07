SELECT 
	d.round
	,d.pick_no
	,d.overall_pick_no
	,ur.display_name
	,pl.*
FROM
	draft_tbl d
LEFT JOIN
	players_tbl pl
ON
	d.player_id = pl.player_id
LEFT JOIN
	map_user_roster_tbl ur
ON
	d.roster_id = ur.roster_id
WHERE
	draft_year = '2020'