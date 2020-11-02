SELECT
	mev.*
    ,wl.Wins
    ,wl.Losses
FROM
	(
    SELECT 
        display_name
        --,user_id
        ,SUM(started_pts) AS total_pts
        ,SUM(max_pts) AS possible_pts
        ,SUM(started_pts) / SUM(max_pts) * 100 AS manager_efficency
    FROM manager_effectiveness_view
    GROUP BY display_name
    ORDER BY SUM(started_pts) / SUM(max_pts) DESC
    ) mev
    LEFT JOIN
        (
        SELECT
            display_name
            ,user_id
            ,SUM(Win) AS Wins
            ,SUM(Loss) AS Losses
        FROM
            matchup_wl_view
        GROUP BY
            display_name
            ,user_id
            ) wl
    ON
        mev.display_name = wl.display_name