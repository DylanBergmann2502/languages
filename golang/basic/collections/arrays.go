package main

import "fmt"

func main() {
	var arr [5]int // [0 0 0 0 0]
	arr[0] = 1     // [1 0 0 0 0]
	fmt.Println(arr)

	arr2 := [3]int{4, 5, 6}
	fmt.Println(arr2)
	fmt.Println(len(arr2))

	arr2D := [2][3]int{{1, 2, 3}, {3, 4, 5}}
	fmt.Println(arr2D)
}
