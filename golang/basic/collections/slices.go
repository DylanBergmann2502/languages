package main

import "fmt"

func main() {
	var arr [5]int = [5]int{1, 2, 3, 4, 5}
	var s []int = arr[1:3]

	fmt.Println(s)          // [2 3]
	fmt.Println(len(s))     // 2
	fmt.Println(cap(s))     // 4
	fmt.Println(s[:cap(s)]) // [2 3 4 5]

	var arr2 []int = []int{5, 6, 7, 8, 9}
	// you cannot increase the size of a slice, you have to go around this
	arr3 := append(arr2, 10)
	fmt.Println(arr3) // [5 6 7 8 9 10]

	// make(slice + type, number of default elements, capacity)
	arr4 := make([]int, 5)
	fmt.Println(arr4) // [0 0 0 0 0]

	var s1 []int  // nil slice, this one should be preferred
	s2 := []int{} // empty, non-nil slice
	fmt.Println(s1, s2)
}
