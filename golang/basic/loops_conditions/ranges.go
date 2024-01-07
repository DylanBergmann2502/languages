package main

import "fmt"

func main() {
	var a []int = []int{1, 2, 3, 4, 5}

	for i := 0; i < len(a); i++ {
		fmt.Println(a[i])
	}

	// iterating over a slice
	for i, element := range a {
		fmt.Printf("%d: %d\n", i, element)
	}

	// iterating over a map
	hash := map[int]int{9: 10, 99: 20, 999: 30}
	for k, v := range hash {
		fmt.Println(k, v)
	}

	// omitting unused key or value
	xi := []int{10, 20, 30}

	for _, x := range xi {
		fmt.Println(x)
	}

	// for i, _ := range xi {
	for i := range xi {
		fmt.Println(i)
	}

	// if you're not interested in both key and value
	count := 0
	for range xi {
		count++
	}
}
