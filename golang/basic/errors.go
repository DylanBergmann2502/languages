package main

import (
	"errors"
	"fmt"
	"os"
)

// Error handling is not done via exceptions in Go.
// Instead, errors are normal values of types that implement the built-in error interface.
// type error interface {
// 	Error() string
// }

// Sentinel error — package-level var, compared with ==  or errors.Is
var ErrNotFound = errors.New("resource was not found")

// Custom error type — carries structured context
type ValidationError struct {
	Field   string
	Message string
}

func (e *ValidationError) Error() string {
	return fmt.Sprintf("validation failed on %q: %s", e.Field, e.Message)
}

func main() {
	// --- Basic error values ---
	err := doSomething()
	fmt.Println(err) // resource was not found

	_, err = errorDemonstration()
	if err != nil {
		fmt.Println("file error:", err)
	}

	// --- fmt.Errorf with %w (wrapping, Go 1.13+) ---
	input := 123
	wrapped := fmt.Errorf("processUser: %w", fmt.Errorf("invalid input %d", input))
	fmt.Println(wrapped) // processUser: invalid input 123

	// errors.Is — checks the entire unwrap chain
	base := errors.New("base error")
	chained := fmt.Errorf("layer2: %w", fmt.Errorf("layer1: %w", base))
	fmt.Println(errors.Is(chained, base)) // true

	// errors.As — extract a typed error from the chain
	ve := &ValidationError{Field: "email", Message: "must contain @"}
	wrappedVE := fmt.Errorf("signup: %w", ve)
	var target *ValidationError
	if errors.As(wrappedVE, &target) {
		fmt.Println("field:", target.Field) // field: email
	}

	// errors.Unwrap — step one level up the chain
	inner := errors.New("inner")
	outer := fmt.Errorf("outer: %w", inner)
	fmt.Println(errors.Unwrap(outer)) // inner

	// --- errors.Join (Go 1.20) — combine multiple errors into one ---
	// Both errors are preserved; errors.Is/As work through all of them.
	e1 := errors.New("disk full")
	e2 := errors.New("network timeout")
	e3 := errors.New("permission denied")
	joined := errors.Join(e1, e2, e3)
	fmt.Println(joined)                    // disk full\nnetwork timeout\npermission denied
	fmt.Println(errors.Is(joined, e2))     // true — finds e2 inside the join
	fmt.Println(errors.Is(joined, e3))     // true
	fmt.Println(errors.Is(joined, base))   // false — unrelated error

	// Practical use: collect all validation failures instead of stopping at first
	errs := validateUser("", "notanemail")
	if errs != nil {
		fmt.Println("validation errors:", errs)
	}

	// errors.Join returns nil if all inputs are nil — safe to use as accumulator
	fmt.Println(errors.Join(nil, nil)) // <nil>
}

func doSomething() error {
	return ErrNotFound
}

func errorDemonstration() (string, error) {
	_, err := os.Open("./users.csv")
	if err != nil {
		return "", err
	}
	return "no error", nil
}

// validateUser collects all errors with errors.Join instead of returning on first failure
func validateUser(name, email string) error {
	var errs []error

	if name == "" {
		errs = append(errs, errors.New("name is required"))
	}
	if len(name) > 50 {
		errs = append(errs, &ValidationError{Field: "name", Message: "max 50 chars"})
	}
	if email == "" {
		errs = append(errs, errors.New("email is required"))
	} else if !contains(email, "@") {
		errs = append(errs, &ValidationError{Field: "email", Message: "must contain @"})
	}

	return errors.Join(errs...) // nil if errs is empty
}

func contains(s, sub string) bool {
	for i := range s {
		if s[i:] >= sub && s[i:i+len(sub)] == sub {
			return true
		}
	}
	return false
}
