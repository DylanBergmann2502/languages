package main

import (
	"fmt"
	"strconv"
)

func main() {
	// From int to float
	var x int = 42  // x has type int
	f := float64(x) // f has type float64
	fmt.Println(f)

	// Custom types
	type Id int
	var num1 int = 121 // number has type int
	userId := Id(num1) // userId now has type Id
	fmt.Println(userId)

	// string to int
	var intString string = "42"
	var i, _ = strconv.Atoi(intString)
	fmt.Println(i)

	// int to string
	var num2 int = 12
	var s string = strconv.Itoa(num2)
	fmt.Println(s)

	// Be careful when do this
	var num3 int = 65
	char := string(num3) // str is now "A" not "65"
	fmt.Println(char)

	// Other common conversion methods from strconv
	/*
		ParseBool:		Convert string to bool
		FormatBool:		Convert bool to string
		ParseFloat:		Convert string to float
		FormatFloat:	Convert float to string
		ParseInt:		Convert string to int
		FormatInt: 		Convert int to string
	*/

}
