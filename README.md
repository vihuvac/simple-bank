<img src="https://vihuvac.github.io/public/images/icons/golang.png" width="150px" align="right" />

# Simple Bank

This is a POC to test Golang and PostgresQL with Docker.

---

## Table of Contents

- [System requirements](#system-requirements)
- [Getting started](#getting-started)
- [Additional resources](#additional-resources)

## System requirements

As a good practice it is recommended to work with Docker, the project is very straightforward and ready to work with _docker-compose_.

### Work locally

- Golang **1.16** or **higher**.

### Work with docker

- Docker **20.10.0** or **higher**.

> **Heads up**!:
>
> In order to keep the API container lightweight in Docker, SQLC and Mockgen are currently executed from their local installments (host machine).
> To learn more about each of them, just look at the [additional resources](#additional-resources) section.

## Getting started

Since the project uses _viper_ to manage configurations, it is necessary to set the respective values within the `app.env` file, then create a `.env` file based on the `app.env`, e.g: `cp app.env .env`.

The `.env` file will be used by docker locally to run the project.

> **Note**:
>
> For production and within the pipeline, the environment variables will override any value defined within the `app.env` file.

Clone the repo from GitHub.

```shell
git clone git@github.com:vihuvac/simple-bank.git && cd simple-bank
```

Set the values for the environment variables defined in the `app.env` file, then create a `.env` file, e.g:

```shell
cp app.env .env
```

### Working locally

It is necessary to create a _database_ in order to connect the _API_, e.g:

```shell
CREATE DATABASE postgres
WITH
  ENCODING = 'UTF8'
  OWNER = postgres;
```

For further information about how to create a _database_ with _PostgresQL_, take a look at the [official documentation](https://www.postgresql.org/docs/14/sql-createdatabase.html).

Once the database has been created, run the migrations:

```shell
migrate -path src/database/migrations -database <DB_URI> -verbose up
```

Start everything up (development mode):

```shell
go run src/main.go
```

Run tests:

```shell
go test -v -cover ./...
```

### Working with docker

> **Note**:
>
> All the commands mentioned above can be executed via make command, the commands related to the database have been configured to run with docker.
>
> Some commands require one or more environment variables, those can be defined before running the command, for instance to run an isolated container for the database, we can invoke the respective command as follows:
> `POSTGRES_PASSWORD=myPostgresPassword make postgres`

To make the project run automatically with _docker-compose_ just run:

```shell
docker-compose up -d
```

Two container will be created, one for the API and one for the database, something like this will be displayed:

```shell
[+] Building 57.1s (15/15) FINISHED
 => [internal] load build definition from Dockerfile.dev                                                                                         0.0s
 => => transferring dockerfile: 551B                                                                                                             0.0s
 => [internal] load .dockerignore                                                                                                                0.0s
 => => transferring context: 2B                                                                                                                  0.0s
 => [internal] load metadata for docker.io/library/golang:1.20-alpine3.17                                                                        3.0s
 => [auth] library/golang:pull token for registry-1.docker.io                                                                                    0.0s
 => [1/9] FROM docker.io/library/golang:1.20-alpine3.17@sha256:08e9c086194875334d606765bd60aa064abd3c215abfbcf5737619110d48d114                  4.4s
 => => resolve docker.io/library/golang:1.20-alpine3.17@sha256:08e9c086194875334d606765bd60aa064abd3c215abfbcf5737619110d48d114                  0.0s
 => => sha256:08e9c086194875334d606765bd60aa064abd3c215abfbcf5737619110d48d114 1.65kB / 1.65kB                                                   0.0s
 => => sha256:7dec57dbf13a5d8274bfc029fc5491d976215a0905c21ec330522f4e90d69e7a 1.16kB / 1.16kB                                                   0.0s
 => => sha256:f2b3f274864b4ee7cae75f5c59a2d1f78cf4bc8992ff0fd211484b70df1076d9 5.13kB / 5.13kB                                                   0.0s
 => => sha256:c2ac23d08d88d0780a5e2deff6f705ac18f198652ca7eb10eb7bb09a0c15f48a 96.00MB / 96.00MB                                                 2.5s
 => => sha256:c41833b44d910632b415cd89a9cdaa4d62c9725dc56c99a7ddadafd6719960f9 3.26MB / 3.26MB                                                   0.9s
 => => sha256:ed15518f570754b8336aff46024845ecb67da1ab7729e4d5701a42fa4c19396b 286.26kB / 286.26kB                                               0.8s
 => => extracting sha256:c41833b44d910632b415cd89a9cdaa4d62c9725dc56c99a7ddadafd6719960f9                                                        0.1s
 => => sha256:b29e5e6ea2c40f4f8977f5886a35a943450cfcf6056b0ce97e32c6786bc5c119 156B / 156B                                                       1.0s
 => => extracting sha256:ed15518f570754b8336aff46024845ecb67da1ab7729e4d5701a42fa4c19396b                                                        0.1s
 => => extracting sha256:c2ac23d08d88d0780a5e2deff6f705ac18f198652ca7eb10eb7bb09a0c15f48a                                                        1.5s
 => => extracting sha256:b29e5e6ea2c40f4f8977f5886a35a943450cfcf6056b0ce97e32c6786bc5c119                                                        0.0s
 => [internal] load build context                                                                                                                0.7s
 => => transferring context: 122.67kB                                                                                                            0.1s
 => [2/9] WORKDIR /app                                                                                                                           0.3s
 => [3/9] COPY . .                                                                                                                               0.1s
 => [4/9] RUN apk --update --no-cache add build-base curl                                                                                        3.0s
 => [5/9] RUN curl -L https://github.com/eficode/wait-for/archive/refs/tags/v2.2.3.tar.gz | tar xvz                                              1.1s
 => [6/9] RUN curl -L https://github.com/golang-migrate/migrate/releases/download/v4.15.2/migrate.linux-amd64.tar.gz | tar xvz                   2.5s
 => [7/9] RUN go install github.com/go-delve/delve/cmd/dlv@v1.9.1                                                                               38.0s
 => [8/9] RUN go install github.com/cosmtrek/air@v1.40.4                                                                                         3.7s
 => [9/9] COPY src/database/migrations ./migrations                                                                                              0.0s
 => exporting to image                                                                                                                           1.1s
 => => exporting layers                                                                                                                          1.1s
 => => writing image sha256:aafb24c51fb568b3401b8949d1290be5fe9bf78598673770507769dcd611988e                                                     0.0s
 => => naming to docker.io/library/simple-bank-api                                                                                               0.0s
[+] Running 4/4
 ✔ Network simple-bank_default                                                                                                      Created      0.0s
 ✔ Container simple-bank-db                                                                                                         Started      0.4s
 ✔ Container simple-bank-api                                                                                                        Started      0.6s
```

The -d option is for a detached mode allowing to run containers in the background, once the new containers has been created, it prints their names. Find out more at [docker's documentation site](https://docs.docker.com/v17.09/compose/reference/up/).

For checking the containers status and some details just run:

```shell
docker-compose ps -a
```

Something like this will be displayed:

```shell
CONTAINER ID   IMAGE                      COMMAND                  CREATED          STATUS         PORTS                                            NAMES
4cdff63b6d2d   simple-bank-api            "/app/wait-for-2.2.3…"   49 seconds ago   Up 2 seconds   0.0.0.0:6868->6868/tcp, 0.0.0.0:8080->8080/tcp   simple-bank-api
a480575b23c4   postgres:15.2-alpine3.17   "docker-entrypoint.s…"   49 seconds ago   Up 2 seconds   0.0.0.0:5432->5432/tcp                           simple-bank-db
```

For accessing to any container just run:

```shell
docker exec -it <CONTAINER> <SHELL>
```

> **Heads up**!
>
> The main container is **_simple-bank-api_**, so we can interact with it as follows:
>
> `docker exec -it simple-bank-api sh`

In order to view the logs of a Docker containers in real time, just run:

```shell
docker logs -f <CONTAINER>
```

The `-f` or `--follow` option will show live log output.

### Debugging through docker:

The project uses air and delve packages to run, thanks that, the debugging process is very straightforward, it is necessary to configure the editor in order to start debugging.

To debug the API with Visual Studio Code, we can use the following configuration:

```json
{
  // Use IntelliSense to learn about possible attributes.
  // Hover to view descriptions of existing attributes.
  // For more information, visit: https://go.microsoft.com/fwlink/?linkid=830387
  "version": "0.2.0",
  "configurations": [
    // Debug the docker app.
    {
      "name": "Attach to Docker",
      "type": "go",
      "request": "attach",
      "mode": "remote",
      "protocol": "auto",
      "port": 6868,
      "restart": true,
      "localRoot": "${workspaceFolder}",
      "remoteRoot": "/app"
    }
  ]
}
```

Once the configuration has been added and the debugging mode has been initialized, the project is ready to debug!

### Run tests through docker:

```shell
docker exec -it <CONTAINER> make test
```

Terminate/delete the containers, e.g:

```shell
docker-compose down
```

Terminate/delete the containers and the database volume:

```shell
docker-compose down -v
```

> **Note**:
>
> Docker compose commands can be invoked within the make shortcuts defined in the _Makefile_, e.g:
>
> `make composeUp` is a wildcard of `docker-compose up -d` command.
>
> `make composeDown` is a wildcard of `docker-compose down && docker rmi -f simple-bank-api` command.
>
> `make composeDownAll` is a wildcard of `docker-compose down -v && docker rmi -f simple-bank-api` command.

### Other useful wildcards to run in development mode:

> **Docker Containers**:
>
> `make postgres` is a wildcard to create an isolated container running postgres.
>
> `make createDB` is a wildcard to create a new database within the isolated container running postgres.
>
> `make dropDB` is a wildcard to delete a database within the isolated container running postgres.
>
> **DB Migrations**:
>
> `make migrateUp` is a wildcard to run the database migrations, if no version is specified, it will run all the available migrations.
>
> `make migrateDown` Unlike the `migrateUp` wildcard, if no version is specified, it will run all the available migrations to revert the database to a previous version.
>
> **DB Docs**:
>
> `make dbDocs` is a wildcard to generate documentation related to the database (the output will be placed within the `/docs` directory).
>
> `make dbSchema` is a wildcard to generate the database schemas (the output will be placed within the `/docs` directory).

---

## Additional resources

The project has been created with _Golang_, _PostgreSQL_ and _Docker_. These are the references to the useful resources used to created this project.

- [Golang migrate](https://github.com/golang-migrate/migrate/tree/master/cmd/migrate)
- [SQLC](https://github.com/kyleconroy/sqlc)
- [PQ](https://github.com/lib/pq)
- [Testify](https://github.com/stretchr/testify)
- [Viper](https://github.com/spf13/viper)
- [Gomock](https://github.com/golang/mock)
- [JWT Go](https://github.com/dgrijalva/jwt-go)
- [Paseto](https://github.com/o1egl/paseto)
- [Wait for](https://github.com/eficode/wait-for)
- [JQ](https://stedolan.github.io/jq/manual/#Invokingjq)

Other useful tools:

- [DB Diagram](https://dbdiagram.io/home)
- [DB Docs](https://dbdocs.io/docs)
- [DBML](https://www.dbml.org/home/)
- [Kubernetes](https://kubernetes.io/docs/tasks/tools/)
- [k9s](https://k9scli.io/)
- [Air](https://github.com/cosmtrek/air)
- [Delve](https://github.com/go-delve/delve)
