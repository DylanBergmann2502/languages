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
// Go 1.22: loop variables are per-iteration, so v := v is no longer needed.

func TestParallel(t *testing.T) {
	for _, v := range []int{1, 2, 3} {
		t.Run(fmt.Sprintf("val_%d", v), func(t *testing.T) {
			t.Parallel()
			assertEqual(t, Add(v, v), v*2)
		})
	}
}

// --- Benchmarks: run with go test -bench=. ---

func BenchmarkAdd(b *testing.B) {
	for range b.N {
		Add(1, 2)
	}
}

func BenchmarkDivide(b *testing.B) {
	for range b.N {
		Divide(10, 3)
	}
}

// --- testing/synctest (Go 1.24): deterministic concurrent testing ---
//
// synctest.Run creates a "bubble" with a fake clock. Goroutines inside the
// bubble are paused until they all block, then the fake clock advances.
// This makes time-dependent concurrent tests deterministic and instant.
//
// Run with: GOEXPERIMENT=synctest go test
//
// Example (illustrates the API — requires the synctest experiment flag):
//
//	func TestWithFakeTime(t *testing.T) {
//	    synctest.Run(func() {
//	        done := make(chan struct{})
//	        go func() {
//	            time.Sleep(10 * time.Second) // fake: advances instantly
//	            close(done)
//	        }()
//	        synctest.Wait() // wait until all goroutines in the bubble block
//	        select {
//	        case <-done:
//	            // passed
//	        default:
//	            t.Error("expected done to be closed")
//	        }
//	    })
//	}

