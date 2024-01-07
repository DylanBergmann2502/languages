package main

func main() {
	/*
		- If a Goroutine is sending data on a channel,
		then it is expected that some other Goroutine should be receiving the data.
		- Similarly, if a Goroutine is waiting to receive data from a channel,
		then some other Goroutine is expected to write data on that channel.
		- If either does not happen, then the program will panic at runtime with Deadlock.
	*/
	ch := make(chan int)
	// only send/write but not receive/read => deadlock
	ch <- 5
}
