# Importacao das libs
import boto3
import os
import pandas as pd
import random
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity
from dotenv import load_dotenv
from colorama import init, Fore, Back, Style

# inicializar as bibliotecas
init()
load_dotenv()

# Carregas as variaveis
AWS_REGION = os.getenv('AWS_REGION')
ACCESS_KEY = os.getenv('AWS_ACCESS_KEY')
SECRET_KEY = os.getenv('AWS_SECRET_ACCESS_KEY')
AWS_TABLE  = os.getenv('AWS_TABLE')
STOP_WORDS = os.getenv('STOP_WORDS')

# Configuração do cliente DynamoDB
dynamodb = boto3.resource(
    'dynamodb', 
    region_name=AWS_REGION,
    aws_access_key_id=ACCESS_KEY,
    aws_secret_access_key=SECRET_KEY,
)

tabela = dynamodb.Table(AWS_TABLE) # type: ignore

# Carrega os dados dos produtos de bicicleta a partir da tabela do DynamoDB
produtos_dynamo = tabela.scan()
produtos_df = pd.DataFrame(produtos_dynamo['Items'])

# selecionar as linhas em que a coluna "clicked" é maior que zero
produtos = produtos_df[produtos_df['clicked'] > 1]

# Cria uma matriz de características dos produtos usando a frequência de palavras nos seus títulos e descrições
vectorizer = TfidfVectorizer(stop_words=STOP_WORDS)
matriz_caracteristicas = vectorizer.fit_transform(produtos['produto'] + ' ' + produtos['descricao'])

# Calcula a similaridade entre os produtos baseados nas suas características
similaridade = cosine_similarity(matriz_caracteristicas)

# Função que retorna as recomendações para um produto específico
def recomenda_produtos(id_produto, num_recomendacoes=5):
    # Obtém as linhas da matriz de similaridade que correspondem ao produto desejado
    similaridade_produto = similaridade[id_produto]
    
    # Ordena os produtos por ordem decrescente de similaridade e retorna os índices dos produtos mais similares
    produtos_similares_indices = similaridade_produto.argsort()[::-1][1:num_recomendacoes+1]
    
    # Obtém as informações dos produtos mais similares e retorna como um DataFrame pandas
    produtos_similares = produtos.iloc[produtos_similares_indices]
    return produtos_similares

# obter um índice aleatório do DataFrame
indice_aleatorio = random.choice(produtos.index)

# Exemplo de uso da função de recomendação para o produto com ID Aleatorio
recomendacoes = recomenda_produtos(indice_aleatorio)

# definir as cores para o cabeçalho e as células do DataFrame
cabecalho_cor = Back.BLUE + Fore.WHITE
celula_cor = Back.WHITE + Fore.BLACK

# exibir o DataFrame com as cores definidas
print(cabecalho_cor + '  '.join(recomendacoes) + Style.RESET_ALL)
for i, row in recomendacoes.iterrows():
    print(celula_cor + '  '.join([str(val) for val in row.values]) + Style.RESET_ALL)