package main

import "fmt"

func main() {
	x := 0

	// for initialization (optional); condition; post (optional)
	// for {

	// }

	for x < 5 {
		fmt.Println(x)
		x++
	}

	for x := 0; x < 5; x++ {
		fmt.Println(x)
	}

	for {
		fmt.Println("loop")
		break
	}

	for n := 0; n <= 5; n++ {
		if n%2 == 0 {
			continue
		}
		fmt.Println(n)
	}
}
