package main

import (
	"fmt"
	"maps"
)

func main() {
	dict := map[string]int{
		"apple":  5,
		"pear":   6,
		"orange": 7,
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

	// A nil map is different from an initialized map — writing to nil panics
	var foo1 map[string]int  // nil map
	foo2 := map[string]int{} // map literal
	foo3 := make(map[string]int)
	fmt.Println(foo1, foo2, foo3)

	// --- maps package (Go 1.21) ---

	scores := map[string]int{"alice": 90, "bob": 75, "carol": 88}

	// maps.Keys — iterate all keys (order not guaranteed)
	for k := range maps.Keys(scores) {
		fmt.Print(k, " ")
	}
	fmt.Println()

	// maps.Values — iterate all values
	for v := range maps.Values(scores) {
		fmt.Print(v, " ")
	}
	fmt.Println()

	// maps.Clone — shallow copy; changes to clone don't affect original
	clone := maps.Clone(scores)
	clone["alice"] = 0
	fmt.Println("original alice:", scores["alice"]) // 90
	fmt.Println("clone alice:   ", clone["alice"])  // 0

	// maps.Copy — merge src into dst (overwrites on collision)
	dst := map[string]int{"alice": 50, "dave": 60}
	src := map[string]int{"alice": 99, "eve": 70}
	maps.Copy(dst, src)
	fmt.Println(dst) // alice=99 (overwritten), dave=60, eve=70

	// maps.DeleteFunc — delete all entries where the predicate is true
	grades := map[string]int{"alice": 90, "bob": 45, "carol": 55, "dave": 80}
	maps.DeleteFunc(grades, func(name string, grade int) bool {
		return grade < 60 // remove failing grades
	})
	fmt.Println(grades) // alice:90 dave:80

	// maps.Equal — true if both maps have identical keys and values
	m1 := map[string]int{"a": 1, "b": 2}
	m2 := map[string]int{"b": 2, "a": 1}
	m3 := map[string]int{"a": 1, "b": 99}
	fmt.Println(maps.Equal(m1, m2)) // true  — order doesn't matter
	fmt.Println(maps.Equal(m1, m3)) // false

	// maps.EqualFunc — equal with custom comparator
	upper := map[string]string{"key": "HELLO"}
	lower := map[string]string{"key": "hello"}
	eq := maps.EqualFunc(upper, lower, func(a, b string) bool {
		return len(a) == len(b) // same length = "equal" for this check
	})
	fmt.Println(eq) // true

	// maps.All — iterate as (key, value) pairs (range-over-func, Go 1.23)
	for k, v := range maps.All(scores) {
		fmt.Printf("%s=%d ", k, v)
	}
	fmt.Println()

	// maps.Collect — build a map from a (key, value) iterator
	// Pairs with slices.All or any iter.Seq2
	collected := maps.Collect(maps.All(scores))
	fmt.Println(collected)
}
