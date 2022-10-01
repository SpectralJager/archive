package gateway

import (
	context "context"
	"fmt"
	"log"
	"smct/backend/internal/core/domain"
	"strings"

	"golang.org/x/exp/slices"
	grpc "google.golang.org/grpc"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/metadata"
	"google.golang.org/grpc/status"
)

func (s *V1) UnaryInterceptor(ctx context.Context, req interface{}, info *grpc.UnaryServerInfo, handler grpc.UnaryHandler) (interface{}, error) {
	logger(ctx, info)
	notAuth := []string{
		"/gateway.v1/UserLogin",
		"/gateway.v1/UserRegister",
	}
	if slices.Contains(notAuth, info.FullMethod) {
		return handler(ctx, req)
	}
	err := s.isAuthenticated(ctx)
	if err != nil {
		return nil, status.Error(codes.PermissionDenied, err.Error())
	}
	return handler(ctx, req)
}

func logger(ctx context.Context, info *grpc.UnaryServerInfo) {
	md, ok := metadata.FromIncomingContext(ctx)
	if !ok {
		return
	}
	log.Printf("---> %v", info.FullMethod)
	fmt.Printf("\t authority: %v\n", md.Get(":authority"))
	fmt.Printf("\t user-agent: %v\n", md.Get("user-agent"))
	fmt.Printf("\t token: %v\n", md.Get("token"))
}

func (s *V1) isAuthenticated(ctx context.Context) error {
	md, ok := metadata.FromIncomingContext(ctx)
	if !ok {
		return status.Error(codes.Aborted, "cant access headers")
	}
	headerToken := md.Get("token")[0]
	if headerToken == "" {
		return status.Error(codes.Unauthenticated, "cant access token")
	}
	temp := strings.Split(headerToken, ".")
	username := temp[0]
	token := domain.Token(temp[1])
	return s.authenticationService.CheckToken(username, &token)
}
