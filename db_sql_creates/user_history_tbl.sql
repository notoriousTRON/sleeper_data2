DROP TABLE stg.user_history_tbl CASCADE;
CREATE TABLE stg.user_history_tbl AS
SELECT DISTINCT user_id, roster_id, display_name FROM stg.map_user_roster_tbl ORDER BY user_id;

ALTER TABLE stg.user_history_tbl
ADD COLUMN join_date DATE;

UPDATE stg.user_history_tbl
SET join_date = '2020-4-03'
WHERE display_name IN ('troeysitzes','elandry');

UPDATE stg.user_history_tbl
SET join_date = '2020-9-05'
WHERE display_name IN ('TheSwofford');

UPDATE stg.user_history_tbl
SET join_date = '2020-12-23'
WHERE display_name IN ('jcon78');

UPDATE stg.user_history_tbl
SET join_date = '2022-4-15'
WHERE display_name IN ('mfolmnsbee');

ALTER TABLE stg.user_history_tbl
ADD COLUMN leave_date DATE;

UPDATE stg.user_history_tbl
SET leave_date = '2020-4-03'
WHERE display_name IN ('DREAMEROFSACKS','heyooooo');

UPDATE stg.user_history_tbl
SET leave_date = '2020-9-05'
WHERE display_name IN ('LandonHWins');

UPDATE stg.user_history_tbl
SET leave_date = '2020-12-23'
WHERE display_name IN ('rapplean');

UPDATE stg.user_history_tbl
SET leave_date = '2022-4-15'
WHERE display_name IN ('Richmond3711');

UPDATE stg.user_history_tbl
SET leave_date = '2022-11-04'
WHERE display_name IN ('TheSwofford');

UPDATE stg.user_history_tbl
SET join_date = '2022-11-04'
WHERE display_name IN ('nmasterson');

SELECT * FROM stg.user_history_tbl