package main

import "fmt"

type Describer interface {
	Describe()
}
type Person struct {
	name string
	age  int
}

type Address struct {
	state   string
	country string
}

func (p Person) Describe() { //implemented using value receiver
	fmt.Printf("%s is %d years old\n", p.name, p.age)
}

func (a *Address) Describe() { //implemented using pointer receiver
	fmt.Printf("State %s Country %s", a.state, a.country)
}

func main() {
	var d1 Describer
	p1 := Person{"Sam", 25}
	d1 = p1
	d1.Describe() // Sam is 25 years old
	p2 := Person{"James", 32}
	d1 = &p2
	d1.Describe() // James is 32 years old

	var d2 Describer
	a := Address{"Washington", "USA"}

	/* compilation error if the following line is
	   uncommented
	   cannot use a (type Address) as type Describer
	   in assignment: Address does not implement
	   Describer (Describe method has pointer
	   receiver)
	*/
	//d2 = a

	d2 = &a //This works since Describer interface
	//is implemented by Address pointer in line 22
	d2.Describe() // State Washington Country USA

}
