package main

import (
	"fmt"
)

func digits(number int, digitChannel chan int) {
	for number != 0 {
		digit := number % 10
		digitChannel <- digit
		number /= 10
	}
	close(digitChannel)
}

// The calcSquares and calcCubes Goroutines listen
// on their respective channels using a for range loop until it is closed.
func calcSquares(number int, squareOp chan int) {
	sum := 0
	dch := make(chan int)
	go digits(number, dch)
	for digit := range dch {
		sum += digit * digit
	}
	squareOp <- sum
}

func calcCubes(number int, cubeOp chan int) {
	sum := 0
	dch := make(chan int)
	go digits(number, dch)
	for digit := range dch {
		sum += digit * digit * digit
	}
	cubeOp <- sum
}

func main() {
	number := 589
	sqrCh := make(chan int)
	cubeCh := make(chan int)
	go calcSquares(number, sqrCh)
	go calcCubes(number, cubeCh)
	squares, cubes := <-sqrCh, <-cubeCh
	fmt.Println("Final output", squares+cubes) // Final output 1536
}
