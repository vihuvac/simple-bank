package api

import (
	"fmt"

	"github.com/gin-gonic/gin"
	"github.com/gin-gonic/gin/binding"
	"github.com/go-playground/validator/v10"
	db "github.com/vihuvac/simple-bank/src/database/sqlc"
	"github.com/vihuvac/simple-bank/src/token"
	"github.com/vihuvac/simple-bank/src/utils"
)

// Server servers HTTP requests for the banking service.
type Server struct {
	config     utils.Config
	store      db.Store
	router     *gin.Engine
	tokenMaker token.Maker
}

// NewServer creates a new HTTP server and sets up routing.
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

	if v, ok := binding.Validator.Engine().(*validator.Validate); ok {
		v.RegisterValidation("currency", validCurrency)
	}

	server.setupRouter()
	return server, nil
}

func (server *Server) setupRouter() {
	router := gin.Default()

	// Routes that don't require authentication.
	router.POST("/users", server.createUser)
	router.POST("/login", server.loginUser)

	// Create a group of auth routes.
	authRoutes := router.Group("/").Use(authMiddleware(server.tokenMaker))

	authRoutes.POST("/accounts", server.createAccount)
	authRoutes.GET("/accounts/:id", server.getAccountById)
	authRoutes.GET("/accounts", server.getAccounts)

	authRoutes.POST("/transfers", server.createTransfer)

	server.router = router
}

// Start runs the HTTP server on a specific address.
func (server *Server) Start(address string) error {
	return server.router.Run(address)
}

func errorResponse(err error) gin.H {
	return gin.H{"error": err.Error()}
}
