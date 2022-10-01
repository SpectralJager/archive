package token_repository_test

import (
	"fmt"
	"smct/backend/internal/core/domain"
	token_repository "smct/backend/internal/repositories/token"
	"strconv"
	"testing"
)

var (
	tokenRep *token_repository.TokenRedisRep
	tokens   = []domain.Token{}
)

func init() {
	tokenRep = token_repository.NewTokenRepository("localhost", "6379", "")
	for i := 0; i < 10; i++ {
		tokens = append(tokens, *domain.NewToken(strconv.Itoa(i)))
	}
}

func TestSave(t *testing.T) {
	descStr := "Try to save %v"
	for i, v := range tokens {
		t.Run(fmt.Sprintf(descStr, v), func(t *testing.T) {
			err := tokenRep.Save(strconv.Itoa(i), &v)
			if err != nil {
				t.Fatal(err)
			}
		})
	}
}

func TestGet(t *testing.T) {
	descStr := "Try to get %v"
	for i, v := range tokens {
		t.Run(fmt.Sprintf(descStr, v), func(t *testing.T) {
			token, err := tokenRep.Get(strconv.Itoa(i))
			if err != nil {
				t.Fatal(err)
			}
			if v != *token {
				t.Fatalf("token %v != %v", v, token)
			}
		})
	}
}

func TestDelete(t *testing.T) {
	descStr := "Try to delete %v"
	for i, v := range tokens {
		t.Run(fmt.Sprintf(descStr, v), func(t *testing.T) {
			err := tokenRep.Delete(strconv.Itoa(i))
			if err != nil {
				t.Fatal(err)
			}
		})
	}
}
