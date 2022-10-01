package domain

type Result struct {
	Position int    `db:"row_number"`
	Scores   string `db:"scores"`
	Lvl      int    `db:"lvl"`
	Username string `db:"username"`
}

func NewResult(scores, username string, lvl int) *Result {
	return &Result{
		Scores:   scores,
		Lvl:      lvl,
		Username: username,
	}
}
