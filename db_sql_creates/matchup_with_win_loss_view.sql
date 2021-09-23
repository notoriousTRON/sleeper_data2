--DROP VIEW IF EXISTS data.matchup_wl_view;
CREATE OR REPLACE VIEW data.matchup_wl_view AS
SELECT
    m3.display_name
	,m3.matchup_rost_key
	,m3.matchup_key
	,m3.matchup_id
	,m3.year
	,m3.week
	,ct.time_of_year
	,ct.round
	,ct.competition_type
	,m3.points
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
		,mt.year||mt.week||mt.matchup_id AS matchup_key
		,mt.matchup_id
        ,mt.year
        ,mt.week
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
LEFT JOIN
	data.competition_type_view ct
ON
	m3.matchup_key = ct.matchup_key