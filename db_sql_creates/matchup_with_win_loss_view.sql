--DROP VIEW IF EXISTS data.matchup_wl_view CASCADE;
CREATE OR REPLACE VIEW data.matchup_wl_view AS
SELECT
    m3.display_name
	,m3.matchup_rost_key
	,m3.matchup_key
	,m3.matchup_id
	,m3.year
	,m3.week
	,m3.matchup_start_date
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
		,dt.matchup_start_date
        ,mt.points
        ,CASE WHEN m2.display_name IS NULL THEN 'BYE' ELSE m2.display_name END AS opp_name
        ,m2.points AS opp_points
    FROM
        sleeper_raw.matchups_tbl mt
	LEFT JOIN
		stg.matchup_start_date dt
	ON
		mt.year = dt.year AND
		mt.week = dt.week
    LEFT JOIN
        (
		SELECT
			user_id,
			roster_id,
			display_name,
			CASE WHEN join_date IS NULL THEN '1900-01-01' ELSE join_date END AS join_date,
			CASE WHEN leave_date IS NULL THEN '2200-01-01' ELSE leave_date END AS leave_date
		FROM
			stg.user_history_tbl
		) u
    ON
        mt.roster_id = u.roster_id AND
		dt.matchup_start_date BETWEEN u.join_date AND u.leave_date
    LEFT JOIN
        (SELECT
            u2.display_name
			,dt1.matchup_start_date
            ,mt2.*
        FROM
            sleeper_raw.matchups_tbl mt2
		LEFT JOIN
			stg.matchup_start_date dt1
		ON
			mt2.year = dt1.year AND
			mt2.week = dt1.week
        LEFT JOIN
            (
			SELECT
				user_id,
				roster_id,
				display_name,
				CASE WHEN join_date IS NULL THEN '1900-01-01' ELSE join_date END AS join_date,
				CASE WHEN leave_date IS NULL THEN '2200-01-01' ELSE leave_date END AS leave_date
			FROM
				stg.user_history_tbl
			) u2
        ON
            mt2.roster_id = u2.roster_id AND
			dt1.matchup_start_date BETWEEN u2.join_date AND u2.leave_date) m2
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
--WHERE
--	m3.year = '2022' AND
--	m3.week = '9' AND
--	m3.matchup_id = '1'