package main

import "fmt"

func main() {
	// defer will be executed by stack
	defer fmt.Println(1) // last
	defer fmt.Println(2) // second
	defer fmt.Println(3) // first

	fmt.Println(1)
	fmt.Println(2)
	fmt.Println(3)

	// Defer a function that uses recover to handle any panics
	defer func() {
		if r := recover(); r != nil {
			fmt.Println("Recovered from panic:", r) // Recovered from panic: Something went wrong!
		}
	}()

	// Simulate a panic
	panic("Something went wrong!")

	// This line will not be executed because of the panic
	fmt.Println("This line will not be reached.")
}
