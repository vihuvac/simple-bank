# include .env

postgres:
	docker run --rm --name "postgres14" -p 5432:5432 -e POSTGRES_PASSWORD=$(POSTGRES_PASSWORD) -d postgres:14

createdb:
	docker exec -it postgres14 createdb --username=$(POSTGRES_USER) --owner=$(POSTGRES_USER) $(POSTGRES_DB)

dropdb:
	docker exec -it postgres14 dropdb --username=$(POSTGRES_USER) $(POSTGRES_DB)

migrateup:
	migrate -path src/database/migrations -database $(DB_URI) -verbose up

migratedown:
	migrate -path src/database/migrations -database $(DB_URI) -verbose down

sqlc:
	sqlc generate

test:
	go test -v -cover ./...

server:
	go run src/main.go

mock:
	mockgen -build_flags=--mod=mod -package mockdb -destination src/database/mock/store.go github.com/vihuvac/simple-bank/src/database/sqlc Store


.PHONY: postgres createdb dropdb migrateup migratedown sqlc test server mock
