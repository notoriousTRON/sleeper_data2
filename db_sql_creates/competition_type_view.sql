CREATE OR REPLACE VIEW data.competition_type_view AS
SELECT
	m3.year||m3.week||m3.matchup_id AS matchup_key
	,m3.time_of_year
	,m3.round
	,CASE WHEN round IN ('QUARTER FINALS','SEMI FINALS','THIRD PLACE GAME','FINALS') THEN 'PLAYOFFS'
		  WHEN round IN ('TURD QUARTER FINALS','TURD SEMI FINALS','TURD FINALS') THEN 'TURD BOWL BRACKET'
		  WHEN round IN ('FIFTH PLACE GAME','SEVENTH PLACE GAME','NINTH PLACE GAME') THEN 'STANDINGS GAMES'
		  WHEN round IN ('BYE WEEK') THEN 'BYE WEEK'
		  WHEN round IN ('REG SEASON') THEN 'REG SEASON'
		  END AS competition_type
FROM
    (
    SELECT
		mt.matchup_id
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
    FROM
        sleeper_raw.matchups_tbl mt

    ) m3