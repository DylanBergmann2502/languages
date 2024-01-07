package main

import "fmt"

// The zero value of a interface is nil
type Describer interface {
	Describe()
}

func main() {
	var d1 Describer
	if d1 == nil {
		// d1 is nil and has type <nil> value <nil>
		fmt.Printf("d1 is nil and has type %T value %v\n", d1, d1)
	}
	// If we try to call a method on the nil interface,
	// the program will panic since the nil interface
	// neither has a underlying value nor a concrete type.
	// d1.Describe()

}
