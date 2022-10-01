package authentication_service

import (
	"errors"
	"smct/backend/internal/core/domain"
	"smct/backend/internal/core/ports"
)

type AuthenticationService struct {
	tokenRepository ports.TokenRepository
}

func NewAuthenticationService(
	tokenRepository ports.TokenRepository,
) *AuthenticationService {
	return &AuthenticationService{
		tokenRepository: tokenRepository,
	}
}

func (s *AuthenticationService) CreateToken(username string) (*domain.Token, error) {
	token := domain.NewToken(username)
	err := s.tokenRepository.Save(username, token)
	if err != nil {
		return nil, err
	}
	return token, nil
}

func (s *AuthenticationService) GetToken(username string) (*domain.Token, error) {
	token, err := s.tokenRepository.Get(username)
	if err != nil {
		return nil, err
	}
	return token, nil
}

func (s *AuthenticationService) DeleteToken(username string) error {
	err := s.tokenRepository.Delete(username)
	return err
}

func (s *AuthenticationService) CheckToken(username string, token *domain.Token) error {
	storedToken, err := s.tokenRepository.Get(username)
	if err != nil {
		return err
	}
	if *storedToken != *token {
		return errors.New("wrong token, access denied")
	}
	return nil
}
