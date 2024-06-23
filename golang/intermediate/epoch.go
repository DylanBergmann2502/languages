package main

import (
	"fmt"
	"time"
)

func main() {

	now := time.Now()
	fmt.Println(now) // 2012-10-31 16:13:58.292387 +0000 UTC

	fmt.Println(now.Unix())      // 1351700038
	fmt.Println(now.UnixMilli()) // 1351700038292
	fmt.Println(now.UnixNano())  // 1351700038292387000

	fmt.Println(time.Unix(now.Unix(), 0))     // 2012-10-31 16:13:58 +0000 UTC
	fmt.Println(time.Unix(0, now.UnixNano())) // 2012-10-31 16:13:58.292387 +0000 UTC
}
