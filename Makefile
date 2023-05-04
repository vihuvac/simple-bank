ENV_FILE := ./.env

ifeq ($(wildcard $(ENV_FILE)),)
  $(error $(ENV_FILE) does not exist.)
else
	include $(ENV_FILE)
endif


postgres:
	docker run --rm --name "simple-bank-db" -p 5432:5432 -e POSTGRES_PASSWORD=$(POSTGRES_PASSWORD) -d postgres:15.2-alpine3.17

createDB:
	docker exec -it simple-bank-db createdb --username=$(POSTGRES_USER) --owner=$(POSTGRES_USER) $(POSTGRES_DB)

dropDB:
	docker exec -it simple-bank-db dropdb --username=$(POSTGRES_USER) $(POSTGRES_DB)

migrateUp:
ifdef version
	migrate -path src/database/migrations -database $(DB_URI) -verbose up $(version)
else
	migrate -path src/database/migrations -database $(DB_URI) -verbose up
endif

migrateDown:
ifdef version
	migrate -path src/database/migrations -database $(DB_URI) -verbose down $(version)
else
	migrate -path src/database/migrations -database $(DB_URI) -verbose down
endif

dbDocs:
	dbdocs build docs/database/db.dbml

dbSchema:
	dbml2sql --postgres -o docs/database/schema.sql docs/database/db.dbml

sqlc:
	sqlc generate

test:
	go test -v -cover ./...

server:
	go run src/main.go

mock:
	mockgen -build_flags=--mod=mod -package mockdb -destination src/database/mock/store.go github.com/vihuvac/simple-bank/src/database/sqlc Store

composeUp:
	docker-compose up -d

composeDown:
	docker-compose down && docker rmi -f simple-bank-api

composeDownAll:
	docker-compose down -v && docker rmi -f simple-bank-api


.PHONY: postgres createDB dropDB migrateUp migrateDown dbDocs dbSchema sqlc test server mock composeUp composeDown composeDownAll
