package main

import (
	"fmt"
)

// An interface that has zero methods is called an empty interface.
// It is represented as interface{}.
// Since the empty interface has zero methods,
// all types implement the empty interface.
func describe(i interface{}) {
	fmt.Printf("Type = %T, value = %v\n", i, i)
}

func findType(i interface{}) {
	// i.(T) is the syntax which is used to
	// get the underlying value of interface i whose concrete type is T.
	switch i.(type) {
	case string:
		fmt.Printf("I am a string and my value is %s\n", i.(string))
	case int:
		fmt.Printf("I am an int and my value is %d\n", i.(int))
	default:
		fmt.Printf("Unknown type\n")
	}
}

func main() {
	s := "Hello World"
	describe(s) // Type = string, value = Hello World
	i := 55
	describe(i) // Type = int, value = 55
	structure := struct {
		name string
	}{
		name: "Navy R",
	}
	describe(structure) // Type = struct { name string }, value = {Navy R}

	findType("Navy") // I am a string and my value is Navy
	findType(77)     // I am an int and my value is 77
	findType(89.98)  // Unknown type
}
