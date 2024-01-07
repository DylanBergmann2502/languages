package main

import "fmt"

func main() {
	ans := 3

	switch ans {
	case 1:
		fmt.Println(1)
	case 2:
		fmt.Println(2)
	default:
		fmt.Println("not a case")
	}

	switch {
	case ans > 0:
		fmt.Println("greater than zero")
	case ans < 0:
		fmt.Println("less than zero")
	}

	// using fallthrough keyword to continue the program
	age := 21

	switch {
	case age > 20:
		// do something if age is greater than 20
		fallthrough
	case age > 30:
		// Since the previous case uses 'fallthrough',
		// this code will now run if age is also greater than 30
	default:
		// do something else for every other case
	}
}
