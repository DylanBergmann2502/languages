package main

import "fmt"

// type Stringer interface {
// 	String() string
// }

type DistanceUnit int

const (
	Kilometer DistanceUnit = 0
	Mile      DistanceUnit = 1
)

type Distance struct {
	number float64
	unit   DistanceUnit
}

func main() {
	kmUnit := Kilometer
	p(kmUnit) // => km

	mileUnit := Mile
	p(mileUnit) // => mi

	dist := Distance{
		number: 790.7,
		unit:   Kilometer,
	}
	p(dist) // => 790.7 km
}

func (sc DistanceUnit) String() string {
	units := []string{"km", "mi"}
	return units[sc]
}

func (d Distance) String() string {
	return fmt.Sprintf("%v %v", d.number, d.unit)
}

func p(val interface{}) {
	fmt.Println(val)
}
