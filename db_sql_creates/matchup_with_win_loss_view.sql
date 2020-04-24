DROP VIEW IF EXISTS matchup_wl_view;
CREATE VIEW matchup_wl_view AS
SELECT
    *
    ,CASE WHEN m3.points > m3.opp_points THEN 1 ELSE 0 END AS Win
    ,CASE WHEN m3.points > m3.opp_points THEN 0 ELSE 1 END AS Loss
FROM
    (
    SELECT
        u.display_name
        ,mt.year
        ,mt.week
        ,mt.points
        ,m2.display_name AS opp_name
        ,m2.points AS opp_points
    FROM
        matchups_tbl mt
    LEFT JOIN
        map_user_roster_tbl u
    ON
        mt.roster_id = u.roster_id
    LEFT JOIN
        (SELECT
            u2.display_name
            ,mt2.*
        FROM
            matchups_tbl mt2
        LEFT JOIN
            map_user_roster_tbl u2
        ON
            mt2.roster_id = u2.roster_id) m2
    ON
        mt.matchup_id = m2.matchup_id AND
        mt.roster_id != m2.roster_id AND
        mt.year = m2.year AND
        mt.week = m2.week
    ) m3