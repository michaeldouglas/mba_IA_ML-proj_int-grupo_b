# Para criar a máquina no GPC

Execute os itens a seguir:

Caso não esteja ativo o Compute Engine API ative ele em sua conta:

![Imagem](imgs/gpc_1.png)

Crie então uma instância para subir a API:

![Imagem](imgs/gpc_2.png)

Agora devemos abrir o SSH do ambiente para realizar a instalação do Docker e subir a API:

![Imagem](imgs/gpc_3.png)

Então irá abrir uma guia com o SSH da máquina:

![Imagem](imgs/gpc_4.png)

## Instalação do Docker na máquina

Instalar o docker na máquina com o comando

```bash
apt install docker.io
```

Para verificar a instalação do docker execute no terminal

```bash
docker ps
```

Agora criaremos um container nginx para testar o ambiente:

```bash
docker run --name grupob -p 80:80 -d nginx
```

Pegue o ip local da máquina e acesse no navegador. Se tudo estiver correto você verá:

![Imagem](imgs/img1.png)


Caso você consiga acessar o ambiente normalmente podemos então parar e deletar o ambiente da seguinte maneira:

```bash
docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)
```

Para verificar a parada do container execute:

```bash
docker ps
```

## Clonando o ambiente do flask

Para realizar o clone é necessário logar no GitHub por prefência escolhemos utilizar o Github cli

Para instalar execute o comando

```bash
apt install gh
```

Para logar em sua conta execute:

```bash
gh auth login
```

Será questionado algumas opções como sugestão deixe da seguinte maneira:

What account do you want to log into? - GitHub.com
What is your preferred protocol for Git operations? - HTTPS
Authenticate Git with your GitHub credentials? - Yes
How would you like to authenticate GitHub CLI? - Login with a web browser

Como estamos em um terminal não irá abrir o navegador automaticamente sendo assim copiei a url:

https://github.com/login/device

E então digite o código que é exibido no terminal:

First copy your one-time code: O CODIGO QUE DEVE SER DIGITADO NO NAVEGADOR

Após isso será informa que já podemos utilizar o git:

 - Authentication complete.
