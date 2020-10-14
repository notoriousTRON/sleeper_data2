TRUNCATE TABLE data.year_week_tbl; --CASCADE;
INSERT INTO data.year_week_tbl (
SELECT
	a.*
	,b.*
	,a.year||b.week AS yyyymm
FROM
	 (
	SELECT CAST('2019' AS text) AS year
	UNION ALL
	SELECT CAST('2020' AS text) AS year
	 ) a
LEFT JOIN
	 (
	SELECT '01' AS week
	UNION ALL SELECT '02' AS week
	UNION ALL SELECT '03' AS week
	UNION ALL SELECT '04' AS week
	UNION ALL SELECT '05' AS week
	UNION ALL SELECT '06' AS week	
	UNION ALL SELECT '07' AS week
	UNION ALL SELECT '08' AS week
	UNION ALL SELECT '09' AS week
	UNION ALL SELECT '10' AS week
	UNION ALL SELECT '11' AS week
	UNION ALL SELECT '12' AS week
	UNION ALL SELECT '13' AS week
	UNION ALL SELECT '14' AS week
	UNION ALL SELECT '15' AS week
	UNION ALL SELECT '16' AS week
	 ) b
ON
	1=1)
;

CREATE OR REPLACE VIEW data.player_yr_week_view AS
SELECT
	p.player_id
	,CASE WHEN p.gsis_id = 'None' THEN fast.gsis_id ELSE p.gsis_id END AS gsis_id
	,p.gsis_id AS sleeper_gsis_id
	,p.sportradar_id
	,yw.year
	,yw.week
	,p.first_name
	,p.last_name
	,p.first_name||' '||p.last_name AS full_name
	,p.position
	,p.years_exp
	,p.status
	,p.age
	,p.birth_date
	,p.college
	,p.height
	,p.weight
FROM
	sleeper_raw.players_tbl p
LEFT JOIN
	(SELECT * FROM data.year_week_tbl) yw
ON 1=1
LEFT JOIN
	nflfast.pbp_roster2020_tbl fast
ON
	p.sportradar_id = fast.sportradar_id
