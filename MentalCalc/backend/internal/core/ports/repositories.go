package ports

import (
	"smct/backend/internal/core/domain"
)

type UserRepository interface {
	Get(username string) (*domain.User, error)
	Save(user *domain.User) error
	Update(new, old *domain.User) error
	Delete(user *domain.User) error
}

type ResultRepository interface {
	Get(gameType, gameMode, username string) (*domain.Result, error)
	GetRange(gameType, gameMode string, start, end int) ([]domain.Result, error)
	Save(gameType, gameMode string, result *domain.Result) error
	Update(gameType, gameMode string, new, old *domain.Result) error
}

type TokenRepository interface {
	Get(username string) (*domain.Token, error)
	Save(username string, token *domain.Token) error
	Delete(username string) error
}
