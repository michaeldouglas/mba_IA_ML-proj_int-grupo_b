library(readr)
library(dplyr)
library(tidyr)

# URL DOS DADOS
analise_credito_data_raw <- read_csv("data/analise_credito_data_raw.csv")

# Diretorio
urlDataSet <- "data/analise_credito_data_raw.csv"

# Dicionario dos dados

# ID = ID do cliente do requerente
# year = Ano de aplicação
# loan limit = montante máximo disponível do empréstimo que pode ser tomado
# Gender = tipo de sexo
# approv_in_adv = O empréstimo é pré-aprovado ou não
# loan_type = Tipo de empréstimo
# loan_purpose = a razão pela qual você quer pedir dinheiro emprestado
# Credit_Worthiness = Como um credor determina que você será inadimplente em suas obrigações de dívida ou como você merece receber um novo crédito.
# open_credit = É um empréstimo pré-aprovado entre um credor e um mutuário. Ele permite que o mutuário faça saques repetidos até um certo limite.
# business_or_commercial = Tipo de uso do valor do empréstimo
# loan_amount = O valor exato do empréstimo
# rate_of_interest = É o valor que um credor cobra de um mutuário e é uma porcentagem do principal - o valor emprestado.
# Interest_rate_spread = A diferença entre a taxa de juros que uma instituição financeira paga aos depositantes e a taxa de juros que recebe de empréstimos
# Upfront_charges = Taxa paga a um credor por um mutuário como contrapartida por fazer um novo empréstimo
# term = O período de amortização do empréstimo
# Neg_ammortization = Refere-se a uma situação em que um tomador de empréstimo faz um pagamento menor do que a parcela padrão definida pelo banco.
# interest_only = Quantidade de juros apenas sem princípios
# lump_sum_payment = É uma quantia de dinheiro que é paga em um único pagamento em vez de ser em parcelas.
# property_value = o valor presente dos benefícios futuros decorrentes da propriedade
# construction_type = Tipo de construção colateral
# occupancy_type = Classificações referem-se a estruturas de categorização com base em seu uso
# Secured_by = Tipo de Garantia segura
# total_units = número de unidades
# income = Refere-se à quantidade de dinheiro, propriedade e outras transferências de valor recebidas durante um determinado período de tempo
# credit_type = Tipo de crédito
# co-applicant_credit_type = É uma pessoa adicional envolvida no processo de solicitação de empréstimo. Tanto o requerente quanto o co-requerente solicitam e assinam o empréstimo
# age = idade do requerente
# submission_of_application = Verifica se a aplicação está completa ou não
# LTV = o valor do tempo de vida é um prognóstico do lucro líquido
# Region = Local do requerente
# Security_Type = Tipo de Garantia
# status = Status do empréstimo (aprovado/recusado)
# dtir1 = Relação dívida/renda

# Lendo os dados
DataCredit <- read_csv(urlDataSet, show_col_types = FALSE)

View(DataCredit)

DataCredit %>% colnames()

# Primeiras análises

DataCredit %>% head()
DataCredit %>% str()
DataCredit %>% summary()

Count <- sum(is.na(DataCredit))
CalcProportion <- DataCredit %>% nrow() / Count

Proportion <- ifelse(is.infinite(CalcProportion), 0, CalcProportion)

data.frame(Index = colnames(DataCredit), Count, Proportion)

# Verificando a dimensionalidade dos dados

DataCredit %>% dim()

# Renomear colunas
DataCredit <- rename_with(DataCredit, tolower)

#filtrar colunas de interesse
DataCredit = DataCredit %>% select("loan_type",	"loan_amount",	"rate_of_interest",	"term",	
                                   "property_value",	"income",	"credit_score",	"age",	"status",	"dtir1")

# verificar nulos
sapply(DataCredit, function(x) sum(is.na(x)))


# remover duplicados
DataCredit = DataCredit %>% distinct(.keep_all = TRUE)

# verificar a dimensionalidade da tabela
DataCredit %>% dim()

DataCredit = DataCredit %>% fill(term, income, age, property_value, rate_of_interest, dtir1, .direction = "downup")

# verificar nulos
sapply(DataCredit, function(x) sum(is.na(x)))

# separar target e features
