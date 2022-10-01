package ports

import (
	domain "smct/backend/internal/core/domain"
)

type UserService interface {
	Create(username, password string) (*domain.User, error)
	Update(newUser, oldUser *domain.User) error
	Get(username string) (*domain.User, error)
	Delete(user *domain.User) error
}

type ResultService interface {
	Create(gameType, gameMode, scores, username string, lvl int) (*domain.Result, error)
	Update(newResult, oldResult *domain.Result) error
	Get(gameType, gameMode, username string) (*domain.Result, error)
	GetRange(gameType, gameMode string, start, end int) (*domain.Result, error)
}

type Authentication interface {
	CreateToken(username string) (*domain.Token, error)
	GetToken(username string) (*domain.Token, error)
	CheckToken(username string, token *domain.Token) (bool, error)
	DeleteToken(username string, token *domain.Token) error
}

type Authorization interface {
	Login(username, password string) (*domain.Token, error)
	Register(username, password string) (*domain.Token, error)
	Logout(user *domain.User) error
	Delete(user *domain.User) error
}
