package main

import "fmt"

func main() {
	// Immutable datatypes
	x := 5
	y := x
	y = 7
	fmt.Println(x, y)

	arr := [3]int{3, 4, 5}
	arr2 := arr
	arr2[0] = 100
	fmt.Println(arr, arr2)

	// Mutable datatypes
	sl := []int{3, 4, 5}
	sl2 := sl
	sl2[0] = 100
	fmt.Println(sl, sl2)

	dict := map[string]int{"hello": 3}
	dict2 := dict
	dict2["hello"] = 100
	fmt.Println(dict, dict2)

	// Function related
	num1 := 5
	fmt.Println(num1)
	changeValue(num1, 3) // changes don't persist
	fmt.Println(num1)

	sl3 := []int{3, 4, 5}
	fmt.Println(sl3)
	changeSlice(sl3) // changes persist
	fmt.Println(sl3)
}

func changeSlice(slice []int) {
	slice[0] = 100
}

func changeValue(num int, num2 int) {
	num = num2
}
