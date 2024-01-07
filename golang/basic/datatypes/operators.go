package main

import "fmt"

func main() {
	// Arithmetic Operators
	// + - * / %
	// To convert to a different number type, use int() or float64()
	var num1 int = 9
	var num2 int = 4
	answer := num1 / num2  // 2
	answer3 := num1 % num2 // 1
	fmt.Printf("%d", answer)
	fmt.Printf("%d", answer3)

	var num3 float64 = 9
	var num4 float64 = 4
	answer2 := num3 / num4 // 2.25
	fmt.Printf("%g", answer2)

	a := 1
	a += 2 // same as a = a + 2 == 3

	b := 2
	b -= 2 // same as b = b - 2 == 0

	c := 4
	c *= 2 // same as c = c * 2 == 8

	d := 8
	d /= 2 // same as d = d / 2 == 4

	e := 16
	e %= 2 // same as e = e % 2 == 0

	f := 10
	f++ // same as a += 1, a == 11

	g := 10
	g-- // same as b -= 1, b == 9

	// Comparison Operators
	// < > <= >= == !=
	x := 5
	y := 6
	z := 6.5 // comparison must be between the same type
	val := x < y
	val2 := float64(x)+1.5 == z

	fmt.Printf("%t", val)
	fmt.Printf("%t", val2)

	// Logical Operators
	// ! || &&
	val3 := !(true || false) && !false
	fmt.Printf("%t", val3)
}
