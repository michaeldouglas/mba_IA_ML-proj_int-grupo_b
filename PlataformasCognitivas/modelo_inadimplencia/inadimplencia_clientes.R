setwd("/home/alison/Documents/FIAP/r/inadimplencia_clientes")
getwd()

#instalação
install.packages("Amelia") #trata valores ausentes
install.packages("caret") #constroe modelos ML e pre processa dados
install.packages("ggplot2")
install.packages("dplyr") #trata e manipular dados
install.packages("reshape") #modifica formato dos dados
install.packages("randomForest") #ML
install.packages("e1071") #ML

#carregamento
library("Amelia") #trata valores ausentes
library("caret") #construe modelos ML e pre processa dados
library("ggplot2")
library("dplyr") #tratar e manipular dados
library("reshape") #modificar formato dos dados
library("randomForest") #ML
library("e1071") #ML

dados_clientes <- read.csv("dados/dataset.csv")
dados_clientes$ID <- NULL #Null remove a coluna específica
View(dados_clientes) 
dim(dados_clientes) #dimensao da tabela
str(dados_clientes) #os tipos de dados
summary(dados_clientes) #sumário estatísticos

#alterando o nome de uma coluna
colnames(dados_clientes)
colnames(dados_clientes)[24] <- "inadimplente"
colnames(dados_clientes)
View(dados_clientes)

#verificando valores ausentes e removendo do dataset
sapply(dados_clientes, function(x) sum(is.na(x))) #verificando se as colunas possuem valores ausentes
?missmap #entender como funciona
missmap (dados_clientes, main="Valores ausentes observados") #o mesmo do anterior, so que de forma gráfica
dados_clientes <- na.omit(dados_clientes) #omite/remove os dados ausente e regrava no próprio data set

colnames(dados_clientes)[2] <- "Genero"
colnames(dados_clientes)[3] <- "Escolaridade"
colnames(dados_clientes)[4] <- "Estado_Civil"
colnames(dados_clientes)[5] <- "Idade"
colnames(dados_clientes)

#conversao do tipo de dados (transformação de int - variavel quantitativa para categórico(fator - variavel qualitativa))
#função CUT muda o tipo e o valor da variável
dados_clientes$Genero<- cut (dados_clientes$Genero, c(0,1,2), labels = c("Masculino","Feminino"))
summary(dados_clientes$Genero)
str(dados_clientes$Genero)

dados_clientes$Escolaridade <- cut(dados_clientes$Escolaridade, c(0,1,2,3,4), labels = c("Pos graduado","Graduado","Ensino medio","Outros"))
summary(dados_clientes$Escolaridade)

dados_clientes$Estado_Civil <- cut(dados_clientes$Estado_Civil, c(-1,0,1,2,3), labels = c("Desconhecido", "Casado","Solteiro","Outro"))
summary(dados_clientes$Estado_Civil)

dados_clientes$Idade <- cut(dados_clientes$Idade, c(0,30,50,100), labels= c("Jovem","Adulto","Idoso"))
hist(dados_clientes$Idade) #demonstra ser próximo a uma distribuição normal -média e mediana são muito próximo
summary(dados_clientes$Idade)

#função AS.FACTOR muda apenas o tipo
dados_clientes$PAY_0 <- as.factor(dados_clientes$PAY_0)
dados_clientes$PAY_2 <- as.factor(dados_clientes$PAY_2)
dados_clientes$PAY_3 <- as.factor(dados_clientes$PAY_3)
dados_clientes$PAY_4 <- as.factor(dados_clientes$PAY_4)
dados_clientes$PAY_5 <- as.factor(dados_clientes$PAY_5)
dados_clientes$PAY_6 <- as.factor(dados_clientes$PAY_6)

str(dados_clientes)
sapply(dados_clientes, function(x) sum(is.na(x))) #agora vamos ter valores ausentes
missmap (dados_clientes, main="Valores ausentes observados") 
dados_clientes <- na.omit(dados_clientes)
str(dados_clientes)

str(dados_clientes)
colnames(dados_clientes)
dados_clientes$inadimplente <- as.factor(dados_clientes$inadimplente)
str(dados_clientes$inadimplente)
contig_table <- table(dados_clientes$inadimplente)
summary(dados_clientes$inadimplente) #analisar a quantidade de cada classe (0-não inadimplentes, 1-inadimplentes)

#Proporção da tabela de contigência
prop.table(contig_table) #analisar de forma percentual/proporção
qplot(inadimplente, data=dados_clientes, geom="bar") + theme(axis.text.x = element_text(angle=90,hjust=1))

#set seed
?set
set.seed(12345)

#amostragem estratificada
#dividir dados de treino e teste
#dados de treino
indice <- createDataPartition (dados_clientes$inadimplente, p=0.75, list=FALSE)
dim(indice)

dados_treino <- dados_clientes[indice,] #fatia os dados dos treinos, linhas = indices, coluna = "vazio" para reutilizar as mesmas colunas do dados_clientes
dim(dados_treino)
table(dados_treino$inadimplente)
prop.table(table(dados_treino$inadimplente))

compara_dados <- cbind(prop.table(table(dados_treino$inadimplente)),
                        prop.table(table(dados_clientes$inadimplente)))
colnames(compara_dados)<- c("Treinamento","Original")
compara_dados

#colocando os dados anteriores em forma de linha
melt_compara_dados <- melt(compara_dados)
melt_compara_dados

#apresentando os dados anteriorees de forma gráfica
ggplot(melt_compara_dados, aes(x=X1, y=value)) + 
  geom_bar(aes(fill=X2), stat="identity", position="dodge") + 
  theme(axis.text.x = element_text(angle=90,hjust=1))

#dados de teste (-indice significa desconsidera o mesmo, ou seja, tudo da planilha original menos o indice sera os daods de teste)
dados_teste <- dados_clientes[-indice,]
dim(dados_teste)
dim(dados_treino)

#1ª versão do Modelo ML
modelo_v1 <- randomForest(inadimplente ~ ., data= dados_treino) #inadimplente se refere a variavel alvo(target) é o que quero prever, o til representa uma fórmula, após temos o ponto (.) que se refere a todas as variaveis preditoras,  para não precisar escrever o nomedecada uma delas.
modelo_v1 

#avaliando o modelo 
plot(modelo_v1)#primeira linha é a performance do modelo, segunda linha é o erro do modelo

#previsões com dados de teste
previsoes_v1 = predict(modelo_v1, dados_teste)

#Construindo a matrix confusion
cm_v1 <- caret::confusionMatrix(previsoes_v1,dados_teste$inadimplente, positive='1') #no dataset o 1 é considerado positivo na inadimplencia
cm_v1

#Calculando precision, recall e F1-score - métricas de avaliaçõa do modelo preditivo
y <- dados_teste$inadimplente
y_pred_v1 <- previsoes_v1

precision <- posPredValue(y_pred_v1,y)
precision

recall <- sensitivity(y_pred_v1,y)
recall

F1 <- (2*precision*recall)/(precision+recall)
F1

#Preparo para o modelo 2
#Balanceamento de classe
install.packages(c("zoo","xts","quantmod"))
install.packages('abind')
install.packages('ROCR')
install.packages("C:\\Users\\dell\\Documents\\R\\win-library\\4.0\\DMwR_0.4.1.tar.gz", repos=NULL, type="source")
library(DMwR)
?SMOTE

table(dados_treino$inadimplente)
prop.table(table(dados_clientes$inadimplente))
set.seed(9560)
dados_treino_bal <-SMOTE(inadimplente ~ ., data=dados_treino)
table(dados_treino_bal$inadimlente)
prop.table(table(dados_treino_bal$inadimplente))

modelo_v2 <- randomForest(inadimplente ~ ., data = dados_treino_bal)
modelo_v2

#Avaliando o modelo 2
plot(modelo_v2)

#Previsão com dados de teste
previsoes_v2 <- predict(modelo_v2,dados_teste)

#confusion matrix
cm_v2 <- caret::confusionMatrix(previsoes_v2, dados_teste$inadimplente, positive="1")
cm_v2
cm_v1

#Calculando precision, recall e F1-score - métricas de avaliaçõa do modelo preditivo
y2 <- dados_teste$inadimplente
y_pred_v2 <- previsoes_v2

precision2 <- posPredValue(y_pred_v2,y2)
precision2

recall2 <- sensitivity(y_pred_v2,y2)
recall2

F2 <- (2*precision2*recall2)/(precision2+recall2)
F2

#preparação para o modelo3
#variaveis preditoras mais importantes para previsão
varImpPlot(modelo_v2)


#obtendo variaveis mais importantes
imp_var <- importance(modelo_v2)
imp_var
varImportance <- data.frame(Variables= row.names(imp_var), Importance=round(imp_var[, "MeanDecreaseGini"], 2))

#criando o ranking de variaveis importantes
rankImportance <- varImportance %>%
  mutate(Rank = paste0('#', dense_rank(desc(Importance))))

#usando ggplot2 para visualizar a importancia relativa das variáveis
ggplot(rankImportance, aes(x= reorder(Variables, Importance),
                           y=Importance,
                           fill=Importance))+
  geom_bar(stat="identity") + 
  geom_text(aes(x=Variables, y=0.5, label=Rank),
            hjust = 0,
            vjust = 0.55,
            size = 4,
            color = 'red')+
  labs(x='Variables')+
coord_flip()

#construindo o modelo 3
colnames(dados_treino_bal)
modelo_v3 <- randomForest(inadimplente ~ PAY_0+PAY_2+PAY_3+PAY_AMT1+PAY_AMT2+PAY_5+BILL_AMT1, data = dados_treino_bal)
modelo_v3

#Avaliando o modelo 3
plot(modelo_v3)

#Previsão com dados de teste
previsoes_v3 <- predict(modelo_v3,dados_teste)

#confusion matrix
cm_v3 <- caret::confusionMatrix(previsoes_v3, dados_teste$inadimplente, positive="1")
cm_v3

#Calculando precision, recall e F1-score - métricas de avaliaçõa do modelo preditivo
y3 <- dados_teste$inadimplente
y_pred_v3 <- previsoes_v3

precision3 <- posPredValue(y_pred_v3,y3)
precision3

recall3 <- sensitivity(y_pred_v3,y3)
recall3

F3 <- (2*precision3*recall3)/(precision3+recall3)
F3

#Salvando modelo
saveRDS(modelo_v3, file="modelo/modelo_v3.rds")

#Carrergando o modelo
modelo_final <- readRDS("modelo/modelo_v3.rds")

#Previsões com novos dados de 3 clientes

#Dados dos clientes
PAY_0 <- c(0,0,0)
PAY_2 <- c(0,0,0)
PAY_3 <- c(1,0,0)
PAY_AMT1 <- c(1100,1000,1200)
PAY_AMT2 <- c(1500,1300,1150)
PAY_5 <- c(0,0,0)
BILL_AMT1 <- c(350,420,280)

#Concatenar em dataframe
novos_clientes <- data.frame(PAY_0,PAY_2,PAY_3,PAY_AMT1,PAY_AMT2,PAY_5,BILL_AMT1)
View(novos_clientes)

#prevendo
previsoes_novos <- predict(modelo_final, novos_clientes) #ocorrera o erro
#Verificando os tipos de dados
str(dados_treino_bal)
str(novos_clientes)

#converteno as variaveis
novos_clientes$PAY_0 <- factor(novos_clientes$PAY_0,levels=levels(dados_treino_bal$PAY_0)) #convertando para os mesmos níveis de treino
novos_clientes$PAY_2 <- factor(novos_clientes$PAY_2,levels=levels(dados_treino_bal$PAY_2))
novos_clientes$PAY_3 <- factor(novos_clientes$PAY_3,levels=levels(dados_treino_bal$PAY_3))
novos_clientes$PAY_5 <- factor(novos_clientes$PAY_5,levels=levels(dados_treino_bal$PAY_5))
str(novos_clientes)

#previsao
previsoes_novos_clientes <- predict(modelo_final, novos_clientes)
View(previsoes_novos_clientes)
