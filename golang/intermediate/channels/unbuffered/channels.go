package main

import "fmt"

func main() {
	// zero value of channel = nil
	// nil channels are useless
	var a chan int
	if a == nil {
		fmt.Println("channel a is nil, going to define it")
		// use make to declare channel instead
		a = make(chan int)
		fmt.Printf("Type of a is %T", a)
	}

	// => shorthand: a := make(chan int)

	////////////////////////////////////////////////////////////////
	// Sending and receiving from a channel
	data := <-a // read from channel a
	a <- data   // write to channel a

	////////////////////////////////////////////////////////////////
	/*
		- When data is sent to a channel, the control is blocked
		in the send statement until some other Goroutine reads from that channel.
		- Similarly, when data is read from a channel, the read is blocked
		until some Goroutine writes data to that channel.
	*/
	done := make(chan bool)
	go hello(done)
	<-done // receive from a channel
	fmt.Println("main function")
}

func hello(done chan bool) {
	fmt.Println("Hello world goroutine")
	done <- true // send to a channel
}
