--DO $$
--DECLARE compyear VARCHAR(4);
--BEGIN
--	compyear := '2019';
--DROP TABLE stg_yearly_ranking_tbl;
--CREATE TABLE stg_yearly_ranking_tbl AS
INSERT INTO stg_yearly_ranking_tbl(year,year_player_id,player_id,full_name,position,total_pts,QB_rank,RB_rank,WR_rank,TE_rank,DEF_rank,K_rank,pts_above_replacement,pts_above_avg_starter,zscore_above_avg_starter)
SELECT
	*
    ,CASE WHEN pr1.position = 'QB' THEN total_pts - (SELECT MAX(total_pts) FROM pos_rankings_view WHERE year = '2019' AND qb_rank > 12)
    	  WHEN pr1.position = 'RB' THEN total_pts - (SELECT MAX(total_pts) FROM pos_rankings_view WHERE year = '2019' AND rb_rank > 24)
    	  WHEN pr1.position = 'WR' THEN total_pts - (SELECT MAX(total_pts) FROM pos_rankings_view WHERE year = '2019' AND wr_rank > 36)
    	  WHEN pr1.position = 'TE' THEN total_pts - (SELECT MAX(total_pts) FROM pos_rankings_view WHERE year = '2019' AND te_rank > 12)
    	  WHEN pr1.position = 'DEF' THEN total_pts - (SELECT MAX(total_pts) FROM pos_rankings_view WHERE year = '2019' AND def_rank > 12)
    	  WHEN pr1.position = 'K' THEN total_pts - (SELECT MAX(total_pts) FROM pos_rankings_view WHERE year = '2019' AND k_rank > 12)
          END AS pts_above_replacement
	,CASE WHEN pr1.position = 'QB' THEN total_pts - (SELECT AVG(total_pts) FROM pos_rankings_view WHERE year = '2019' AND qb_rank <= 12)
    	  WHEN pr1.position = 'RB' THEN total_pts - (SELECT AVG(total_pts) FROM pos_rankings_view WHERE year = '2019' AND rb_rank <= 24)
    	  WHEN pr1.position = 'WR' THEN total_pts - (SELECT AVG(total_pts) FROM pos_rankings_view WHERE year = '2019' AND wr_rank <= 36)
    	  WHEN pr1.position = 'TE' THEN total_pts - (SELECT AVG(total_pts) FROM pos_rankings_view WHERE year = '2019' AND te_rank <= 12)
    	  WHEN pr1.position = 'DEF' THEN total_pts - (SELECT AVG(total_pts) FROM pos_rankings_view WHERE year = '2019' AND def_rank <= 12)
    	  WHEN pr1.position = 'K' THEN total_pts - (SELECT AVG(total_pts) FROM pos_rankings_view WHERE year = '2019' AND k_rank <= 12)
          END AS pts_above_avg_starter
	,CASE WHEN pr1.position = 'QB' THEN (total_pts - (SELECT AVG(total_pts) FROM pos_rankings_view WHERE year = '2019' AND qb_rank <= 12))/(SELECT STDDEV(total_pts) FROM pos_rankings_view WHERE year = '2019' AND qb_rank <= 12)
    	  WHEN pr1.position = 'RB' THEN (total_pts - (SELECT AVG(total_pts) FROM pos_rankings_view WHERE year = '2019' AND rb_rank <= 24))/(SELECT STDDEV(total_pts) FROM pos_rankings_view WHERE year = '2019' AND rb_rank <= 24)
    	  WHEN pr1.position = 'WR' THEN (total_pts - (SELECT AVG(total_pts) FROM pos_rankings_view WHERE year = '2019' AND wr_rank <= 36))/(SELECT STDDEV(total_pts) FROM pos_rankings_view WHERE year = '2019' AND wr_rank <= 36)
    	  WHEN pr1.position = 'TE' THEN (total_pts - (SELECT AVG(total_pts) FROM pos_rankings_view WHERE year = '2019' AND te_rank <= 12))/(SELECT STDDEV(total_pts) FROM pos_rankings_view WHERE year = '2019' AND te_rank <= 12)
    	  WHEN pr1.position = 'DEF' THEN (total_pts - (SELECT AVG(total_pts) FROM pos_rankings_view WHERE year = '2019' AND def_rank <= 12))/(SELECT STDDEV(total_pts) FROM pos_rankings_view WHERE year = '2019' AND def_rank <= 12)
    	  WHEN pr1.position = 'K' THEN (total_pts - (SELECT AVG(total_pts) FROM pos_rankings_view WHERE year = '2019' AND k_rank <= 12))/(SELECT STDDEV(total_pts) FROM pos_rankings_view WHERE year = '2019' AND k_rank <= 12)
          END AS zscore_above_avg_starter
FROM
	(SELECT * FROM pos_rankings_view WHERE year = '2019') pr1
--LEFT JOIN
--	pos_rankings_view pr2
--ON
--	pr1.year = pr2.year AND
--    pr1.player_id = pr2.player_id
--ORDER BY pts_above_replacement DESC
;
--END $$;