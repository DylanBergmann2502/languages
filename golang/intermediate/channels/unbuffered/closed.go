package main

import (
	"fmt"
)

func producer(channel chan int) {
	for i := 0; i < 10; i++ {
		channel <- i
	}
	// Senders have the ability to close the channel
	// to notify receivers that no more data will be sent on the channel.
	close(channel)
}

func main() {
	ch := make(chan int)
	go producer(ch)
	for {
		// check if whether the channel has been closed
		v, ok := <-ch

		// The value read from a closed channel will be the zero value of the channel's type.
		// If the channel is an int channel, the value received from a closed channel will be 0.
		if ok == false {
			fmt.Println("Received ", v, ok)
			break
		}
		fmt.Println("Received ", v, ok)
	}

	// Instead of infinite for loop like above,
	// the for range form of the for loop can be used
	// to receive values from a channel until it is closed.
	// Usually the format for range is (key, value) or (index, value)
	// but with channels, it's (value, ok)
	for v := range ch {
		fmt.Println("Received ", v)
	}
}
