package user_repository

import (
	"context"
	"errors"
	"fmt"
	"log"
	"smct/backend/internal/core/domain"
	"time"

	"github.com/jmoiron/sqlx"
	_ "github.com/lib/pq"
)

var schema = `create table if not exists users (
		username text primary key,
		password  text not null
);`

type UserPGRep struct {
	driverName   string
	username     string
	password     string
	addr         string
	port         string
	databaseName string
}

func NewUserPGRepository(user, passwd, addr string, port string, db_name string) *UserPGRep {
	var userRep UserPGRep = UserPGRep{
		driverName:   "postgres",
		username:     user,
		password:     passwd,
		addr:         addr,
		port:         port,
		databaseName: db_name,
	}

	connCtx, cancel := context.WithDeadline(context.TODO(), time.Now().Add(time.Second*5))
	defer cancel()

	db, err := userRep.CreateConn(connCtx)
	if err != nil {
		log.Fatal(err)
	}

	db.MustExec(schema)

	return &userRep
}

func (s *UserPGRep) dbSourceName() string {
	return fmt.Sprintf("postgresql://%s:%s@%s:%s/%s?sslmode=disable", s.username, s.password, s.addr, s.port, s.databaseName)
}

func (s *UserPGRep) CreateConn(ctx context.Context) (*sqlx.DB, error) {
	return sqlx.ConnectContext(ctx, s.driverName, s.dbSourceName())
}

func (s *UserPGRep) Get(username string) (*domain.User, error) {
	connCtx, cancel := context.WithDeadline(context.TODO(), time.Now().Add(time.Second*5))
	defer cancel()

	db, err := s.CreateConn(connCtx)
	if err != nil {
		return nil, err
	}

	user := domain.User{}

	query := "select username, password from users where username=$1"
	err = db.Get(&user, query, username)
	if err != nil {
		return nil, err
	}

	return &user, nil
}

func (s *UserPGRep) Save(user *domain.User) error {
	connCtx, cancel := context.WithDeadline(context.TODO(), time.Now().Add(time.Second*5))
	defer cancel()

	db, err := s.CreateConn(connCtx)
	if err != nil {
		return err
	}

	query := `insert into users (username, password) values (:username, :password)`
	_, err = db.NamedExec(query, user)
	return err
}

func (s *UserPGRep) Update(new, old *domain.User) error {
	connCtx, cancel := context.WithDeadline(context.TODO(), time.Now().Add(time.Second*5))
	defer cancel()

	db, err := s.CreateConn(connCtx)
	if err != nil {
		return err
	}
	log.Println(2)

	query := `update users set username=$1, password=$2 where username=$3 and password=$4`
	res, err := db.Exec(query, new.Username, new.Password, old.Username, old.Password)
	if err != nil {
		return err
	}
	log.Println(res)
	if c, _ := res.RowsAffected(); c == 0 {
		return errors.New("cant update user")
	}
	return nil
}

func (s *UserPGRep) Delete(user *domain.User) error {
	connCtx, cancel := context.WithDeadline(context.TODO(), time.Now().Add(time.Second*5))
	defer cancel()

	db, err := s.CreateConn(connCtx)
	if err != nil {
		return err
	}

	query := `delete from users where username=:username and password=:password`
	_, err = db.NamedExec(query, user)
	return err
}
