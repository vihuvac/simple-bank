package main

import (
	"database/sql"
	"log"

	_ "github.com/lib/pq"
	"github.com/vihuvac/simple-bank/src/api"
	db "github.com/vihuvac/simple-bank/src/database/sqlc"
)

const (
	dbDriver      = "postgres"
	dbSource      = "postgresql://postgres:postgres@localhost:5432/simpleBank?sslmode=disable"
	serverAddress = "0.0.0.0:8080"
)

func main() {
	conn, err := sql.Open(dbDriver, dbSource)
	if err != nil {
		log.Fatal("Cannot connect to database:", err)
	}

	store := db.NewStore(conn)
	server := api.NewServer(store)

	err = server.Start(serverAddress)
	if err != nil {
		log.Fatal("Cannot start server:", err)
	}
}
