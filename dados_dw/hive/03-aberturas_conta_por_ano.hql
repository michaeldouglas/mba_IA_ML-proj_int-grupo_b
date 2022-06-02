-- Check table, if exists drop
DROP TABLE IF EXISTS grupob.aberturas_conta_por_ano;

-- Create external table, if not exists
CREATE EXTERNAL TABLE IF NOT EXISTS grupob.aberturas_conta_por_ano (
  id_conta int,
  data date,
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
PARTITIONED BY(year int)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ',' STORED AS TEXTFILE LOCATION '/app/grupob/data_aberturas';

ALTER TABLE grupob.aberturas_conta_por_ano add partition(year=2017) location '/app/grupob/data_aberturas/year=2017';
ALTER TABLE grupob.aberturas_conta_por_ano add partition(year=2018) location '/app/grupob/data_aberturas/year=2018';

-- Check table
SELECT * FROM grupob.aberturas_conta_por_ano;