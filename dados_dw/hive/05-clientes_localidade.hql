-- Check table, if exists drop
DROP TABLE IF EXISTS grupob.clientes_localidade_renda;

-- Create external table, if not exists
CREATE EXTERNAL TABLE IF NOT EXISTS grupob.clientes_localidade_renda (
  nome char(200),
  email char(200),
  cpf bigint,
  data_nascimento date,
  sexo char(1),
  faixa_renda decimal(19,2),
  cidade char(255),
  estado char(255),
  logradouro char(255),
  cep int,
  numero int,
  bairro char(255)
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ',' STORED AS TEXTFILE LOCATION '/grupob/clientes_localidade_renda';

-- Check table
SELECT * FROM grupob.clientes_localidade_renda;