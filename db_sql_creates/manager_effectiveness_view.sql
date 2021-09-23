-- View: public.manager_effectiveness_view

--DROP VIEW data.manager_effectiveness_view;

CREATE OR REPLACE VIEW data.manager_effectiveness_view AS
SELECT inr4.player_id,
	inr4.year,
	inr4.week,
	inr4.matchup_key,
	ct.time_of_year,
	ct.competition_type,
	ct.round,
	inr4.display_name,
	inr4.user_id,
	--inr4.team_name,
	inr4.is_starter,
	inr4.full_name,
	inr4."position",
	inr4.player_points,
	inr4.started_pts,
	CASE
		WHEN inr4.flex_rank <= 2 THEN inr4.player_points
		ELSE inr4.max_pts
		END AS max_pts
	FROM ( 
		SELECT 
			inr3.player_id,
			inr3.year,
			inr3.week,
			inr3.matchup_key,
			inr3.display_name,
			--inr3.team_name,
			inr3.user_id,
			inr3.is_starter,
			inr3.full_name,
			inr3."position",
			inr3.flex,
			inr3.player_points,
			inr3.started_pts,
			inr3.pos_rank,
			inr3.max_pts,
			inr3.flx_el,
			CASE
				WHEN inr3.flx_el = 1 THEN row_number() OVER (PARTITION BY inr3.year, inr3.week, inr3.display_name, inr3.flx_el ORDER BY inr3.player_points DESC NULLS LAST)
			ELSE NULL::bigint
			END AS flex_rank
		FROM ( 
			SELECT 
				inr2.player_id,
				inr2.year,
				inr2.week,
				inr2.matchup_key,
				inr2.display_name,
				--inr2.team_name,
				inr2.user_id,
				inr2.is_starter,
				inr2.full_name,
				inr2."position",
				inr2.flex,
				inr2.player_points,
				inr2.started_pts,
				inr2.pos_rank,
				inr2.max_pts,
				CASE
					WHEN inr2.flex = 'FLEX'::text AND inr2.max_pts IS NULL THEN 1
				ELSE NULL::integer
				END AS flx_el
			FROM ( 
				SELECT 
					inr.player_id,
					inr.year,
					inr.week,
					inr.display_name,
					inr.matchup_key,
					--inr.team_name,
					inr.user_id,
					inr.is_starter,
					inr.full_name,
					inr."position",
					inr.flex,
					inr.player_points,
					inr.started_pts,
					inr.pos_rank,
					CASE
						WHEN inr."position" = 'QB'::bpchar AND inr.pos_rank = 1 THEN inr.player_points
						WHEN inr."position" = 'RB'::bpchar AND inr.pos_rank <= 2 THEN inr.player_points
						WHEN inr."position" = 'WR'::bpchar AND inr.pos_rank <= 3 THEN inr.player_points
						WHEN inr."position" = 'TE'::bpchar AND inr.pos_rank <= 1 THEN inr.player_points
						WHEN inr."position" = 'K'::bpchar AND inr.pos_rank <= 1 THEN inr.player_points
						WHEN inr."position" = 'DEF'::bpchar AND inr.pos_rank <= 1 THEN inr.player_points
					ELSE NULL::double precision
					END AS max_pts
				FROM ( 
					SELECT 
						mp.player_id,
						mp.year,
						mp.week,
						mt.matchup_id,
						mp.year||mp.week||mt.matchup_id AS matchup_key,
						usr.display_name,
						usr.user_id,
						mp.is_starter,
						mp.player_points,
						pl.full_name,
						pl."position",
						pl.flex,
						CASE
							WHEN mp.is_starter THEN mp.player_points
						ELSE NULL::double precision
						END AS started_pts,
						row_number() OVER (PARTITION BY mp.year, mp.week, usr.display_name, pl."position" ORDER BY mp.player_points DESC NULLS LAST) AS pos_rank
					FROM sleeper_raw.matchups_plr_tbl mp
					LEFT JOIN ( 
						SELECT 
							players_tbl.player_id,
							players_tbl."position",
							players_tbl.depth_chart_position,
							players_tbl.fantasy_positions,
							players_tbl.first_name,
							players_tbl.last_name,
							players_tbl.full_name,
							players_tbl.years_exp,
							players_tbl.status,
							players_tbl.birth_date,
							players_tbl.college,
							players_tbl.height,
							players_tbl.weight,
							players_tbl.age,
							CASE
							WHEN players_tbl."position" = ANY (ARRAY['RB'::bpchar, 'WR'::bpchar, 'TE'::bpchar]) THEN 'FLEX'::text
							ELSE NULL::text
							END AS flex
						FROM sleeper_raw.players_tbl) pl 
					ON mp.player_id = pl.player_id
					LEFT JOIN
						sleeper_raw.matchups_tbl mt
					ON
						mp.matchup_rost_key = mt.matchup_rost_key
					LEFT JOIN
					(SELECT
						user_id
						,roster_id
						,display_name
						,join_date
						,leave_date
						,CASE WHEN join_date IS NULL THEN '2019-07-01' ELSE join_date END AS join_date1
						,CASE WHEN leave_date IS NULL THEN DATE(NOW()) ELSE leave_date END AS leave_date1
					FROM
						stg.user_history_tbl) usr
					ON
						mp.roster_id = usr.roster_id AND
						mt.matchup_start_date BETWEEN usr.join_date1 AND usr.leave_date1
					) inr) inr2) inr3) inr4
LEFT JOIN
	data.competition_type_view ct
ON
	inr4.matchup_key = ct.matchup_key

--ALTER TABLE public.manager_effectiveness_view
    --OWNER TO postgres;


