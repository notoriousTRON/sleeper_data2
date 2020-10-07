COPY 
(
SELECT
	c.display_name AS creator_display_name
	,t.transaction_id
	,t.transaction_type
	,t.roster_id
	,t.status_date
	,t.asset_type
	,t.player_id
	,u.display_name
	,u.join_date
	,u.leave_date
	,p.full_name
	,p.first_name
	,p.last_name
	,p.position
	,p.age
	,p.college
FROM
	transactions_tbl t
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
		user_history_tbl) u
ON
	t.roster_id = u.roster_id AND
	t.status_date BETWEEN join_date1 AND leave_date1
LEFT JOIN
	players_tbl p
ON
	t.player_id = p.player_id AND
	asset_type = 'player'
LEFT JOIN
	(SELECT DISTINCT user_id, display_name FROM map_user_roster_tbl) c
ON
	t.creater_user_id = c.user_id
) TO 'C:\projects\sleeper_data\data\all_transactions.csv'
DELIMITER ',' CSV HEADER;