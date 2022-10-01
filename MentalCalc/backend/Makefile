test:
	go test ./...

genProto:
	protoc --go_out=internal/handlers/grpc/ --go-grpc_out=internal/handlers/grpc/ pkg/proto/*.proto

runGrpc:
	go run cmd/grpc/main.go
