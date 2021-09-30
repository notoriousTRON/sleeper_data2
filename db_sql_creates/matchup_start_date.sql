--CREATE TABLE stg.matchup_start_date AS
--SELECT 
--	DISTINCT year,week,matchup_start_date
--FROM 
--	sleeper_raw.matchups_tbl
--ORDER BY
--	year, week

INSERT INTO stg.matchup_start_date (year,week,matchup_start_date)
VALUES ('2021','4','2021-09-30')
