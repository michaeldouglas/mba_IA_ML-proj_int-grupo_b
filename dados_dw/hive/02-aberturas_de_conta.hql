-- Check table, if exists drop
DROP TABLE IF EXISTS grupob.aberturas_de_conta;

-- Create external table, if not exists
CREATE EXTERNAL TABLE IF NOT EXISTS grupob.aberturas_de_conta (
  id_conta int,
  data date,
  year int,
  month char(10),
  month_of_year char(2),
  day_of_month int,
  day char(10),
  day_of_week int,
  weekend char(10),
  day_of_year int,
  week_of_year char(2),
  quarter int
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ',' STORED AS TEXTFILE LOCATION '/grupob/data_aberturas';

-- Check table
SELECT * FROM grupob.aberturas_de_conta;