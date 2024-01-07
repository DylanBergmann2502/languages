package main

import "fmt"

type Point struct {
	x int32
	y int32
}

type Circle struct {
	radius float64
	// embedded structs usually have pointers
	center *Point
	// and it doesn't need a name, this lets you access Point's attributes directly like circle.x
	*Point
}

func main() {
	var p1 Point = Point{1, 2}
	fmt.Println(p1, p1.x, p1.y) // {1 2} 1 2

	p2 := &Point{x: 3}
	changeX(p2)
	fmt.Println(*p2) // {100 0}

	c2 := Circle{4.56, &Point{4, 5}, &Point{4, 5}}
	fmt.Println(c2, c2.center, c2.center.x, c2.x) // {4.56 0xc0000960b0 0xc0000960b8} &{4 5} 4 4

	// anonymous struct
	dog := struct {
		name   string
		isGood bool
	}{
		"Rex",
		true,
	}
	fmt.Println(dog) // {Rex true}
}

func changeX(pt *Point) {
	pt.x = 100
}
