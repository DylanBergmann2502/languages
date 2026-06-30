package main

// testify — the standard assertion library for Go tests.
// Most real Go codebases use testify instead of raw t.Errorf.
//
// Three sub-packages:
//   assert  — continues test on failure (non-fatal)
//   require — stops test on failure (fatal) — use when later steps depend on this
//   mock    — interface mocking with expectations
//
// dep: github.com/stretchr/testify

import (
	"errors"
	"fmt"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/mock"
	"github.com/stretchr/testify/require"
)

// -----------------------------------------------------------------------
// Code under test
// -----------------------------------------------------------------------

type User struct {
	ID    int
	Name  string
	Email string
	Age   int
}

func NewUser(name, email string, age int) (*User, error) {
	if name == "" {
		return nil, errors.New("name is required")
	}
	if age < 0 || age > 150 {
		return nil, fmt.Errorf("invalid age: %d", age)
	}
	return &User{ID: 1, Name: name, Email: email, Age: age}, nil
}

func (u *User) IsAdult() bool { return u.Age >= 18 }
func (u *User) Greet() string { return fmt.Sprintf("Hello, %s!", u.Name) }

// -----------------------------------------------------------------------
// assert — non-fatal, all assertions run even after a failure
// -----------------------------------------------------------------------

func TestAssertBasics(t *testing.T) {
	user, err := NewUser("Alice", "alice@example.com", 30)

	// assert.NoError — cleaner than checking err != nil manually
	assert.NoError(t, err)

	// assert.Equal — deep equality, prints a diff on failure
	assert.Equal(t, "Alice", user.Name)
	assert.Equal(t, 30, user.Age)

	// assert.True / assert.False
	assert.True(t, user.IsAdult())
	assert.False(t, user.IsAdult() == false)

	// assert.Contains — works on strings, slices, maps
	assert.Contains(t, user.Greet(), "Alice")
	assert.Contains(t, []string{"a", "b", "c"}, "b")

	// assert.Len
	items := []int{1, 2, 3}
	assert.Len(t, items, 3)

	// assert.Nil / assert.NotNil
	assert.NotNil(t, user)
	assert.Nil(t, err)

	// assert.Error — expects an error
	_, err2 := NewUser("", "", 0)
	assert.Error(t, err2)
	assert.EqualError(t, err2, "name is required")

	// assert.ErrorIs — checks error chain (works with fmt.Errorf %w)
	sentinel := errors.New("base")
	wrapped := fmt.Errorf("context: %w", sentinel)
	assert.ErrorIs(t, wrapped, sentinel)

	// assert.InDelta — floating point comparison with tolerance
	assert.InDelta(t, 3.14159, 3.14, 0.01)

	// assert.ElementsMatch — same elements regardless of order
	assert.ElementsMatch(t, []int{3, 1, 2}, []int{1, 2, 3})

	// assert.NotEqual
	assert.NotEqual(t, "Bob", user.Name)
}

// -----------------------------------------------------------------------
// require — fatal: stops the test immediately on failure
// Use when subsequent assertions depend on this one passing
// -----------------------------------------------------------------------

func TestRequire(t *testing.T) {
	user, err := NewUser("Bob", "bob@example.com", 25)

	// If this fails, the test stops here — no nil pointer panic below
	require.NoError(t, err)
	require.NotNil(t, user)

	// Safe to use user now
	assert.Equal(t, "Bob", user.Name)
}

func TestRequireVsAssert(t *testing.T) {
	// require: use when the thing you're testing is a precondition
	items, err := fetchItems()
	require.NoError(t, err)    // stop if fetch failed
	require.NotEmpty(t, items) // stop if nothing to iterate

	// assert: use for the actual property checks
	for _, item := range items {
		assert.Greater(t, item, 0)
	}
}

func fetchItems() ([]int, error) {
	return []int{1, 2, 3}, nil
}

// -----------------------------------------------------------------------
// Table-driven tests with assert
// -----------------------------------------------------------------------

func TestNewUser_TableDriven(t *testing.T) {
	tests := []struct {
		name      string
		inputName string
		age       int
		wantErr   bool
		errMsg    string
	}{
		{"valid user", "Alice", 25, false, ""},
		{"empty name", "", 25, true, "name is required"},
		{"negative age", "Bob", -1, true, "invalid age: -1"},
		{"too old", "Carol", 200, true, "invalid age: 200"},
	}

	for _, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			user, err := NewUser(tc.inputName, "x@x.com", tc.age)
			if tc.wantErr {
				require.Error(t, err)
				assert.EqualError(t, err, tc.errMsg)
				assert.Nil(t, user)
			} else {
				require.NoError(t, err)
				assert.NotNil(t, user)
			}
		})
	}
}

// -----------------------------------------------------------------------
// mock — replace interfaces with controllable test doubles
// -----------------------------------------------------------------------

// UserRepository is the interface our code depends on
type UserRepository interface {
	FindByID(id int) (*User, error)
	Save(user *User) error
	Delete(id int) error
}

// MockUserRepository is the testify mock — embed mock.Mock, implement interface
type MockUserRepository struct {
	mock.Mock
}

func (m *MockUserRepository) FindByID(id int) (*User, error) {
	args := m.Called(id)
	if u := args.Get(0); u != nil {
		return u.(*User), args.Error(1)
	}
	return nil, args.Error(1)
}

func (m *MockUserRepository) Save(user *User) error {
	return m.Called(user).Error(0)
}

func (m *MockUserRepository) Delete(id int) error {
	return m.Called(id).Error(0)
}

// UserService is the code under test — depends on the repository interface
type UserService struct {
	repo UserRepository
}

func (s *UserService) GetUser(id int) (*User, error) {
	return s.repo.FindByID(id)
}

func (s *UserService) CreateUser(name, email string, age int) error {
	user, err := NewUser(name, email, age)
	if err != nil {
		return err
	}
	return s.repo.Save(user)
}

func TestUserService_GetUser(t *testing.T) {
	repo := new(MockUserRepository)
	svc := &UserService{repo: repo}

	expected := &User{ID: 42, Name: "Alice", Age: 30}

	// On("method", args...) sets expectation; Return(...) sets return values
	repo.On("FindByID", 42).Return(expected, nil)
	repo.On("FindByID", 999).Return(nil, errors.New("not found"))

	// Happy path
	user, err := svc.GetUser(42)
	require.NoError(t, err)
	assert.Equal(t, "Alice", user.Name)

	// Error path
	_, err = svc.GetUser(999)
	assert.EqualError(t, err, "not found")

	// AssertExpectations verifies all On() calls were actually made
	repo.AssertExpectations(t)
}

func TestUserService_CreateUser(t *testing.T) {
	repo := new(MockUserRepository)
	svc := &UserService{repo: repo}

	// mock.AnythingOfType — match any *User argument
	repo.On("Save", mock.AnythingOfType("*main.User")).Return(nil)

	err := svc.CreateUser("Bob", "bob@example.com", 25)
	assert.NoError(t, err)

	// mock.MatchedBy — custom matcher function
	repo2 := new(MockUserRepository)
	repo2.On("Save", mock.MatchedBy(func(u *User) bool {
		return u.Age >= 18
	})).Return(nil)

	svc2 := &UserService{repo: repo2}
	err = svc2.CreateUser("Carol", "carol@example.com", 22)
	assert.NoError(t, err)
	repo2.AssertExpectations(t)
}

func TestMock_CallCount(t *testing.T) {
	repo := new(MockUserRepository)
	svc := &UserService{repo: repo}

	repo.On("FindByID", mock.AnythingOfType("int")).Return((*User)(nil), errors.New("miss"))

	svc.GetUser(1)
	svc.GetUser(2)
	svc.GetUser(3)

	// Assert it was called exactly 3 times
	repo.AssertNumberOfCalls(t, "FindByID", 3)
}
