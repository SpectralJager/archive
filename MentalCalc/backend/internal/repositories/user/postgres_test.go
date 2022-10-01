package user_repository_test

import (
	"fmt"
	"smct/backend/internal/core/domain"
	user_repository "smct/backend/internal/repositories/user"
	"testing"
)

var (
	userRep *user_repository.UserPGRep
	users   = []domain.User{
		{Username: "test1", Password: "test123"},
		{Username: "test2", Password: "test123"},
		{Username: "test3", Password: "test123"},
		{Username: "test4", Password: "test123"},
		{Username: "test5", Password: "test123"},
		{Username: "test6", Password: "test123"},
		{Username: "test7", Password: "test123"},
		{Username: "test8", Password: "test123"},
		{Username: "test9", Password: "test123"},
		{Username: "test0", Password: "test123"},
	}
)

func TestCreateRepo(t *testing.T) {
	userRep = user_repository.NewUserPGRepository(
		"test",
		"",
		"localhost",
		"5432",
		"mental_calc_test",
	)
}

func TestSave(t *testing.T) {
	descStr := "Try to save %v"
	for _, v := range users {
		t.Run(fmt.Sprintf(descStr, v), func(t *testing.T) {
			err := userRep.Save(&v)
			if err != nil {
				t.Fatal(err)
			}
		})
	}
}

func TestGet(t *testing.T) {
	descStr := "Try to get %v"
	for _, v := range users {
		t.Run(fmt.Sprintf(descStr, v), func(t *testing.T) {
			user, err := userRep.Get(v.Username)
			if err != nil {
				t.Fatal(err)
			}
			if !v.IsEqual(user) {
				t.Fatalf("user %v != %v", v, user)
			}
		})
	}
}

func TestUpdate(t *testing.T) {
	descStr := "Try to update %v"
	for i, v := range users {
		t.Run(fmt.Sprintf(descStr, v), func(t *testing.T) {
			newUser := domain.User{
				Username: v.Username + "updated",
				Password: v.Password,
			}
			err := userRep.Update(&newUser, &v)
			if err != nil {
				t.Fatal(err)
			}
			users[i] = newUser
		})
	}
}

func TestDelete(t *testing.T) {
	descStr := "Try to delete %v"
	for _, v := range users {
		t.Run(fmt.Sprintf(descStr, v), func(t *testing.T) {
			err := userRep.Delete(&v)
			if err != nil {
				t.Fatal(err)
			}
		})
	}
}
