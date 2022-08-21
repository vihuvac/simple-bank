# include .env

postgres:
	docker run --rm --name "simple-bank-db" -p 5432:5432 -e POSTGRES_PASSWORD=$(POSTGRES_PASSWORD) -d postgres:14-alpine

createdb:
	docker exec -it simple-bank-db createdb --username=$(POSTGRES_USER) --owner=$(POSTGRES_USER) $(POSTGRES_DB)

dropdb:
	docker exec -it simple-bank-db dropdb --username=$(POSTGRES_USER) $(POSTGRES_DB)

migrateup:
ifdef version
	migrate -path src/database/migrations -database $(DB_URI) -verbose up $(version)
else
	migrate -path src/database/migrations -database $(DB_URI) -verbose up
endif

migratedown:
ifdef version
	migrate -path src/database/migrations -database $(DB_URI) -verbose down $(version)
else
	migrate -path src/database/migrations -database $(DB_URI) -verbose down
endif

db_docs:
	dbdocs build docs/database/db.dbml

db_schema:
	dbml2sql --postgres -o docs/database/schema.sql docs/database/db.dbml

sqlc:
	sqlc generate

test:
	go test -v -cover ./...

server:
	go run src/main.go

mock:
	mockgen -build_flags=--mod=mod -package mockdb -destination src/database/mock/store.go github.com/vihuvac/simple-bank/src/database/sqlc Store


.PHONY: postgres createdb dropdb migrateup migratedown db_docs db_schema sqlc test server mock
