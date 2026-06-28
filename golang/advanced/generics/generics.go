package main

import (
	"cmp"
	"fmt"
)

// --- Basic generic function ---

func Map[T, U any](s []T, f func(T) U) []U {
	result := make([]U, len(s))
	for i, v := range s {
		result[i] = f(v)
	}
	return result
}

func Filter[T any](s []T, f func(T) bool) []T {
	var result []T
	for _, v := range s {
		if f(v) {
			result = append(result, v)
		}
	}
	return result
}

func Reduce[T, U any](s []T, init U, f func(U, T) U) U {
	acc := init
	for _, v := range s {
		acc = f(acc, v)
	}
	return acc
}

// --- Type constraints ---

// cmp.Ordered covers int, float, string and their variants
func Min[T cmp.Ordered](a, b T) T {
	if a < b {
		return a
	}
	return b
}

func Max[T cmp.Ordered](a, b T) T {
	if a > b {
		return a
	}
	return b
}

func Contains[T comparable](s []T, v T) bool {
	for _, item := range s {
		if item == v {
			return true
		}
	}
	return false
}

// Custom constraint: numeric types only
type Number interface {
	~int | ~int8 | ~int16 | ~int32 | ~int64 |
		~float32 | ~float64
}

func Sum[T Number](s []T) T {
	var total T
	for _, v := range s {
		total += v
	}
	return total
}

// --- Generic data structures ---

type Stack[T any] struct {
	items []T
}

func (s *Stack[T]) Push(v T) {
	s.items = append(s.items, v)
}

func (s *Stack[T]) Pop() (T, bool) {
	if len(s.items) == 0 {
		var zero T
		return zero, false
	}
	top := s.items[len(s.items)-1]
	s.items = s.items[:len(s.items)-1]
	return top, true
}

func (s *Stack[T]) Peek() (T, bool) {
	if len(s.items) == 0 {
		var zero T
		return zero, false
	}
	return s.items[len(s.items)-1], true
}

func (s *Stack[T]) Len() int { return len(s.items) }

// Generic Pair
type Pair[A, B any] struct {
	First  A
	Second B
}

func Zip[A, B any](as []A, bs []B) []Pair[A, B] {
	n := len(as)
	if len(bs) < n {
		n = len(bs)
	}
	result := make([]Pair[A, B], n)
	for i := range result {
		result[i] = Pair[A, B]{as[i], bs[i]}
	}
	return result
}

// --- Union constraint ---

type Stringable interface {
	~string | ~[]byte
}

func ToString[T Stringable](v T) string {
	return string(v)
}

func main() {

	// Map / Filter / Reduce
	nums := []int{1, 2, 3, 4, 5}

	doubled := Map(nums, func(n int) int { return n * 2 })
	fmt.Println(doubled) // [2 4 6 8 10]

	evens := Filter(nums, func(n int) bool { return n%2 == 0 })
	fmt.Println(evens) // [2 4]

	sum := Reduce(nums, 0, func(acc, n int) int { return acc + n })
	fmt.Println(sum) // 15

	// Map to different type
	strs := Map(nums, func(n int) string { return fmt.Sprintf("item%d", n) })
	fmt.Println(strs) // [item1 item2 item3 item4 item5]

	// Ordered constraints
	fmt.Println(Min(3, 7))       // 3
	fmt.Println(Max("apple", "banana")) // banana
	fmt.Println(Contains(nums, 3))      // true
	fmt.Println(Contains([]string{"a", "b"}, "c")) // false

	// Number constraint
	fmt.Println(Sum([]int{1, 2, 3}))         // 6
	fmt.Println(Sum([]float64{1.1, 2.2, 3.3})) // 6.6

	// Generic Stack
	s := &Stack[string]{}
	s.Push("a")
	s.Push("b")
	s.Push("c")
	top, _ := s.Pop()
	fmt.Println(top)   // c
	fmt.Println(s.Len()) // 2

	intStack := &Stack[int]{}
	intStack.Push(10)
	intStack.Push(20)
	v, _ := intStack.Peek()
	fmt.Println(v) // 20

	// Zip
	keys := []string{"a", "b", "c"}
	vals := []int{1, 2, 3}
	pairs := Zip(keys, vals)
	fmt.Println(pairs) // [{a 1} {b 2} {c 3}]

	// Union constraint
	fmt.Println(ToString("hello"))           // hello
	fmt.Println(ToString([]byte("world")))   // world
}
