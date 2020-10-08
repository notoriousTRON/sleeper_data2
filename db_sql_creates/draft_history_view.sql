--DROP VIEW draft_history_view;
CREATE VIEW draft_history_view AS
SELECT 
	d.draft_year
	,d.draft_type
	,dor.draft_order_type
	,d.round
	,d.pick_no
	,d.overall_pick_no
	,u1.display_name
	,u.display_name AS original_pick_owner
	--,dor.* --don't need the info
	--,dd.* --don't need the info
FROM 
	--draft_dates_tbl 
	draft_tbl d
LEFT JOIN
	draft_order_tbl dor
ON
	d.draft_year = dor.draft_year AND
	d.draft_type = dor.draft_type AND
	d.pick_no = dor.pick_no
LEFT JOIN
	draft_dates_tbl dd
ON
	dor.draft_year = dd.draft_year AND
	dor.draft_type = dd.draft_type
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
	dor.roster_id = u.roster_id AND
	dd.draft_date BETWEEN u.join_date1 AND u.leave_date1
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
		user_history_tbl) u1
ON
	d.roster_id = u1.roster_id AND
	dd.draft_date BETWEEN u1.join_date1 AND u1.leave_date1
ORDER BY d.draft_year, CAST(d.overall_pick_no AS INT)