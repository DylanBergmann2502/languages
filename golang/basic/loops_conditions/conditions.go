package main

import "fmt"

func main() {
	age := 22
	if age < 15 {
		fmt.Println("You can't drink just yet")
	} else if age < 18 {
		fmt.Println("You're almost there")
	} else {
		fmt.Println("It's cool ")
	}
}
