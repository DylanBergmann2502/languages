package main

import "fmt"

func main() {
	test()
	a := add(2, 3)
	fmt.Println(a)

	// b, c := addMinus(2, 3)
	b, c := addMinus2(2, 3)
	fmt.Println(b, c)

	// variadic functions
	find(45, 56, 67, 45, 90, 109)
	list := []int{1, 2, 3}
	find(1, list...)

	sum(1, 2)
	sum(1, 2, 3)

	nums := []int{1, 2, 3, 4}
	sum(nums...)
}

func test() {
	fmt.Println("Hello world!")
}

// func add (x int, y int) int
func add(x, y int) int {
	return x + y
}

func addMinus(x, y int) (int, int) {
	return x + y, x - y
}

func addMinus2(x, y int) (z1 int, z2 int) {
	// defer = when you want to execute after the function has returned
	// this can be used to close files
	defer fmt.Println("After return")
	z1 = x + y
	z2 = x - y
	defer fmt.Println("Before return")
	return
}

func find(num int, nums ...int) {
	fmt.Printf("type of nums is %T\n", nums)

	for i, v := range nums {
		if v == num {
			fmt.Println(num, "found at index", i, "in", nums)
			return
		}
	}

	fmt.Println(num, "not found in ", nums)
}

func sum(nums ...int) {
	fmt.Print(nums, " ")
	total := 0

	for _, num := range nums {
		total += num
	}
	fmt.Println(total)
}
