package main

import "fmt"

func main() {
	// x is equal to the value 7
	x := 7
	fmt.Println(x)
	fmt.Println(&x) // &x tells the program to give the reference to x

	y := &x
	// *y tells the program to dereference y to the location where y is pointing to
	*y = 8
	fmt.Println(x, y)

	////////////////////////////////
	toChange := "hello"
	notChangeValue(toChange, "world")
	fmt.Println(toChange)
	changeValue(&toChange, "world")
	fmt.Println(toChange)

	arr := [3]int{3, 4, 5}
	arr2 := &arr
	arr2[0] = 100
	fmt.Println(arr, *arr2)
}

func changeValue(str *string, anoStr string) {
	*str = anoStr
}

func notChangeValue(str string, anoStr string) {
	str = anoStr
}
