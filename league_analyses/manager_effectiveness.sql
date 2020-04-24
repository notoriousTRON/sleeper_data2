DROP VIEW IF EXISTS manager_effectiveness_view;
CREATE VIEW manager_effectiveness_view AS
SELECT
    inr4.player_id
    ,inr4.year
    ,inr4.week
    ,inr4.display_name
    ,inr4.user_id
    ,inr4.team_name
    ,inr4.is_starter
    ,inr4.full_name
    ,inr4.position
    ,inr4.any_pts
    ,inr4.started_pts
    ,CASE WHEN flex_rank <= 2 THEN inr4.any_pts ELSE inr4.max_pts END AS max_pts
FROM
	(
    SELECT
        *
        ,CASE WHEN flx_el = 1 THEN
            ROW_NUMBER() OVER(PARTITION BY inr3.year, inr3.week, inr3.display_name, inr3.flx_el ORDER BY inr3.any_pts DESC NULLS LAST) END AS flex_rank
    FROM
        (
        SELECT
            *
            ,CASE WHEN inr2.flex = 'FLEX' AND inr2.max_pts IS NULL THEN 1 END AS flx_el
        FROM
            (
            SELECT
                *
                ,CASE WHEN inr.position IN ('QB') AND inr.pos_rank = 1 THEN any_pts 
                      WHEN inr.position IN ('RB') AND inr.pos_rank <= 2 THEN any_pts 
                      WHEN inr.position IN ('WR') AND inr.pos_rank <= 3 THEN any_pts 
                      WHEN inr.position IN ('TE') AND inr.pos_rank <= 1 THEN any_pts 
                      WHEN inr.position IN ('K') AND inr.pos_rank <= 1 THEN any_pts 
                      WHEN inr.position IN ('DEF') AND inr.pos_rank <= 1 THEN any_pts 
                      END AS max_pts
            FROM (
                SELECT
                    mp.player_id
                    ,mp.year
                    ,mp.week
                    ,usr.display_name
                    ,usr.team_name
                	,usr.user_id
                    ,mp.is_starter
                    ,pl.full_name
                    ,pl.position
                    ,pl.flex
                    ,st.any_pts
                    ,CASE WHEN mp.is_starter THEN st.any_pts ELSE NULL END AS started_pts
                    ,ROW_NUMBER() OVER(PARTITION BY mp.year, mp.week, usr.display_name, pl.position ORDER BY st.any_pts DESC NULLS LAST) AS pos_rank
                    --,CASE WHEN flex = 'FLEX' THEN
                     --       RANK() OVER(PARTITION BY mp.year, mp.week, usr.display_name, pl.flex ORDER BY st.any_pts DESC) END AS flex_rank
                FROM 
                    matchups_plr_tbl mp
                LEFT JOIN
                    stats_tbl st
                ON
                    mp.player_id = st.player_id AND
                    mp.year = st.year AND
                    mp.week = st.week
                LEFT JOIN
                    (SELECT *, CASE WHEN position IN ('RB','WR','TE') THEN 'FLEX' ELSE NULL END AS flex FROM players_tbl) pl
                ON
                    mp.player_id = pl.player_id
                LEFT JOIN
                    map_user_roster_tbl usr
                ON
                    mp.roster_id = usr.roster_id
                ) inr
            ) inr2
        ) inr3
	) inr4
--WHERE display_name = 'Eskimo_Bros' AND year = '2019' AND week = '1'
--ORDER BY position, flex_rank