package main

import "fmt"

func main() {
	// implicit assignment
	var number = 260

	// expression assignment operator
	number2 := 6

	// default value
	var bl bool

	fmt.Printf("%T", number)

	fmt.Println("")

	fmt.Printf("%T", number2)

	fmt.Println("")

	fmt.Println(bl)

	// Zero values
	/*
		boolean: 	false
		numeric:	0
		string:		""
		pointer:	nil
		function:	nil
		interface:	nil
		slice:		nil
		channel: 	nil
		map: 		nil
	*/
}
