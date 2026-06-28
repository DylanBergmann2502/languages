package main

import "fmt"

func Add(a, b int) int {
	return a + b
}

func Divide(a, b float64) (float64, error) {
	if b == 0 {
		return 0, fmt.Errorf("cannot divide by zero")
	}
	return a / b, nil
}

func main() {
	fmt.Println("Run tests with: go test -v .")
	fmt.Println("Run specific:   go test -run TestAdd -v .")
	fmt.Println("Run with race:  go test -race .")
	fmt.Println("Run benchmarks: go test -bench=. .")

	fmt.Println(Add(2, 3))
	result, err := Divide(10, 2)
	fmt.Println(result, err)
	_, err = Divide(10, 0)
	fmt.Println(err)
}
