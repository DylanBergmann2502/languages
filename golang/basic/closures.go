package main

import "fmt"

func main() {
	// First-class functions: functions are values
	fn := test
	fn(5)

	// Anonymous function assigned to a variable
	x := func() {
		fmt.Println("hello!")
	}
	x()

	// Immediately invoked anonymous function
	y := func(x int) int {
		return x * -1
	}(8)
	fmt.Println(y) // -8

	// Higher-order function: accepts a function as argument
	z := func(x int) int {
		return x * 7
	}
	outerFunc(z) // 35

	// Closure: a function that captures variables from its surrounding scope
	// The inner function "closes over" count — it reads and mutates it
	counter := makeCounter()
	fmt.Println(counter()) // 1
	fmt.Println(counter()) // 2
	fmt.Println(counter()) // 3

	// Each call to makeCounter returns an independent closure with its own count
	counter2 := makeCounter()
	fmt.Println(counter2()) // 1 (independent from counter)

	// Closure capturing a loop variable
	// Pre-Go 1.22: all closures shared the same loop variable, so you needed
	// `i := i` to shadow it per iteration. Go 1.22+ gives each iteration its
	// own variable automatically — the workaround is no longer needed.
	funcs := make([]func(), 3)
	for i := range 3 { // range over integer (Go 1.22)
		funcs[i] = func() {
			fmt.Println(i) // each closure captures its own i in Go 1.22+
		}
	}
	funcs[0]() // 0
	funcs[1]() // 1
	funcs[2]() // 2

	// adder returns a closure that accumulates a running total
	add := makeAdder(10)
	fmt.Println(add(5))  // 15
	fmt.Println(add(3))  // 18
	fmt.Println(add(12)) // 30
}

func test(x int) {
	fmt.Println("Hello world!", x)
}

func outerFunc(innerFunc func(int) int) {
	fmt.Println(innerFunc(5))
}

func makeCounter() func() int {
	count := 0
	return func() int {
		count++
		return count
	}
}

func makeAdder(initial int) func(int) int {
	sum := initial
	return func(n int) int {
		sum += n
		return sum
	}
}
