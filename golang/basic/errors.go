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

func main() {
	err1 := DoSomeThing()
	fmt.Println(err1.Error()) // resource was not found

	// Customize error message
	input := 123
	action := "UPDATE"

	err2 := fmt.Errorf("invalid input %d for action %s", input, action)
	fmt.Println(err2.Error()) // "invalid input 123 for action UPDATE"
}

func errorDemonstration() (string, error) {
	str := "No error found"
	_, err := os.Open("./users.csv")

	if err != nil {
		// It is best practice to assume that it is not safe
		// to use any of the other return values if an error is returned
		return "", err
	}

	// Return nil for error if not found
	return str, nil
}

func DoSomeThing() error {
	var ErrNotFound = errors.New("resource was not found")
	return ErrNotFound
}
