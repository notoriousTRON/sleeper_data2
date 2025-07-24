
--############## START HERE    ##############
--## INSERT THE DRAFT DATE INTO THE TABLE ##
INSERT INTO stg.draft_dates_tbl (draft_year, draft_type, draft_date)
----VALUES ('2019','startup','08/26/19')
----VALUES ('2020','rookie','05/02/20')
----VALUES ('2021','rookie','05/02/21')
----VALUES ('2022','rookie','05/01/22')
VALUES ('2023','rookie','05/01/23')



--## USE THE FOLLOWING QUERY TO LOOK UP ROSTER NUMBERS ##
SELECT *
FROM
	stg.user_history_tbl
ORDER BY display_name

--## MANUALLY LOOK UP THE ROSTER IDS USING THE QUERY ABOVE AND INSERT EACH ROW INTO THE TABLE ##
--4th column is the pick number. look up the user's roster number
--confirm that you have the right owner for the right date
INSERT INTO stg.draft_order_tbl (draft_year, draft_type, draft_order_type, pick_no,roster_id)
VALUES ('2026','rookie','linear','1', '')
--VALUES ('2026','rookie','linear','2', '')
--VALUES ('2026','rookie','linear','3', '')
--VALUES ('2026','rookie','linear','4', '')
--VALUES ('2026','rookie','linear','5', '')
--VALUES ('2026','rookie','linear','6', '')
--VALUES ('2026','rookie','linear','7', '')
--VALUES ('2026','rookie','linear','8', '')
--VALUES ('2026','rookie','linear','9', '')
--VALUES ('2026','rookie','linear','10','')
--VALUES ('2026','rookie','linear','11','')
--VALUES ('2026','rookie','linear','12','')




--## EVERYTHING BELOW THIS LINE SHOULD ONLY BE USED IF EITHER DRAFT TABLE NEEDS TO BE RECREATED ##
------------------------------------------------------------------------------------------------------------------------

--DROP TABLE stg.draft_order_tbl
--CREATE TABLE stg.draft_order_tbl (draft_year varchar, draft_type varchar, draft_order_type varchar, pick_no varchar,roster_id varchar)
--SELECT * FROM stg.draft_order_tbl

--DROP TABLE stg.draft_dates_tbl
--CREATE TABLE stg.draft_dates_tbl (draft_year varchar, draft_type varchar, draft_date date)
--SELECT * FROM stg.draft_dates_tbl