package gapi

import (
	"fmt"

	"github.com/vihuvac/simple-bank/grpc/pb"
	db "github.com/vihuvac/simple-bank/src/database/sqlc"
	"github.com/vihuvac/simple-bank/src/token"
	"github.com/vihuvac/simple-bank/src/utils"
)

// Server servers gRPC requests for the banking service.
type Server struct {
	pb.UnimplementedSimpleBankServer
	config     utils.Config
	store      db.Store
	tokenMaker token.Maker
}

// NewServer creates a new gRPC server.
func NewServer(config utils.Config, store db.Store) (*Server, error) {
	tokenMaker, err := token.NewPasetoMaker(config.TokenSymmetricKey)
	if err != nil {
		return nil, fmt.Errorf("Cannot create the token maker: %w", err)
	}

	server := &Server{
		config:     config,
		store:      store,
		tokenMaker: tokenMaker,
	}

	return server, nil
}
