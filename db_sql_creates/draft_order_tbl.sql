DROP TABLE draft_order_tbl
CREATE TABLE draft_order_tbl (draft_year varchar, draft_type varchar, draft_order_type varchar, pick_no varchar,roster_id varchar)
SELECT * FROM draft_order_tbl

INSERT INTO draft_order_tbl (draft_year, draft_type, draft_order_type, pick_no,roster_id)
--VALUES ('2020','rookie','linear','1','6')
--VALUES ('2020','rookie','linear','2','1')
--VALUES ('2020','rookie','linear','3','12')
--VALUES ('2020','rookie','linear','4','3')
--VALUES ('2020','rookie','linear','5','11')
--VALUES ('2020','rookie','linear','6','9')
--VALUES ('2020','rookie','linear','7','4')
--VALUES ('2020','rookie','linear','8','5')
--VALUES ('2020','rookie','linear','9','10')
--VALUES ('2020','rookie','linear','10','7')
--VALUES ('2020','rookie','linear','11','2')
VALUES ('2020','rookie','linear','12','8')


--INSERT INTO draft_order_tbl (draft_year, draft_type, draft_order_type, pick_no,roster_id)
--SELECT d.draft_year, d.draft_type, 'snake' AS draft_order_type ,d.pick_no,d.roster_id FROM draft_tbl d
--LEFT JOIN
--	draft_dates_tbl dd
--ON
--	d.draft_year = dd.draft_year AND
--	d.draft_type = dd.draft_type
--LEFT JOIN
--	(SELECT
--		user_id
--		,roster_id
--		,display_name
--	 	,join_date
--	 	,leave_date
--		,CASE WHEN join_date IS NULL THEN '2019-07-01' ELSE join_date END AS join_date1
--		,CASE WHEN leave_date IS NULL THEN DATE(NOW()) ELSE leave_date END AS leave_date1
--	FROM
--		user_history_tbl) u
--ON
--	d.roster_id = u.roster_id AND
--	dd.draft_date BETWEEN join_date1 AND leave_date1
--WHERE d.round = '2' AND d.draft_year = '2019' ORDER BY CAST(d.pick_no AS INT)