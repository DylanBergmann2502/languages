package main

import (
	"fmt"
	"time"
)

func server1(ch chan string) {
	time.Sleep(6 * time.Second)
	ch <- "from server1"
}
func server2(ch chan string) {
	time.Sleep(3 * time.Second)
	ch <- "from server2"

}

func process(ch chan string) {
	time.Sleep(10500 * time.Millisecond)
	ch <- "process successful"
}

func main() {
	output1 := make(chan string)
	output2 := make(chan string)
	go server1(output1)
	go server2(output2)
	select {
	case s1 := <-output1:
		fmt.Println(s1)
	case s2 := <-output2:
		fmt.Println(s2)
	}
	// whichever one responds first will be selected by "select"
	// => from server2

	ch := make(chan string)
	go process(ch)
	for {
		time.Sleep(1000 * time.Millisecond)
		select {
		case v := <-ch:
			// for the first 10.5 secs, this won't be executed
			fmt.Println("received value: ", v)
			return
		// The default case in a select statement is executed
		// when none of the other cases is ready
		// This is generally used to prevent the select statement from blocking.
		default:
			fmt.Println("no value received")
		}
	}
	/*
		no value received
		no value received
		no value received
		no value received
		no value received
		no value received
		no value received
		no value received
		no value received
		no value received
		received value:  process successful
	*/
}
