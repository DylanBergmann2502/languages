package main

import (
	"fmt"
	"math"
)

type shape interface {
	area() float64
}

type shape2 interface {
	area() float64
}

type circle struct {
	radius float64
}

type rect struct {
	width  float64
	height float64
}

func main() {
	c1 := circle{4.5}
	r1 := rect{4, 5}
	// shapes := []shape{r1, &c1}
	shapes := []shape{&r1, &c1} // passing in the pointer doesn't hurt

	for _, shape := range shapes {
		fmt.Println(getArea(shape))
	}
}

func (r rect) area() float64 {
	return r.width * r.height
}

func (c *circle) area() float64 {
	return math.Pi * c.radius * c.radius
}

func getArea(s shape) float64 {
	return s.area()
}
