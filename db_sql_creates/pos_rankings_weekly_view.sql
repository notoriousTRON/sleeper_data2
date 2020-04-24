DROP VIEW IF EXISTS pos_rankings_weekly_view;
CREATE VIEW pos_rankings_weekly_view AS
SELECT
	st.year
    ,st.week
	,st.player_id
    ,CONCAT(pl.first_name,' ',pl.last_name) AS full_name
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
	stats_tbl st
LEFT JOIN
	--players_tbl pl
	(SELECT player_id, first_name, last_name, CASE WHEN position = 'FB' THEN 'RB' ELSE position END AS position ,position as orig_pos FROM players_tbl) pl
ON
	st.player_id = pl.player_id
WHERE
	--st.year = '2019' AND
    st.week IN ('1','2','3','4','5','6','7','8','9',
                    '10','11','12','13')
    AND pl.position IN ('QB','RB','WR','TE','DEF','K')
GROUP BY
	st.year
    ,st.week
	,st.player_id
    ,pl.position
    --,pl.fantasy_positions
    ,CONCAT(pl.first_name,' ',pl.last_name)