package main

import (
	"fmt"
	"slices"
)

func main() {
	var arr [5]int = [5]int{1, 2, 3, 4, 5}
	var s []int = arr[1:3]

	fmt.Println(s)          // [2 3]
	fmt.Println(len(s))     // 2
	fmt.Println(cap(s))     // 4
	fmt.Println(s[:cap(s)]) // [2 3 4 5]

	arr2 := []int{5, 6, 7, 8, 9}
	arr3 := append(arr2, 10)
	fmt.Println(arr3) // [5 6 7 8 9 10]

	// make(type, len, cap)
	arr4 := make([]int, 5)
	fmt.Println(arr4) // [0 0 0 0 0]

	var s1 []int  // nil slice — preferred zero value
	s2 := []int{} // non-nil empty slice
	fmt.Println(s1, s2)

	// --- slices package (Go 1.21) ---

	nums := []int{3, 1, 4, 1, 5, 9, 2, 6}

	// slices.Contains / slices.Index
	fmt.Println(slices.Contains(nums, 5))  // true
	fmt.Println(slices.Index(nums, 9))     // 5

	// slices.Reverse — in place
	rev := slices.Clone(nums)
	slices.Reverse(rev)
	fmt.Println(rev) // [6 2 9 5 1 4 1 3]

	// slices.Sort / slices.IsSorted
	sorted := slices.Clone(nums)
	slices.Sort(sorted)
	fmt.Println(sorted)                  // [1 1 2 3 4 5 6 9]
	fmt.Println(slices.IsSorted(sorted)) // true

	// slices.BinarySearch — requires sorted slice, returns (index, found)
	idx, found := slices.BinarySearch(sorted, 5)
	fmt.Println(idx, found) // 5 true

	// slices.Max / slices.Min
	fmt.Println(slices.Max(nums)) // 9
	fmt.Println(slices.Min(nums)) // 1

	// slices.Compact — remove consecutive duplicates (like Unix uniq)
	duped := []int{1, 1, 2, 3, 3, 3, 4}
	fmt.Println(slices.Compact(duped)) // [1 2 3 4]

	// slices.Equal
	a := []int{1, 2, 3}
	b := []int{1, 2, 3}
	c := []int{1, 2, 4}
	fmt.Println(slices.Equal(a, b)) // true
	fmt.Println(slices.Equal(a, c)) // false

	// slices.Clone — shallow copy
	clone := slices.Clone(nums)
	clone[0] = 99
	fmt.Println(nums[0], clone[0]) // 3 99 — independent

	// slices.Collect — build a slice from an iterator (Go 1.23)
	// Pairs with maps.Keys, maps.Values, or any iter.Seq
	collected := slices.Collect(slices.Values(sorted))
	fmt.Println(collected) // [1 1 2 3 4 5 6 9]

	// slices.Sorted — sort an iterator into a new slice (Go 1.23)
	unsortedIter := slices.Values([]int{5, 3, 8, 1})
	fmt.Println(slices.Sorted(unsortedIter)) // [1 3 5 8]

	// min / max builtins (Go 1.21) — not slices-package, just language
	fmt.Println(min(3, 7))    // 3
	fmt.Println(max(3, 7))    // 7
	fmt.Println(min(1, 2, 3)) // 1 — variadic
}
