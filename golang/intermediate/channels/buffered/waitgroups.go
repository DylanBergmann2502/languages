package main

import (
	"fmt"
	"sync"
	"time"
)

func process(i int, wg *sync.WaitGroup) {
	fmt.Println("started Goroutine ", i)
	time.Sleep(2 * time.Second)
	fmt.Printf("Goroutine %d ended\n", i)
	wg.Done()
}

func main() {
	no := 3
	// WaitGroup is a struct type
	var wg sync.WaitGroup
	for i := 0; i < no; i++ {
		// - When we call Add on the WaitGroup and pass it an int,
		// the WaitGroup's counter is incremented by the value passed to Add.
		// - The way to decrement the counter is by calling Done() method on the WaitGroup.
		wg.Add(1)
		// remember to pass in the pointer
		go process(i, &wg)
	}
	// The Wait() method blocks the Goroutine in which it's called
	// until the counter becomes zero.
	wg.Wait()
	fmt.Println("All go routines finished executing")
}
