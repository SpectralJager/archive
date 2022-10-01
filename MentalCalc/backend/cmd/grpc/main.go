package main

import (
	"fmt"
	"log"
	"net"
	"os"
	authentication_service "smct/backend/internal/core/services/authentication"
	result_service "smct/backend/internal/core/services/result"
	user_service "smct/backend/internal/core/services/user"
	"smct/backend/internal/handlers/grpc/gateway"
	result_repository "smct/backend/internal/repositories/result"
	token_repository "smct/backend/internal/repositories/token"
	user_repository "smct/backend/internal/repositories/user"

	"github.com/joho/godotenv"
	"google.golang.org/grpc"
	"google.golang.org/grpc/reflection"
)

func main() {
	godotenv.Load(".env")
	// create repositories
	resultRepository := result_repository.NewResultPGRepository(
		os.Getenv("pg_username"),
		os.Getenv("pg_password"),
		os.Getenv("pg_addr"),
		os.Getenv("pg_port"),
		os.Getenv("pg_result_db"),
	)
	userRepository := user_repository.NewUserPGRepository(
		os.Getenv("pg_username"),
		os.Getenv("pg_password"),
		os.Getenv("pg_addr"),
		os.Getenv("pg_port"),
		os.Getenv("pg_user_db"),
	)
	tokenRepository := token_repository.NewTokenRepository(
		os.Getenv("redis_addr"),
		os.Getenv("redis_port"),
		os.Getenv("redis_password"),
	)

	// create services
	resultService := result_service.NewResultService(resultRepository)
	userService := user_service.NewUserService(userRepository)
	authenticationService := authentication_service.NewAuthenticationService(tokenRepository)

	// create grpc server
	server := gateway.NewV1(
		resultService,
		userService,
		authenticationService,
	)

	addr := fmt.Sprintf("localhost:%v", 8080)
	lis, err := net.Listen("tcp", addr)
	if err != nil {
		panic(err)
	}
	grpcServer := grpc.NewServer(
		grpc.UnaryInterceptor(
			server.UnaryInterceptor,
		),
	)
	gateway.RegisterV1Server(grpcServer, server)
	reflection.Register(grpcServer)
	log.Printf("Server start at %v", addr)
	grpcServer.Serve(lis)
}
