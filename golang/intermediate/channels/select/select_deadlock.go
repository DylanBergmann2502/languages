package main

import "fmt"

func main() {
	ch := make(chan string)
	select {
	// this is a deadlock
	case <-ch:
	// the default case will be executed even if the select has only nil channels.
	case v := <-ch:
		fmt.Println("received value", v)
	default:
		fmt.Println("default case executed")
	}
}
