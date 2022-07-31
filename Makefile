postgres:
	docker run --rm --name "postgres14" -p 5432:5432 -e POSTGRES_PASSWORD=postgres -d postgres:14

createdb:
	docker exec -it postgres14 createdb --username=postgres --owner=postgres simpleBank

dropdb:
	docker exec -it postgres14 dropdb --username=postgres simpleBank

migrateup:
	migrate -path src/database/migrations -database "postgresql://postgres:postgres@localhost:5432/simpleBank?sslmode=disable" -verbose up

migratedown:
	migrate -path src/database/migrations -database "postgresql://postgres:postgres@localhost:5432/simpleBank?sslmode=disable" -verbose down

sqlc:
	sqlc generate

test:
	go test -v -cover ./...

server:
	go run src/main.go


.PHONY: postgres createdb dropdb migrateup migratedown sqlc test server
