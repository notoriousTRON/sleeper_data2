CREATE TABLE user_history_tbl AS
SELECT DISTINCT user_id, roster_id, display_name FROM map_user_roster_tbl

ALTER TABLE user_history_tbl
ADD COLUMN join_date DATE

UPDATE user_history_tbl
SET join_date = '2020-4-03'
WHERE display_name IN ('troeysitzes','elandry')

UPDATE user_history_tbl
SET join_date = '2020-9-05'
WHERE display_name IN ('TheSwofford')

ALTER TABLE user_history_tbl
ADD COLUMN leave_date DATE

UPDATE user_history_tbl
SET leave_date = '2020-4-03'
WHERE display_name IN ('DREAMEROFSACKS','heyooooo')

UPDATE user_history_tbl
SET leave_date = '2020-9-05'
WHERE display_name IN ('LandonHWins')

SELECT * FROM user_history_tbl