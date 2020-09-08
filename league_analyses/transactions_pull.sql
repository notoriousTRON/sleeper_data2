COPY 
(
SELECT
	u.display_name
	,CONCAT('t',tr.transaction_id) AS transaction_id
	,tr.transaction_type
	,tr.waiver_bid_ammount
	,tr.add_drop
	,tr.year
	,tr.week
	,tr.status_date
	,tr.create_date
	,tr.player_id
	,pl.full_name
	,tr.asset_type
FROM
	transactions_tbl tr
LEFT JOIN
	map_user_roster_tbl u
ON
	tr.roster_id = u.roster_id
LEFT JOIN
	players_tbl pl
ON
	tr.player_id = pl.player_id
) TO 'C:\projects\sleeper_data\data\all_transactions.csv'
   DELIMITER ',' CSV HEADER;