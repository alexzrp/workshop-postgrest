# Workshop PL/pgSQL

Parte do workshop sobre **Stored Procedure no Postgres**

Baixe esse projeto com
```shell script
git clone https://github.com/alexzrp/workshop-postgrest.git
```

## Requisitos
- Docker

## Composição
- Postgres 13.x
- pgAdmin4 v5.6
- PostgREST
- NGINX
- Swagger

### Para rodar os ambientes:

```shell script
cd workshop-postgrest
docker compose up -d
```

### Acesse o pgAdmin:

- **URL:** <http://localhost:6002>
- **Usuario:** `cap@zrp.com.br`
- **Senha:** `cap`

### Setup pgAdmin4

Clique em CREATE SERVER, preencha o nome `workshop`.
Em `Connection` preencha como a imagem abaixo usando a senha `cap`
Marque a opção `Save password?` para manter a senha salva no seu pgadmin4

![create_server](docs/create_server.png)

### Setup PostgreSQL

#### Restaurando o banco DVDRENTALS

Agora que já temos o banco de dados `postgres`, vamos restaurar todos os objetos de um dump.

Clique com o botão direito sobre o database `postgres`, despois em Restore e selecione o arquivo `dvdrentals.tar`

### Acessando o Swagger-UI

Acesse

```
http://localhost:8080
```


Agora você está pronto para iniciar.

Bom workshop!
