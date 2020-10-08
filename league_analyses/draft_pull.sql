COPY 
(
SELECT
	*
FROM
	draft_tbl
) TO 'C:\projects\sleeper_data\data\draft.csv'
DELIMITER ',' CSV HEADER;