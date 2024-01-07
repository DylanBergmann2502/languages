package main

import (
	"fmt"
)

func main() {
	ch := make(chan int, 5)
	ch <- 5
	ch <- 6
	close(ch)

	num, open := <-ch
	fmt.Printf("Received: %d, open: %t\n", num, open) // Received: 5, open: true
	num, open = <-ch
	fmt.Printf("Received: %d, open: %t\n", num, open) // Received: 6, open: true
	num, open = <-ch
	fmt.Printf("Received: %d, open: %t\n", num, open) // Received: 0, open: false

	for num := range ch {
		fmt.Println("Received:", num)
	}
}
