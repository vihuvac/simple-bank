package main

import (
	"database/sql"
	"log"

	_ "github.com/lib/pq"
	"github.com/vihuvac/simple-bank/src/api"
	db "github.com/vihuvac/simple-bank/src/database/sqlc"
	"github.com/vihuvac/simple-bank/src/utils"
)

func main() {
	config, err := utils.LoadConfig(".")
	if err != nil {
		log.Fatal("Cannot load config: ", err)
	}

	conn, err := sql.Open(config.DBDriver, config.DBUri)
	if err != nil {
		log.Fatal("Cannot connect to database:", err)
	}

	store := db.NewStore(conn)
	server, err := api.NewServer(config, store)
	if err != nil {
		log.Fatal("Cannot create the server:", err)
	}

	err = server.Start(config.ServerAddress)
	if err != nil {
		log.Fatal("Cannot start server:", err)
	}
}
