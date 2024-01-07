package main

import "fmt"

func main() {
	fn := test
	fn(5)

	// Anonymous functions
	x := func() {
		fmt.Println("hello!")
	}
	x()

	y := func(x int) int {
		return x * -1
	}(8)
	fmt.Println(y)

	// Closures
	z := func(x int) int {
		return x * 7
	}
	outerFunc(z)
}

func test(x int) {
	fmt.Println("Hello world!", x)
}

// This function can have the return type of a function: func(string) string
func outerFunc(innerFunc func(int) int) {
	fmt.Println(innerFunc(5))
}
