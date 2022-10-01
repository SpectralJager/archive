package result_repository

import (
	"context"
	"fmt"
	"log"
	"smct/backend/internal/core/domain"
	"strings"
	"time"

	"github.com/jmoiron/sqlx"
	_ "github.com/lib/pq"
)

var schema = `create table if not exists %s_%s (
		username  text primary key,
		scores text not null,
		lvl text not null
);`

type ResultPGRep struct {
	driverName   string
	username     string
	password     string
	addr         string
	port         string
	databaseName string
}

func NewResultPGRepository(user, passwd, addr, port, db_name string) *ResultPGRep {
	var resultRep ResultPGRep = ResultPGRep{
		driverName:   "postgres",
		username:     user,
		password:     passwd,
		addr:         addr,
		port:         port,
		databaseName: db_name,
	}

	connCtx, cancel := context.WithDeadline(context.TODO(), time.Now().Add(time.Second*20))
	defer cancel()

	db, err := resultRep.CreateConn(connCtx)
	if err != nil {
		log.Fatal(err)
	}

	tx := db.MustBegin()
	for _, tp := range domain.GameType {
		for _, md := range domain.GameMode {
			tempStr := fmt.Sprintf(schema, strings.ToLower(tp), strings.ToLower(md))
			tx.MustExec(tempStr)
		}
	}
	err = tx.Commit()
	if err != nil {
		log.Fatal(err)
	}

	return &resultRep
}

func (s *ResultPGRep) dbSourceName() string {
	return fmt.Sprintf("postgresql://%s:%s@%s:%s/%s?sslmode=disable", s.username, s.password, s.addr, s.port, s.databaseName)
}

func (s *ResultPGRep) CreateConn(ctx context.Context) (*sqlx.DB, error) {
	return sqlx.ConnectContext(ctx, s.driverName, s.dbSourceName())
}

func (s *ResultPGRep) Get(gameType, gameMode, username string) (*domain.Result, error) {
	connCtx, cancel := context.WithDeadline(context.TODO(), time.Now().Add(time.Second*5))
	defer cancel()

	db, err := s.CreateConn(connCtx)
	if err != nil {
		return nil, err
	}

	result := domain.NewResult("", username, 0)

	sqlStr := `select * from (select row_number() over(order by scores desc),username, scores, lvl from %v_%v) as x where username=$1`
	tempStr := fmt.Sprintf(sqlStr, strings.ToLower(gameType), strings.ToLower(gameMode))
	err = db.Get(result, tempStr, username)
	if err != nil {
		return nil, err
	}

	return result, nil
}
func (s *ResultPGRep) GetRange(gameType, gameMode string, start, count int) ([]domain.Result, error) {
	connCtx, cancel := context.WithDeadline(context.TODO(), time.Now().Add(time.Second*5))
	defer cancel()

	db, err := s.CreateConn(connCtx)
	if err != nil {
		return nil, err
	}

	results := []domain.Result{}

	sqlStr := fmt.Sprintf(`select * from (select row_number() over(order by scores desc),username, scores, lvl from %v_%v) as x offset %d limit %d`, strings.ToLower(gameType), strings.ToLower(gameMode), start, count)
	err = db.Select(&results, sqlStr)
	if err != nil {
		return results, err
	}

	// for _, v := range results {
	// 	v.GameType = gameType
	// 	v.GameMode = gameMode
	// }

	return results, nil

}

func (s *ResultPGRep) Save(gameType, gameMode string, result *domain.Result) error {
	connCtx, cancel := context.WithDeadline(context.TODO(), time.Now().Add(time.Second*5))
	defer cancel()

	db, err := s.CreateConn(connCtx)
	if err != nil {
		return err
	}

	query := fmt.Sprintf(`insert into %s_%s (username, scores, lvl) values (:username, :scores, :lvl)`, strings.ToLower(gameType), strings.ToLower(gameMode))
	_, err = db.NamedExec(query, result)

	return err
}

func (s *ResultPGRep) Update(gameType, gameMode string, new, old *domain.Result) error {
	connCtx, cancel := context.WithDeadline(context.TODO(), time.Now().Add(time.Second*5))
	defer cancel()

	db, err := s.CreateConn(connCtx)
	if err != nil {
		return err
	}

	query := fmt.Sprintf(`update %s_%s set username=$1, scores=$2, lvl=$3 where username=$4 and scores=$5 and lvl=$6`,
		strings.ToLower(gameType),
		strings.ToLower(gameMode),
	)
	_, err = db.Exec(query, new.Username, new.Scores, new.Lvl, old.Username, old.Scores, old.Lvl)

	return err
}
