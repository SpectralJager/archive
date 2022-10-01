package domain

type User struct {
	Username string `db:"username"`
	Password string `db:"password"`
}

func NewUser(username, password string) *User {
	return &User{
		Username: username,
		Password: password,
	}
}

func (s *User) IsEqual(user *User) bool {
	if s.Username == user.Username && s.Password == user.Password {
		return true
	}
	return false
}
