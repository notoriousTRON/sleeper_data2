DROP TABLE data.year_week_tbl CASCADE;
CREATE TABLE data.year_week_tbl AS
SELECT
	 a.*
	 ,b.*
FROM
	 (SELECT CAST('2020' AS text) AS year) a
LEFT JOIN
	 (
	SELECT '1' AS week
	UNION ALL SELECT '2' AS week
	UNION ALL SELECT '3' AS week
	UNION ALL SELECT '4' AS week
	UNION ALL SELECT '5' AS week
	UNION ALL SELECT '6' AS week	
	UNION ALL SELECT '7' AS week
	UNION ALL SELECT '8' AS week
	UNION ALL SELECT '9' AS week
	UNION ALL SELECT '10' AS week
	UNION ALL SELECT '11' AS week
	UNION ALL SELECT '12' AS week
	UNION ALL SELECT '13' AS week
	UNION ALL SELECT '14' AS week
	UNION ALL SELECT '15' AS week
	UNION ALL SELECT '16' AS week
	 ) b
ON
	1=1
;

CREATE VIEW data.player_yr_week_view AS
SELECT
	p.player_id
	,yw.year
	,yw.week
	,p.first_name
	,p.last_name
	,p.first_name||' '||p.last_name AS full_name
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
;