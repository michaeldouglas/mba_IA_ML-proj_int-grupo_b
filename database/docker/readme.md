## Download Docker

Primeiro você deve baixar o docker no site:

- https://docs.docker.com/desktop/windows/install - Windows
- https://docs.docker.com/desktop/mac/install - Mac
- https://docs.docker.com/desktop/linux/install - Linux

Foi utilizado o Docker Compose sendo assim instalar também a parti do link:

- https://docs.docker.com/compose/install

Já na página basta escolher o sistema operacional.

## Executar o banco de dados do projeto

Uma vez tendo tudo instalado basta executar na raíz do projeto na pasta: `database/docker` o seguinte comando:

```bash
docker-compose up -d
```

A maneira mencionado antes irá executar sem exibir o logs do container, caso queira ver os logs execute da seguinte maneira:

```bash
docker-compose up
```

## Gerar a imagem novamente

Caso precise gerar a imagem do banco de dados novamente, isso para quando alterar a base execute o comando:

```bash
docker-compose stop
docker-compose build --no-cache
docker-compose up -d
```

## Entrar na máquina virtual do banco de dados

Caso queira entrar na máquina virtual que foi criada execute o comando:

```bash
docker exec -it db_turma bash
```

## Conectando no banco de dados

Para conectar no MySQL Workbench os dados devem ser:

- Hostname: 127.0.0.1
- Port: 3306
- Username: user_dindin_agora_2022
- Store in Keychain ou password: pass_dindin_agora_2022
- Default Schema: dindinagora

## Criar ou atualizar o banco de dados

Para criar o banco de dados pelo `sql` entrar na raíz do projeto e executar o comando a seguir na pasta `database/docker`:

```bash
docker exec db_dindinagora /bin/sh -c 'mysql -u root -p${DB_ROOT_PASSWORD} < /usr/sql/sources.sql'
```

Outra forma é pelo MySQL Workbench fazer o Forward do database para a conexão nova que fizemos no Docker.
