package main

import "fmt"

func main() {

	var dict map[string]int = map[string]int{
		"apple":  5,
		"pear":   6,
		"orange": 7, // Always have comma at the end
	}
	dict2 := make(map[string]int)

	dict["apple"] = 4
	dict["grape"] = 3

	_, ok := dict["apple"]
	if ok {
		delete(dict, "apple")
	}

	fmt.Println(dict, dict2)

	clear(dict)
	fmt.Println(dict)

	// A nil map is different from initialized map, writing to an nil map will cause a runtime error
	var foo1 map[string]int  // nil map
	foo2 := map[string]int{} // map literal
	foo3 := make(map[string]int)
	fmt.Println(foo1, foo2, foo3)
}
