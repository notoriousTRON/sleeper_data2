COPY 
(
SELECT
	*
FROM
	sleeper_raw.rosters_tbl
) TO 'C:\projects\sleeper_data\data\rosters.csv'
DELIMITER ',' CSV HEADER;

COPY 
(
SELECT
	*
FROM
	data.draft_history_view
) TO 'C:\projects\sleeper_data\data\draft.csv'
DELIMITER ',' CSV HEADER;

COPY 
(
SELECT
	c.display_name AS creator_display_name
	,t.transaction_id
	,t.transaction_type
	,t.year AS transaction_year
	,t.week AS transaction_week
	,t.roster_id
	,t.status_date
	,t.asset_type
	,t.player_id
	,t.add_drop
	,t.faab_ammount
	,t.waiver_bid_ammount
	,t.transaction_status
	,u.user_id
	,u.display_name
	,u.join_date
	,u.leave_date
	,p.full_name
	,p.first_name
	,p.last_name
	,p.position
	,p.age
	,p.college
	,CASE WHEN t.asset_type = 'pick' AND dr.player_id IS NULL THEN 'future pick' ELSE dr.player_id END AS picked_player_id
	,CASE WHEN t.asset_type = 'pick' AND dr.player_id IS NULL THEN 'future pick' ELSE dr.first_name END AS picked_player_first_name
	,CASE WHEN t.asset_type = 'pick' AND dr.player_id IS NULL THEN 'future pick' ELSE dr.last_name END AS picked_player_last_name
	,CASE WHEN t.asset_type = 'pick' AND dr.player_id IS NULL THEN 'future pick' ELSE dr.full_name END AS picked_player_full_name
	,CASE WHEN t.asset_type = 'pick' AND dr.player_id IS NULL THEN 'future pick' ELSE dr.round END AS eventual_pick_round
	,CASE WHEN t.asset_type = 'pick' AND dr.player_id IS NULL THEN 'future pick' ELSE dr.pick_no END AS eventual_pick_no
	,CASE WHEN t.asset_type = 'pick' AND dr.player_id IS NULL THEN 'future pick' ELSE dr.overall_pick_no END AS eventual_overall_pick_no
FROM
	sleeper_raw.transactions_tbl t
LEFT JOIN
	(SELECT
		user_id
		,roster_id
		,display_name
	 	,join_date
	 	,leave_date
		,CASE WHEN join_date IS NULL THEN '2019-07-01' ELSE join_date END AS join_date1
		,CASE WHEN leave_date IS NULL THEN DATE(NOW()) ELSE leave_date END AS leave_date1
	FROM
		stg.user_history_tbl) u
ON
	t.roster_id = u.roster_id AND
	t.status_date BETWEEN join_date1 AND leave_date1
LEFT JOIN
	sleeper_raw.players_tbl p
ON
	t.player_id = p.player_id AND
	asset_type = 'player'
LEFT JOIN
	(SELECT DISTINCT user_id, display_name FROM stg.map_user_roster_tbl) c
ON
	t.creater_user_id = c.user_id
LEFT JOIN
	data.draft_history_view dr
ON
	t.asset_type = 'pick' AND
	t.player_id = dr.pick_id
) TO 'C:\projects\sleeper_data\data\all_transactions.csv'
DELIMITER ',' CSV HEADER;