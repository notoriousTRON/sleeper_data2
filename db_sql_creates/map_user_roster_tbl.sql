--DROP TABLE IF EXISTS stg.map_user_roster_tbl;
--CREATE TABLE stg.map_user_roster_tbl AS
INSERT INTO stg.map_user_roster_tbl
SELECT
	'2025' AS year
    ,CONCAT('2025',b.user_id) AS year_user_id
	,b.user_id
    ,b.roster_id
    ,b.display_name
    ,b.team_name
FROM
	(
    SELECT
        DISTINCT r.user_id
        ,r.roster_id
        ,us.display_name
        ,us.team_name
    FROM
        sleeper_raw.rosters_tbl r
    LEFT JOIN
        sleeper_raw.users_tbl us
    ON
        r.user_id = us.user_id
    ) b;
	