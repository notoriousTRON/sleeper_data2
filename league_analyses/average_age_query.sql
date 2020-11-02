SELECT
	display_name AS UserName,
	TO_CHAR(AVG(CAST(age AS int)), 'FM999999999.00') AS Average_Age
FROM (
    SELECT
        u.display_name,
        pl.full_name,
        pl.age
    FROM
        stg.user_history_tbl u
    INNER JOIN
        sleeper_raw.rosters_tbl r
    ON
        u.user_id = r.user_id
    LEFT JOIN
        sleeper_raw.players_tbl pl
    ON
        r.player_id = pl.player_id
   	) i
GROUP BY
	display_name
ORDER BY
	TO_CHAR(AVG(CAST(age AS int)), 'FM999999999.00')