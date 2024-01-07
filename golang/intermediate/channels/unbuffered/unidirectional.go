package main

import "fmt"

func sendData(sendCh chan<- int) {
	sendCh <- 10
}

func main() {
	// It is also possible to create unidirectional channels,
	// that is channels that only send or receive data.
	sendCh := make(chan<- int)
	go sendData(sendCh)

	// When we try to read data from a send only channel,
	// the compiler will raise: invalid operation: cannot receive from send-only channel sendCh
	fmt.Println(<-sendCh)

	// By doing this way, the channel is send only inside sendData Goroutine
	// But still bidirectional in the main Goroutine
	channel := make(chan int)
	go sendData(channel)
	fmt.Println(<-channel)
}
