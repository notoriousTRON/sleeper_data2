DROP VIEW IF EXISTS data.matchup_wl_view;
CREATE VIEW data.matchup_wl_view AS
SELECT
    m3.display_name
	,m3.matchup_rost_key
	,m3.matchup_id
	,m3.year
	,m3.week
	,m3.time_of_year
	,m3.round
	,CASE WHEN round IN ('QUARTER FINALS','SEMI FINALS','THIRD PLACE GAME','FINALS') THEN 'PLAYOFFS'
		  WHEN round IN ('TURD QUARTER FINALS','TURD SEMI FINALS','TURD FINALS') THEN 'TURD BOWL BRACKET'
		  WHEN round IN ('FIFTH PLACE GAME','SEVENTH PLACE GAME','NINTH PLACE GAME') THEN 'STANDINGS GAMES'
		  WHEN round IN ('BYE WEEK') THEN 'BYE WEEK'
		  WHEN round IN ('REG SEASON') THEN 'REG SEASON'
		  END AS competition_type
	,points
	,m3.opp_name
	,m3.opp_points
    ,CASE WHEN m3.opp_name = 'BYE' THEN NULL
		  WHEN m3.points > m3.opp_points THEN 1 ELSE 0 END AS Win
    ,CASE WHEN m3.opp_name = 'BYE' THEN NULL
		  WHEN m3.points > m3.opp_points THEN 0 ELSE 1 END AS Loss
FROM
    (
    SELECT
        u.display_name
		,mt.matchup_rost_key
		,mt.matchup_id
        ,mt.year
        ,mt.week
		,CASE WHEN CAST(mt.year AS INT) <= 2020 AND CAST(mt.week AS INT) <=13 THEN 'REG SEASON'
			  WHEN CAST(mt.year AS INT) > 2020 AND CAST(mt.week AS INT) <=14 THEN 'REG SEASON'
			  WHEN CAST(mt.year AS INT) <= 2020 AND CAST(mt.week AS INT) >= 14 THEN 'POST SEASON'
			  WHEN CAST(mt.year AS INT) > 2020 AND CAST(mt.week AS INT) >= 15 THEN 'POST SEASON'
			  END AS time_of_year
		,CASE WHEN CAST(mt.year AS INT) <= 2020 AND CAST(mt.week AS INT) <= 13 THEN 'REG SEASON'
			  WHEN CAST(mt.year AS INT) <= 2020 AND CAST(mt.week AS INT) = 14 AND CAST(mt.matchup_id AS INT) IN (1,2) THEN 'QUARTER FINALS'
			  WHEN CAST(mt.year AS INT) <= 2020 AND CAST(mt.week AS INT) = 14 AND CAST(mt.matchup_id AS INT) IN (4,5) THEN 'TURD QUARTER FINALS'
			  WHEN CAST(mt.year AS INT) <= 2020 AND CAST(mt.week AS INT) = 14 AND mt.matchup_id IS NULL THEN 'BYE WEEK'
			  WHEN CAST(mt.year AS INT) <= 2020 AND CAST(mt.week AS INT) = 15 AND CAST(mt.matchup_id AS INT) IN (1,2) THEN 'SEMI FINALS'
			  WHEN CAST(mt.year AS INT) <= 2020 AND CAST(mt.week AS INT) = 15 AND CAST(mt.matchup_id AS INT) IN (3)  THEN 'FIFTH PLACE GAME'
			  WHEN CAST(mt.year AS INT) <= 2020 AND CAST(mt.week AS INT) = 15 AND CAST(mt.matchup_id AS INT) IN (4,5) THEN 'TURD SEMI FINALS'
			  WHEN CAST(mt.year AS INT) <= 2020 AND CAST(mt.week AS INT) = 15 AND CAST(mt.matchup_id AS INT) IN (6) THEN 'SEVENTH PLACE GAME'
			  WHEN CAST(mt.year AS INT) <= 2020 AND CAST(mt.week AS INT) = 16 AND CAST(mt.matchup_id AS INT) IN (1) THEN 'FINALS'
			  WHEN CAST(mt.year AS INT) <= 2020 AND CAST(mt.week AS INT) = 16 AND CAST(mt.matchup_id AS INT) IN (2) THEN 'THIRD PLACE GAME'
			  WHEN CAST(mt.year AS INT) <= 2020 AND CAST(mt.week AS INT) = 16 AND CAST(mt.matchup_id AS INT) IN (4) THEN 'TURD FINALS'
			  WHEN CAST(mt.year AS INT) <= 2020 AND CAST(mt.week AS INT) = 16 AND CAST(mt.matchup_id AS INT) IN (5) THEN 'NINTH PLACE GAME'
			  WHEN CAST(mt.year AS INT) <= 2020 AND CAST(mt.week AS INT) = 16 AND mt.matchup_id IS NULL THEN 'BYE WEEK'
			  WHEN CAST(mt.year AS INT) <= 2021 AND CAST(mt.week AS INT) <= 14 THEN 'REG SEASON'
			  WHEN CAST(mt.year AS INT) <= 2021 AND CAST(mt.week AS INT) = 15 AND CAST(mt.matchup_id AS INT) IN (1,2) THEN 'QUARTER FINALS'
			  WHEN CAST(mt.year AS INT) <= 2021 AND CAST(mt.week AS INT) = 15 AND CAST(mt.matchup_id AS INT) IN (4,5) THEN 'TURD QUARTER FINALS'
			  WHEN CAST(mt.year AS INT) <= 2021 AND CAST(mt.week AS INT) = 15 AND mt.matchup_id IS NULL THEN 'BYE WEEK'
			  WHEN CAST(mt.year AS INT) <= 2021 AND CAST(mt.week AS INT) = 16 AND CAST(mt.matchup_id AS INT) IN (1,2) THEN 'SEMI FINALS'
			  WHEN CAST(mt.year AS INT) <= 2021 AND CAST(mt.week AS INT) = 16 AND CAST(mt.matchup_id AS INT) IN (3)  THEN 'FIFTH PLACE GAME'
			  WHEN CAST(mt.year AS INT) <= 2021 AND CAST(mt.week AS INT) = 16 AND CAST(mt.matchup_id AS INT) IN (4,5) THEN 'TURD SEMI FINALS'
			  WHEN CAST(mt.year AS INT) <= 2021 AND CAST(mt.week AS INT) = 16 AND CAST(mt.matchup_id AS INT) IN (6) THEN 'SEVENTH PLACE GAME'
			  WHEN CAST(mt.year AS INT) <= 2021 AND CAST(mt.week AS INT) = 17 AND CAST(mt.matchup_id AS INT) IN (1) THEN 'FINALS'
			  WHEN CAST(mt.year AS INT) <= 2021 AND CAST(mt.week AS INT) = 17 AND CAST(mt.matchup_id AS INT) IN (2) THEN 'THIRD PLACE GAME'
			  WHEN CAST(mt.year AS INT) <= 2021 AND CAST(mt.week AS INT) = 17 AND CAST(mt.matchup_id AS INT) IN (4) THEN 'TURD FINALS'
			  WHEN CAST(mt.year AS INT) <= 2021 AND CAST(mt.week AS INT) = 17 AND CAST(mt.matchup_id AS INT) IN (5) THEN 'NINTH PLACE GAME'
			  WHEN CAST(mt.year AS INT) <= 2021 AND CAST(mt.week AS INT) = 17 AND mt.matchup_id IS NULL THEN 'BYE WEEK'
			  END AS round
        ,mt.points
        ,CASE WHEN m2.display_name IS NULL THEN 'BYE' ELSE m2.display_name END AS opp_name
        ,m2.points AS opp_points
    FROM
        sleeper_raw.matchups_tbl mt
    LEFT JOIN
        stg.map_user_roster_tbl u
    ON
        mt.roster_id = u.roster_id AND
		mt.year = u.year
    LEFT JOIN
        (SELECT
            u2.display_name
            ,mt2.*
        FROM
            sleeper_raw.matchups_tbl mt2
        LEFT JOIN
            stg.map_user_roster_tbl u2
        ON
            mt2.roster_id = u2.roster_id AND
			mt2.year = u2.year) m2
    ON
        mt.matchup_id = m2.matchup_id AND
        mt.roster_id != m2.roster_id AND
        mt.year = m2.year AND
        mt.week = m2.week
    ) m3