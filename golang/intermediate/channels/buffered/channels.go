package main

import (
	"fmt"
)

func main() {
	// Sends to a buffered channel are blocked only when the buffer is full.
	// Similarly receives from a buffered channel are blocked only when the buffer is empty.
	// make(chan type, capacity)
	ch := make(chan string, 2)
	ch <- "navy"
	ch <- "paul"
	fmt.Println(<-ch)
	fmt.Println(<-ch)
}
