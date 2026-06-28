package main

import (
	"fmt"
	"testing"
)

// --- Table-driven tests ---

func TestAdd(t *testing.T) {
	cases := []struct {
		name     string
		a, b     int
		expected int
	}{
		{"positive", 2, 3, 5},
		{"zero", 0, 0, 0},
		{"negative", -1, -2, -3},
		{"mixed", -1, 5, 4},
	}

	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			got := Add(tc.a, tc.b)
			if got != tc.expected {
				t.Errorf("Add(%d, %d) = %d; want %d", tc.a, tc.b, got, tc.expected)
			}
		})
	}
}

func TestDivide(t *testing.T) {
	t.Run("valid", func(t *testing.T) {
		got, err := Divide(10, 2)
		if err != nil {
			t.Fatalf("unexpected error: %v", err)
		}
		if got != 5 {
			t.Errorf("got %f; want 5", got)
		}
	})

	t.Run("divide by zero", func(t *testing.T) {
		_, err := Divide(10, 0)
		if err == nil {
			t.Error("expected error, got nil")
		}
	})
}

// --- t.Helper: failure lines point to the caller, not the helper ---

func assertEqual(t *testing.T, got, want int) {
	t.Helper()
	if got != want {
		t.Errorf("got %d; want %d", got, want)
	}
}

func TestAddWithHelper(t *testing.T) {
	assertEqual(t, Add(1, 1), 2)
	assertEqual(t, Add(10, -5), 5)
}

// --- t.Skip ---

func TestSkipExample(t *testing.T) {
	t.Skip("skipping intentionally")
}

// --- t.Parallel: subtests run concurrently ---

func TestParallel(t *testing.T) {
	tests := []int{1, 2, 3}
	for _, v := range tests {
		v := v
		t.Run(fmt.Sprintf("val_%d", v), func(t *testing.T) {
			t.Parallel()
			assertEqual(t, Add(v, v), v*2)
		})
	}
}

// --- Benchmarks: run with go test -bench=. ---

func BenchmarkAdd(b *testing.B) {
	for i := 0; i < b.N; i++ {
		Add(1, 2)
	}
}

func BenchmarkDivide(b *testing.B) {
	for i := 0; i < b.N; i++ {
		Divide(10, 3)
	}
}
