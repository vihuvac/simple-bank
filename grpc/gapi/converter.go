package gapi

import (
	"github.com/vihuvac/simple-bank/grpc/pb"
	db "github.com/vihuvac/simple-bank/src/database/sqlc"
	"google.golang.org/protobuf/types/known/timestamppb"
)

func convertUser(user db.User) *pb.User {
	return &pb.User{
		Username:  user.Username,
		FullName:  user.FullName,
		Email:     user.Email,
		CreatedAt: timestamppb.New(user.CreatedAt),
	}
}
