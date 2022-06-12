-- Check table, if exists drop
DROP TABLE IF EXISTS grupob.clientes_aquisicoes;

-- Create external table, if not exists
CREATE EXTERNAL TABLE IF NOT EXISTS grupob.clientes_aquisicoes (
  nome_cliente char(255),
  email_cliente char(255),
  nome_produto char(255),
  valor_produto DECIMAL(19,2),
  descricao_produto char(255),
  carencia_produto date,
  data_aquisicao date
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ',' STORED AS TEXTFILE LOCATION '/grupob/clientes_aquisicoes';

-- Check table
SELECT * FROM grupob.clientes_aquisicoes;
