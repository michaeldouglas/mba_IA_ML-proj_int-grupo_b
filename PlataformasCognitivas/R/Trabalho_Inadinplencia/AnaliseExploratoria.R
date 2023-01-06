library(readr)
library(dplyr)
library(tidyr)
library(rpart)
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

# criar dummies
unique(DataCredit$loan_type)
unique(DataCredit$age)

loan_type1 <- ifelse(DataCredit$loan_type == "type1", 1, 0)
loan_type2 <- ifelse(DataCredit$loan_type == "type2", 1, 0)
loan_type3 <- ifelse(DataCredit$loan_type == "type3", 1, 0)


age_menos_de_25 <- ifelse(DataCredit$age == "<25", 1, 0)
age_de_25_a_34 <- ifelse(DataCredit$age == "25-34", 1, 0)
age_de_35_a_44 <- ifelse(DataCredit$age == "35-44", 1, 0)
age_de_45_a_54 <- ifelse(DataCredit$age == "45-54", 1, 0)
age_de_55_a_64 <- ifelse(DataCredit$age == "55-64", 1, 0)
age_de_65_a_74 <- ifelse(DataCredit$age == "65-74", 1, 0)
age_acima_de_74 <- ifelse(DataCredit$age == ">74", 1, 0)

# criar dataframe para modelo
DataCredit_model = data.frame(loan_type2, 
                              loan_type3, 
                              loan_amount=DataCredit$loan_amount,
                              rate_of_interest=DataCredit$rate_of_interest,
                              term=DataCredit$term,
                              property_value=DataCredit$property_value,
                              income=DataCredit$income,
                              credit_score=DataCredit$credit_score,
                              age_menos_de_25, 
                              age_de_35_a_44, 
                              age_de_45_a_54, 
                              age_de_55_a_64, 
                              age_de_65_a_74, 
                              age_acima_de_74,
                              status=DataCredit$status,  
                              dtir1=DataCredit$dtir1)

create_train_test <- function(data, size = 0.7, train = TRUE) {
  n_row = nrow(data)
  total_row = size * n_row
  train_sample = 1:total_row
  if (train == TRUE) {
    return (data[train_sample, ])
  } else {
    return (data[-train_sample, ])
  }
}

set.seed(1000)

DataCredit_model$id = 1:nrow(DataCredit_model)


data_train <- create_train_test(DataCredit_model)
data_test <- dplyr::anti_join(DataCredit_model, data_train, by='id')
dim(data_train)
dim(data_test)

# separar target e features
# Features
#X=select (DataCredit_model,-(status))

#target
#y=select(DataCredit_model,(status))



# features de treino
#X=select (train,-(status))

#target de treino
#y=select(train,(status))

#fit_train = rpart(data_train$status ~., data = data_train, method = "class")


# features de teste
#X_test=select (test,-(status))

#target de teste
#y_test=select(test,(status))

# checar proporção de dados de treino
# prop.table(table(test$status))

#predict_model<-predict(fit_train, test_data, type = "class")
