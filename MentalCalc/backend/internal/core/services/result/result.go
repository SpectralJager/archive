package result_service

import (
	"smct/backend/internal/core/domain"
	"smct/backend/internal/core/ports"
)

type ResultService struct {
	resultRepository ports.ResultRepository
}

func NewResultService(resRep ports.ResultRepository) *ResultService {
	return &ResultService{
		resultRepository: resRep,
	}
}

func (s *ResultService) Create(gameType, gameMode, scores, username string, lvl int) (*domain.Result, error) {
	result := domain.NewResult(scores, username, lvl)
	err := s.resultRepository.Save(gameType, gameMode, result)
	if err != nil {
		return nil, err
	}
	result, err = s.resultRepository.Get(gameType, gameMode, result.Username)
	if err != nil {
		return nil, err
	}
	return result, nil
}

func (s *ResultService) Update(gameType, gameMode string, newResult, oldResult *domain.Result) error {
	return s.resultRepository.Update(gameType, gameMode, newResult, oldResult)
}

func (s *ResultService) Get(gameType, gameMode, username string) (*domain.Result, error) {
	result, err := s.resultRepository.Get(gameType, gameMode, username)
	if err != nil {
		return nil, err
	}
	return result, nil
}

func (s *ResultService) GetRange(gameType, gameMode string, start, count int) ([]domain.Result, error) {
	results, err := s.resultRepository.GetRange(gameType, gameMode, start, count)
	if err != nil {
		return []domain.Result{}, err
	}
	return results, nil
}
