-- Check table, if exists drop
DROP TABLE IF EXISTS grupob.apps_utilizados;

-- Create external table, if not exists
CREATE EXTERNAL TABLE IF NOT EXISTS grupob.apps_utilizados (
  id_conta int,
  versao_app char(100),
  SO char(100)
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ',' STORED AS TEXTFILE LOCATION '/grupob/apps_utilizados';

-- Check table
SELECT * FROM grupob.apps_utilizados;