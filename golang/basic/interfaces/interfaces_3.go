package main

import (
	"fmt"
)

type Worker interface {
	Work()
}

type Person struct {
	name string
}

func (p Person) Work() {
	fmt.Println(p.name, "is working")
}

func describe(w Worker) {
	fmt.Printf("Interface type %T value %v\n", w, w)
}

func main() {
	p := Person{
		name: "Navy",
	}
	var w Worker = p
	describe(w) // Interface type main.Person value {Navy}
	w.Work()    // Navy is working

}
