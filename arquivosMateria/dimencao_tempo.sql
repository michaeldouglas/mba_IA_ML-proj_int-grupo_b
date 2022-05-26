-- alterar schema professor para o schema do grupo
-- Credit to http://www.dwhworld.com/2010/08/date-dimension-sql-scripts-mysql/
SET SQL_SAFE_UPDATES=0;

-- Small-grupob.numbers table
DROP TABLE IF EXISTS grupob.numbers_small;
CREATE TABLE grupob.numbers_small (number INT);
INSERT INTO grupob.numbers_small VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9);

-- Main-grupob.numbers table
DROP TABLE IF EXISTS grupob.numbers;
CREATE TABLE grupob.numbers (number BIGINT);
INSERT INTO grupob.numbers
SELECT thousands.number * 1000 + hundreds.number * 100 + tens.number * 10 + ones.number
FROM grupob.numbers_small thousands, grupob.numbers_small hundreds, grupob.numbers_small tens, grupob.numbers_small ones
LIMIT 1000000;

-- Create Date Dimension table
DROP TABLE IF EXISTS grupob.date_dimension;
CREATE TABLE grupob.date_dimension (
date_id          BIGINT PRIMARY KEY,
date             DATE NOT NULL,
year             INT,
month            CHAR(10),
month_of_year    CHAR(2),
day_of_month     INT,
day              CHAR(10),
day_of_week      INT,
weekend          CHAR(10) NOT NULL DEFAULT "Weekday",
day_of_year      INT,
week_of_year     CHAR(2),
quarter  INT,
UNIQUE KEY `date` (`date`));

-- First populate with ids and Date
-- Change year start and end to match your needs. The above sql creates records for year 2010.
INSERT INTO grupob.date_dimension (date_id, date)
SELECT distinct number, DATE_ADD( '2014-01-01', INTERVAL number DAY )
FROM grupob.numbers
WHERE DATE_ADD( '2014-01-01', INTERVAL number DAY ) BETWEEN '2014-01-01' AND '2024-12-31'
ORDER BY number;

-- Update other columns based on the date.
UPDATE grupob.date_dimension SET
year            = DATE_FORMAT( date, "%Y" ),
month           = DATE_FORMAT( date, "%M"),
month_of_year   = DATE_FORMAT( date, "%m"),
day_of_month    = DATE_FORMAT( date, "%d" ),
day             = DATE_FORMAT( date, "%W" ),
day_of_week     = DAYOFWEEK(date),
weekend         = IF( DATE_FORMAT( date, "%W" ) IN ('Saturday','Sunday'), 'Weekend', 'Weekday'),
day_of_year     = DATE_FORMAT( date, "%j" ),
week_of_year    = DATE_FORMAT( date, "%V" ),
quarter         = QUARTER(date)
;

select * from grupob.date_dimension;