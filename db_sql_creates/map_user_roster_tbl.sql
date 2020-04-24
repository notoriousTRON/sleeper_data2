--DROP TABLE IF EXISTS map_user_roster_tbl;
--CREATE TABLE map_user_roster_tbl AS
INSERT INTO temp_tbl(year,year_user_id,user_id,roster_id,display_name,team_name)
SELECT
	'2019' AS year
    ,CONCAT('2019',b.user_id) AS year_user_id
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
        rosters_tbl r
    LEFT JOIN
        users_tbl us
    ON
        r.user_id = us.user_id
    ) b