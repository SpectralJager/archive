package gateway

import (
	context "context"
	"log"
	"smct/backend/internal/core/domain"
	authentication_service "smct/backend/internal/core/services/authentication"
	result_service "smct/backend/internal/core/services/result"
	user_service "smct/backend/internal/core/services/user"

	codes "google.golang.org/grpc/codes"
	status "google.golang.org/grpc/status"
)

type V1 struct {
	UnimplementedV1Server
	resultsService        *result_service.ResultService
	userService           *user_service.UserService
	authenticationService *authentication_service.AuthenticationService
}

func NewV1(
	resultsService *result_service.ResultService,
	userService *user_service.UserService,
	authenticationService *authentication_service.AuthenticationService,
) *V1 {
	return &V1{
		resultsService:        resultsService,
		userService:           userService,
		authenticationService: authenticationService,
	}
}

func (s *V1) UserLogin(ctx context.Context, req *UserLoginRequest) (*UserLoginResponse, error) {
	storedUser, err := s.userService.Get(req.User.Username)
	if err == nil && storedUser.IsEqual(domain.NewUser(req.User.Username, req.User.Password)) {
		s.authenticationService.DeleteToken(storedUser.Username)
		token, err := s.authenticationService.CreateToken(storedUser.Username)
		if err != nil {
			return nil, status.Error(codes.Internal, err.Error())
		}
		return &UserLoginResponse{Token: token.ToString()}, nil
	}
	return nil, status.Error(codes.InvalidArgument, "invalid username or password")
}

func (s *V1) UserRegister(ctx context.Context, req *UserRegisterRequest) (*UserRegisterResponse, error) {
	user, err := s.userService.Create(req.User.Username, req.User.Password)
	if err != nil {
		return nil, status.Error(codes.InvalidArgument, err.Error())
	}
	token, err := s.authenticationService.CreateToken(user.Username)
	if err != nil {
		return nil, status.Error(codes.Internal, err.Error())
	}
	return &UserRegisterResponse{
		Token: token.ToString(),
		User: &User{
			Username: user.Username,
			Password: user.Password,
		},
	}, nil
}

func (s *V1) UserUpdate(ctx context.Context, req *UserUpdateRequest) (*UserUpdateResponse, error) {
	newUser := domain.NewUser(req.NewUser.Username, req.NewUser.Password)
	oldUser := domain.NewUser(req.OldUser.Username, req.OldUser.Password)
	if err := s.userService.Update(newUser, oldUser); err != nil {
		return nil, status.Errorf(codes.Internal, err.Error())
	}

	s.authenticationService.DeleteToken(oldUser.Username)
	token, err := s.authenticationService.CreateToken(newUser.Username)
	if err != nil {
		return nil, status.Errorf(status.Code(err), err.Error())
	}

	for _, tp := range domain.GameType {
		for _, md := range domain.GameMode {
			log.Println(tp, " ", md)
			oldResult, err := s.resultsService.Get(tp, md, oldUser.Username)
			if err != nil {
				continue
			}
			log.Println(oldResult)
			newResult := domain.NewResult(oldResult.Scores, newUser.Username, oldResult.Lvl)
			log.Println(newResult)
			s.resultsService.Update(tp, md, newResult, oldResult)
		}
	}
	return &UserUpdateResponse{Token: token.ToString()}, nil
}

func (s *V1) ResultSave(ctx context.Context, req *ResultSaveRequest) (*ResultSaveResponse, error) {
	oldRes, _ := s.resultsService.Get(req.GameType, req.GameMode, req.Result.Username)
	if oldRes != nil {
		newRes := domain.NewResult(req.Result.Scores, req.Result.Username, int(req.Result.Lvl))
		err := s.resultsService.Update(req.GameType, req.GameMode, newRes, oldRes)
		if err != nil {
			return nil, status.Error(status.Code(err), err.Error())
		}
		result, err := s.resultsService.Get(req.GameType, req.GameMode, req.Result.Username)
		if err != nil {
			return nil, status.Error(status.Code(err), err.Error())
		}
		return &ResultSaveResponse{
			Position: int64(result.Position),
			Result: &Result{
				Scores:   result.Scores,
				Username: result.Username,
				Lvl:      int64(result.Lvl),
			},
		}, nil
	}
	result, err := s.resultsService.Create(req.GameType, req.GameMode, req.Result.Scores, req.Result.Username, int(req.Result.Lvl))
	if err != nil {
		return nil, status.Error(status.Code(err), err.Error())
	}
	return &ResultSaveResponse{
		Position: int64(result.Position),
		Result: &Result{
			Scores:   result.Scores,
			Username: result.Username,
			Lvl:      int64(result.Lvl),
		},
	}, nil
}

func (s *V1) ResultGet(ctx context.Context, req *ResultGetRequest) (*ResultGetResponse, error) {
	result, err := s.resultsService.Get(req.GameType, req.GameMode, req.Username)
	if err != nil {
		return nil, status.Error(status.Code(err), err.Error())
	}
	return &ResultGetResponse{
		Position: int64(result.Position),
		Result: &Result{
			Scores:   result.Scores,
			Username: result.Username,
			Lvl:      int64(result.Lvl),
		},
	}, nil
}

func (s *V1) ResultsGet(req *ResultsGetRequest, resp V1_ResultsGetServer) error {
	results, err := s.resultsService.GetRange(req.GameType, req.GameMode, int(req.Start), int(req.Count))
	if err != nil {
		return status.Error(status.Code(err), err.Error())
	}
	for _, result := range results {
		err = resp.Send(
			&ResultsGetResponse{
				Position: int64(result.Position),
				Result: &Result{
					Scores:   result.Scores,
					Username: result.Username,
					Lvl:      int64(result.Lvl),
				},
			},
		)
		if err != nil {
			return err
		}
	}
	return nil
}
