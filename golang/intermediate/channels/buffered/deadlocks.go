package main

import (
	"fmt"
)

func main() {
	ch := make(chan string, 2)
	ch <- "navy"
	ch <- "paul"
	ch <- "steve" // this makes the program panic
	fmt.Println(<-ch)
	fmt.Println(<-ch)
}
