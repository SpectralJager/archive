package result_repository_test

import (
	"fmt"
	"smct/backend/internal/core/domain"
	result_repository "smct/backend/internal/repositories/result"
	"testing"
)

var (
	resultRep *result_repository.ResultPGRep
	gameMode  = domain.GameMode[0]
	gameType  = domain.GameType[0]
	resutls   = []domain.Result{
		{Username: "test1", Scores: "123", Lvl: 1},
		{Username: "test2", Scores: "123", Lvl: 1},
		{Username: "test3", Scores: "123", Lvl: 1},
		{Username: "test4", Scores: "123", Lvl: 1},
		{Username: "test5", Scores: "123", Lvl: 1},
		{Username: "test6", Scores: "123", Lvl: 1},
		{Username: "test7", Scores: "123", Lvl: 1},
		{Username: "test8", Scores: "123", Lvl: 1},
		{Username: "test9", Scores: "123", Lvl: 1},
		{Username: "test0", Scores: "123", Lvl: 1},
	}
)

func TestCreateRepo(t *testing.T) {
	resultRep = result_repository.NewResultPGRepository(
		"test",
		"",
		"localhost",
		"5432",
		"mental_calc_test",
	)
}

func TestSave(t *testing.T) {
	descStr := "Try to save %v"
	for _, v := range resutls {
		t.Run(fmt.Sprintf(descStr, v), func(t *testing.T) {
			err := resultRep.Save(gameType, gameMode, &v)
			if err != nil {
				t.Fatal(err)
			}
		})
	}
}

func TestGet(t *testing.T) {
	descStr := "Try to get %v"
	for _, v := range resutls {
		t.Run(fmt.Sprintf(descStr, v), func(t *testing.T) {
			result, err := resultRep.Get(gameType, gameMode, v.Username)
			if err != nil {
				t.Fatal(err)
			}
			if result.Username != v.Username {
				t.Fatalf("user %v != %v", v, result)
			}
		})
	}
}

func TestGetRange(t *testing.T) {
	descStr := "Try to getRange %v"
	for _, v := range resutls {
		t.Run(fmt.Sprintf(descStr, v), func(t *testing.T) {
			_, err := resultRep.GetRange(gameType, gameMode, 1, 11)
			if err != nil {
				t.Fatal(err)
			}

		})
	}
}

func TestUpdate(t *testing.T) {
	descStr := "Try to update %v"
	for _, v := range resutls {
		t.Run(fmt.Sprintf(descStr, v), func(t *testing.T) {
			newResult := domain.NewResult(
				v.Scores+"123",
				v.Username+"updated",
				v.Lvl+1,
			)
			err := resultRep.Update(gameType, gameMode, newResult, &v)
			if err != nil {
				t.Fatal(err)
			}
		})
	}
}
