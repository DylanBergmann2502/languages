package main

import (
	"cmp"
	"fmt"
	"slices"
	"sort"
)

func main() {

	// --- sort package (classic) ---

	ints := []int{5, 2, 4, 1, 3}
	sort.Ints(ints)
	fmt.Println(ints) // [1 2 3 4 5]

	strs := []string{"banana", "apple", "cherry"}
	sort.Strings(strs)
	fmt.Println(strs) // [apple banana cherry]

	floats := []float64{3.14, 1.41, 2.71}
	sort.Float64s(floats)
	fmt.Println(floats) // [1.41 2.71 3.14]

	fmt.Println(sort.IntsAreSorted(ints))   // true
	fmt.Println(sort.SearchInts(ints, 3))   // 2 (index)

	// Custom sort via sort.Slice
	type Person struct {
		Name string
		Age  int
	}
	people := []Person{
		{"Alice", 30},
		{"Bob", 25},
		{"Charlie", 35},
	}
	sort.Slice(people, func(i, j int) bool {
		return people[i].Age < people[j].Age
	})
	fmt.Println(people) // [{Bob 25} {Alice 30} {Charlie 35}]

	// sort.SliceStable preserves original order for equal elements
	sort.SliceStable(people, func(i, j int) bool {
		return people[i].Name < people[j].Name
	})
	fmt.Println(people) // [{Alice 30} {Bob 25} {Charlie 35}]

	// Implement sort.Interface on a custom type
	type ByLength []string
	// sort.Interface requires Len, Less, Swap
	words := []string{"fig", "kiwi", "apple", "plum"}
	sort.Slice(words, func(i, j int) bool {
		return len(words[i]) < len(words[j])
	})
	fmt.Println(words) // [fig kiwi plum apple]

	// --- slices package (Go 1.21+, generic) ---

	nums := []int{5, 2, 4, 1, 3}
	slices.Sort(nums)
	fmt.Println(nums) // [1 2 3 4 5]

	fmt.Println(slices.IsSorted(nums)) // true

	idx, found := slices.BinarySearch(nums, 3)
	fmt.Println(idx, found) // 2 true

	// SortFunc with custom comparator using cmp.Compare
	names := []string{"banana", "Apple", "cherry"}
	slices.SortFunc(names, func(a, b string) int {
		return cmp.Compare(a, b)
	})
	fmt.Println(names) // [Apple banana cherry]

	// Sort structs with SortFunc
	people2 := []Person{{"Alice", 30}, {"Bob", 25}, {"Charlie", 35}}
	slices.SortFunc(people2, func(a, b Person) int {
		return cmp.Compare(a.Age, b.Age)
	})
	fmt.Println(people2) // [{Bob 25} {Alice 30} {Charlie 35}]

	// Reverse sort
	slices.SortFunc(nums, func(a, b int) int {
		return cmp.Compare(b, a) // swap a,b for descending
	})
	fmt.Println(nums) // [5 4 3 2 1]

	// Min / Max
	fmt.Println(slices.Min([]int{3, 1, 4, 1, 5})) // 1
	fmt.Println(slices.Max([]int{3, 1, 4, 1, 5})) // 5

	// Contains / Index
	fmt.Println(slices.Contains([]string{"a", "b", "c"}, "b")) // true
	fmt.Println(slices.Index([]string{"a", "b", "c"}, "c"))    // 2
}
