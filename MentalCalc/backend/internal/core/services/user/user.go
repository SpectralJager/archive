package user_service

import (
	"smct/backend/internal/core/domain"
	"smct/backend/internal/core/ports"
)

type UserService struct {
	userRepository ports.UserRepository
}

func NewUserService(userRep ports.UserRepository) *UserService {
	return &UserService{
		userRepository: userRep,
	}
}

func (s *UserService) Create(username, password string) (*domain.User, error) {
	user := domain.NewUser(username, password)
	err := s.userRepository.Save(user)
	if err != nil {
		return nil, err
	}
	return user, nil
}

func (s *UserService) Update(newUser, oldUser *domain.User) error {
	err := s.userRepository.Update(newUser, oldUser)
	return err
}

func (s *UserService) Get(username string) (*domain.User, error) {
	user, err := s.userRepository.Get(username)
	if err != nil {
		return nil, err
	}
	return user, nil
}

func (s *UserService) Delete(user *domain.User) error {
	err := s.userRepository.Delete(user)
	return err
}
