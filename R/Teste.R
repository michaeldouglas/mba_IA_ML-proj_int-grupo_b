##%######################################################%##
#                                                          #
####           INSTALACAO DAS LIBS                      ####
####                                                    ####
#                                                          #
##%######################################################%##

install.packages("dataMaid")

library("dplyr")

# Exemplos de como resolver - A análise exploratória de dados
# https://xiaoruizhu.github.io/Data-Mining-R/lecture/2.A_ExploratoryAnalyses.html
# https://rpubs.com/AjinkyaUC/Iris_DataSet
# http://www.lac.inpe.br/~rafael.santos/Docs/CAP394/WholeStory-Iris.html - http://www.lac.inpe.br/~rafael.santos/Docs/CAP394/WholeStory-Iris.R
# https://leticiaraposo.netlify.app/post/analise-exploratoria/

# Exemplos da análise de cluster
# https://medium.com/swlh/cluster-analysis-with-iris-data-set-a7c4dd5f5d0
# https://rpubs.com/MrCristianrl/504935
# https://cran.r-project.org/web/packages/dendextend/vignettes/Cluster_Analysis.html

# Informações dos atributos:
#   1. sepal length in cm - Comprimento da sépala em cm
#   2. sepal width in cm  - Largura da sépala em cm
#   3. petal length in cm - Comprimento da pétala em cm
#   4. petal width in cm  - Largura da pétala em cm
#   5. class: 
#     -- Iris Setosa
#     -- Iris Versicolour
#     -- Iris Virginica

# O que precisa entregar
# Utilizar o R Markdown para documentar o código com saída html
# Fazer análise exploratória das variáveis com medidas de resumo e gráficos
# Fazer uma análise de cluster

colName <- c("sepala_comprimento", "sepala_largura", "petala_length", "petala_width",
               "especies")

irisDataBase <- read.csv(
  url("http://archive.ics.uci.edu/ml/machine-learning-databases/iris/iris.data"),
  header = FALSE,
  col.names = colName
)

irisDataBase %>% head()

colnames(irisDataBase)

class(irisDataBase)

##%######################################################%##
#                                                          #
####           ANÁLISE EXPLORATÓRIA DOS DADOS           ####
####     PACOTES PARA GERAR RELATÓRIOS AUTOMÁTICOS      ####
#                                                          #
##%######################################################%##

data(iris)
iris %>% head()
