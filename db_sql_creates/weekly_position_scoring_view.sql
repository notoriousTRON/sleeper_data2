DROP VIEW IF EXISTS weekly_position_scoring_view;
CREATE VIEW weekly_position_scoring_view AS
SELECT
	year
    ,week
    ,position
    ,MAX(
        CASE WHEN position = 'QB' AND qb_rank > 12 THEN total_pts
        	  WHEN position = 'RB' AND rb_rank > 24 THEN total_pts 
        	  WHEN position = 'WR' AND wr_rank > 36 THEN total_pts
        	  WHEN position = 'TE' AND te_rank > 12 THEN total_pts
        	  WHEN position = 'DEF' AND def_rank > 12 THEN total_pts
        	  WHEN position = 'K' AND k_rank > 12 THEN total_pts
        ELSE NULL END
        ) AS replacement
    ,AVG(
        CASE WHEN position = 'QB' AND qb_rank <= 12 THEN total_pts 
        	  WHEN position = 'RB' AND rb_rank <= 24 THEN total_pts 
        	  WHEN position = 'WR' AND wr_rank <= 36 THEN total_pts
        	  WHEN position = 'TE' AND te_rank <= 12 THEN total_pts
        	  WHEN position = 'DEF' AND def_rank <= 12 THEN total_pts
        	  WHEN position = 'K' AND k_rank <= 12 THEN total_pts
        ELSE NULL END
        ) AS avg_starter
    ,STDDEV(
        CASE WHEN position = 'QB' AND qb_rank <= 12 THEN total_pts 
        	  WHEN position = 'RB' AND rb_rank <= 24 THEN total_pts 
        	  WHEN position = 'WR' AND wr_rank <= 36 THEN total_pts
        	  WHEN position = 'TE' AND te_rank <= 12 THEN total_pts
        	  WHEN position = 'DEF' AND def_rank <= 12 THEN total_pts
        	  WHEN position = 'K' AND k_rank <= 12 THEN total_pts
        ELSE NULL END
        ) AS sd_starter
FROM
	pos_rankings_weekly_view
GROUP BY
	year
    ,week
    ,position

