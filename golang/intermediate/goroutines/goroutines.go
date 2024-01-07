package main

import (
	"fmt"
	"time"
)

func hello() {
	fmt.Println("Hello world goroutine")
}

func main() {
	// Unlike functions, the control does not wait for the Goroutine to finish executing.
	// The control returns immediately to the next line of code
	// after the Goroutine call and any return values from the Goroutine are ignored.
	go hello()

	time.Sleep(1 * time.Second)

	// The main Goroutine should be running for any other Goroutines to run.
	// If the main Goroutine terminates then
	// the program will be terminated and no other Goroutine will run.
	fmt.Println("main function")

	// => Hello world goroutine
	// => main function
}
