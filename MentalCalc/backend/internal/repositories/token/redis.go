package token_repository

import (
	"context"
	"fmt"
	"smct/backend/internal/core/domain"
	"time"

	"github.com/go-redis/redis/v9"
)

type TokenRedisRep struct {
	db *redis.Client
}

func NewTokenRepository(addr string, port string, password string) *TokenRedisRep {
	rdb := redis.NewClient(
		&redis.Options{
			Addr:     fmt.Sprintf("%s:%s", addr, port),
			Password: password,
			DB:       15,
		},
	)
	return &TokenRedisRep{db: rdb}
}

func (s *TokenRedisRep) Get(username string) (*domain.Token, error) {
	ctx, cancel := context.WithDeadline(context.TODO(), time.Now().Add(time.Second*5))
	defer cancel()
	val, err := s.db.Get(ctx, username).Bytes()
	if err != nil {
		return nil, err
	}
	token, err := domain.TokenFromBinary(val)
	if err != nil {
		return nil, err
	}
	return token, nil
}

func (s *TokenRedisRep) Save(username string, token *domain.Token) error {
	ctx, cancel := context.WithDeadline(context.TODO(), time.Now().Add(time.Second*5))
	defer cancel()
	err := s.db.Set(ctx, username, token, time.Hour*2).Err()
	return err
}

func (s *TokenRedisRep) Delete(username string) error {
	ctx, cancel := context.WithDeadline(context.TODO(), time.Now().Add(time.Second*5))
	defer cancel()
	err := s.db.Del(ctx, username).Err()
	return err
}
