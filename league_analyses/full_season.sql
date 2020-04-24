COPY (
SELECT
	s.year
	,pl.position
	,pl.age
	,s.player_id
	,CONCAT(TRIM(pl.first_name),' ',TRIM(pl.last_name)) AS full_name
	,SUM(s.any_pts) AS total_points
	,RANK() OVER(PARTITION BY s.year, pl.position ORDER BY SUM(s.any_pts) DESC) AS posRank_year
FROM
	stats_tbl s
LEFT JOIN
	players_tbl pl
ON
	s.player_id = pl.player_id
WHERE
	pl.position IN ('QB','RB','WR','TE','K','DEF')
GROUP BY
	s.year
	,pl.position
	,pl.age
	,CONCAT(TRIM(pl.first_name),' ',TRIM(pl.last_name))
	,s.player_id
) TO 'P:\Projects\sleeper_data\data\full_season.csv'
   DELIMITER ',' CSV HEADER;