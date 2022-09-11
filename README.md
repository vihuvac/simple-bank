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
Creating network "simple-bank_default" with the default driver
Creating volume "simple-bank_postgres_volume" with default driver
Building api
[+] Building 152.7s (15/15) FINISHED
 => [internal] load build definition from Dockerfile.dev                                                                                                              0.0s
 => => transferring dockerfile: 556B                                                                                                                                  0.0s
 => [internal] load .dockerignore                                                                                                                                     0.0s
 => => transferring context: 2B                                                                                                                                       0.0s
 => [internal] load metadata for docker.io/library/golang:1.19-alpine3.16                                                                                             4.6s
 => [auth] library/golang:pull token for registry-1.docker.io                                                                                                         0.0s
 => [internal] load build context                                                                                                                                     0.1s
 => => transferring context: 97.19kB                                                                                                                                  0.1s
 => [1/9] FROM docker.io/library/golang:1.19-alpine3.16@sha256:0eb08c89ab1b0c638a9fe2780f7ae3ab18f6ecda2c76b908e09eb8073912045d                                       0.0s
 => CACHED [2/9] WORKDIR /app                                                                                                                                         0.0s
 => [3/9] COPY . .                                                                                                                                                    0.1s
 => [4/9] RUN apk --update --no-cache add build-base curl                                                                                                             21.9s
 => [5/9] RUN curl -L https://github.com/eficode/wait-for/archive/refs/tags/v2.2.3.tar.gz | tar xvz                                                                   4.4s
 => [6/9] RUN curl -L https://github.com/golang-migrate/migrate/releases/download/v4.15.2/migrate.linux-amd64.tar.gz | tar xvz                                        5.8s
 => [7/9] RUN go install github.com/go-delve/delve/cmd/dlv@v1.9.1                                                                                                     104.6s
 => [8/9] RUN go install github.com/cosmtrek/air@v1.40.4                                                                                                              10.5s
 => [9/9] COPY src/database/migrations ./migrations                                                                                                                   0.0s
 => exporting to image                                                                                                                                                0.5s
 => => exporting layers                                                                                                                                               0.5s
 => => writing image sha256:91e06d514dff7b0f48f13d8e610cdbb0455af132c20dfbf0fc72ccca6688a887                                                                          0.0s
 => => naming to docker.io/library/simple-bank_api                                                                                                                    0.0s
WARNING: Image for service api was built because it did not already exist. To rebuild this image you must use `docker-compose build` or `docker-compose up --build`.
Creating simple-bank-db ... done
Creating simple-bank-api ... done
```

The -d option is for a detached mode allowing to run containers in the background, once the new containers has been created, it prints their names. Find out more at [docker's documentation site](https://docs.docker.com/v17.09/compose/reference/up/).

For checking the containers status and some details just run:

```shell
docker-compose ps -a
```

Something like this will be displayed:

```shell
CONTAINER ID   IMAGE                COMMAND                  CREATED              STATUS            PORTS                                            NAMES
25a1dec94949   simple-bank_api      "/app/wait-for-2.2.3…"   About an hour ago   Up About an hour   0.0.0.0:6868->6868/tcp, 0.0.0.0:8080->8080/tcp   simple-bank-api
ef67401d6d7b   postgres:14-alpine   "docker-entrypoint.s…"   About an hour ago   Up About an hour   0.0.0.0:5432->5432/tcp                           simple-bank-db
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
> `make compose_up` is a wildcard of `docker-compose up -d` command.
>
> `make compose_down` is a wildcard of `docker-compose down && docker rmi -f simple-bank_api` command.
>
> `make compose_down_all` is a wildcard of `docker-compose down -v && docker rmi -f simple-bank_api` command.

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
