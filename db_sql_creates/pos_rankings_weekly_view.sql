DROP VIEW IF EXISTS data.pos_rankings_weekly_view;
CREATE VIEW data.pos_rankings_weekly_view AS
SELECT
	st.year
    ,st.week
	,st.player_id
    ,st.full_name AS full_name
    ,pl.position
    --,pl.fantasy_positions
    ,SUM(st.any_pts) AS total_pts
    ,CASE WHEN pl.position LIKE '%QB%' THEN RANK() OVER(PARTITION BY st.year, st.week, pl.position ORDER BY SUM(st.any_pts) DESC) ELSE NULL END AS QB_rank
    ,CASE WHEN pl.position LIKE '%RB%' THEN RANK() OVER(PARTITION BY st.year, st.week, pl.position ORDER BY SUM(st.any_pts) DESC) ELSE NULL END AS RB_rank
    ,CASE WHEN pl.position LIKE '%WR%' THEN RANK() OVER(PARTITION BY st.year, st.week, pl.position ORDER BY SUM(st.any_pts) DESC) ELSE NULL END AS WR_rank
    ,CASE WHEN pl.position LIKE '%TE%' THEN RANK() OVER(PARTITION BY st.year, st.week, pl.position ORDER BY SUM(st.any_pts) DESC) ELSE NULL END AS TE_rank
    ,CASE WHEN pl.position LIKE '%DEF%' THEN RANK() OVER(PARTITION BY st.year, st.week, pl.position ORDER BY SUM(st.any_pts) DESC) ELSE NULL END AS DEF_rank
    ,CASE WHEN pl.position LIKE '%K%' THEN RANK() OVER(PARTITION BY st.year, st.week, pl.position ORDER BY SUM(st.any_pts) DESC) ELSE NULL END AS K_rank
FROM
	(SELECT 
		*
		,(CASE WHEN st.any_pass_pts IS NULL THEN 0 ELSE st.any_pass_pts END)+
		(CASE WHEN st.any_rush_pts IS NULL THEN 0 ELSE st.any_rush_pts END)+
		(CASE WHEN st.any_rec_pts IS NULL THEN 0 ELSE st.any_rec_pts END)+
		(CASE WHEN st.any_def_pts IS NULL THEN 0 ELSE st.any_def_pts END)+
		(CASE WHEN st.any_k_pts IS NULL THEN 0 ELSE st.any_k_pts END) AS any_pts
	FROM
		data.game_log_tbl st) st
LEFT JOIN
	--players_tbl pl
	(SELECT player_id, first_name, last_name, CASE WHEN position = 'FB' THEN 'RB' ELSE position END AS position ,position as orig_pos FROM sleeper_raw.players_tbl) pl
ON
	st.player_id = pl.player_id
WHERE
	st.year = '2020' AND
    st.week IN ('01','02','03','04','05','06','07','08','09',
                    '10','11','12','13','14','15','16')
    AND pl.position IN ('QB','RB','WR','TE','DEF','K')
GROUP BY
	st.year
    ,st.week
	,st.player_id
    ,pl.position
    --,pl.fantasy_positions
	,st.full_name 