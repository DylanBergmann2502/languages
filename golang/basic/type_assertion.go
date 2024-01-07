package main

import "fmt"

func main() {
	//  A type assertion allows us to extract
	// the interface value's underlying concrete value
	// using this syntax: interfaceVariable.(concreteType).
	var input interface{} = 12

	str := input.(string) // panic at runtime since input is not a string!
	str, ok := input.(string)

	if !ok {
		str = "a default value"
	}
	fmt.Println(str)

	// Type switch
	var i interface{} = 12 // try: 12.3, true, int64(12), []int{}, map[string]int{}

	switch v := i.(type) {
	case int:
		fmt.Printf("the integer %d\n", v)
	case string:
		fmt.Printf("the string %s\n", v)
	default:
		fmt.Printf("type, %T, not handled explicitly: %#v\n", v, v)
	}
}
