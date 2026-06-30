package main

// github.com/sourcegraph/conc — structured concurrency for Go.
//
// The problem with raw goroutines:
//   go func() { ... }()   — panics crash the whole program, not just the goroutine
//                          — you must manually wire up WaitGroups, channels, error collection
//                          — easy to leak goroutines on early return
//
// conc fixes this with three focused primitives:
//   conc.WaitGroup        — like sync.WaitGroup but with panic recovery + propagation
//   pool.Pool             — bounded goroutine pool, panics propagate safely
//   pool.ResultPool       — like Pool but collects return values
//   pool.ErrorPool        — like Pool but collects errors
//   pool.ResultErrorPool  — collects both results and errors
//   iter.ForEach          — parallel map/forEach with automatic panic recovery
//   iter.Map              — parallel transform, returns results in order
//   panics.Catcher        — low-level panic catching primitive
//
// dep: github.com/sourcegraph/conc

import (
	"errors"
	"fmt"
	"time"

	"github.com/sourcegraph/conc"
	"github.com/sourcegraph/conc/iter"
	"github.com/sourcegraph/conc/panics"
	"github.com/sourcegraph/conc/pool"
)

func main() {
	waitGroupDemo()
	poolDemo()
	resultPoolDemo()
	errorPoolDemo()
	resultErrorPoolDemo()
	iterDemo()
	panicCatcherDemo()
}

// -----------------------------------------------------------------------
// 1. conc.WaitGroup — safe WaitGroup with panic propagation
// -----------------------------------------------------------------------

func waitGroupDemo() {
	fmt.Println("=== conc.WaitGroup ===")

	var wg conc.WaitGroup

	for i := range 5 {
		wg.Go(func() {
			time.Sleep(time.Duration(i) * 10 * time.Millisecond)
			fmt.Printf("  goroutine %d done\n", i)
		})
	}

	// Wait blocks until all goroutines finish.
	// If any panicked, Wait re-panics in the calling goroutine — no silent crashes.
	wg.Wait()
	fmt.Println("all done")

	// Panic recovery in action — this is the key difference from sync.WaitGroup
	defer func() {
		if r := recover(); r != nil {
			fmt.Println("caught panic from goroutine:", r)
		}
	}()

	var wg2 conc.WaitGroup
	wg2.Go(func() {
		panic("something went wrong inside goroutine")
	})
	wg2.Wait() // re-panics here, caught by defer above
}

// -----------------------------------------------------------------------
// 2. pool.Pool — bounded goroutine pool, fire-and-forget
// -----------------------------------------------------------------------

func poolDemo() {
	fmt.Println("\n=== pool.Pool ===")

	// WithMaxGoroutines limits concurrency — like errgroup.SetLimit
	p := pool.New().WithMaxGoroutines(3)

	for i := range 8 {
		p.Go(func() {
			fmt.Printf("  pool worker %d\n", i)
			time.Sleep(20 * time.Millisecond)
		})
	}

	p.Wait() // blocks until all submitted tasks finish, propagates panics
	fmt.Println("pool done")
}

// -----------------------------------------------------------------------
// 3. pool.ResultPool — collect return values in submission order
// -----------------------------------------------------------------------

func resultPoolDemo() {
	fmt.Println("\n=== pool.ResultPool ===")

	p := pool.NewWithResults[int]().WithMaxGoroutines(4)

	inputs := []int{1, 2, 3, 4, 5, 6, 7, 8}

	for _, n := range inputs {
		p.Go(func() int {
			time.Sleep(time.Duration(10-n) * time.Millisecond) // finish out of order
			return n * n
		})
	}

	// Results returns []int in the ORDER tasks were submitted — not completion order
	results := p.Wait()
	fmt.Println("squares:", results) // [1 4 9 16 25 36 49 64]
}

// -----------------------------------------------------------------------
// 4. pool.ErrorPool — collect errors from goroutines
// -----------------------------------------------------------------------

func errorPoolDemo() {
	fmt.Println("\n=== pool.ErrorPool ===")

	p := pool.New().WithErrors().WithMaxGoroutines(3)

	tasks := []struct {
		id   int
		fail bool
	}{
		{1, false}, {2, true}, {3, false}, {4, true}, {5, false},
	}

	for _, task := range tasks {
		p.Go(func() error {
			if task.fail {
				return fmt.Errorf("task %d failed", task.id)
			}
			fmt.Printf("  task %d succeeded\n", task.id)
			return nil
		})
	}

	// Wait returns a combined error (errors.Join under the hood)
	err := p.Wait()
	if err != nil {
		fmt.Println("errors:", err)
		// Unwrap individual errors via errors.Unwrap chain
		fmt.Println("is task-2 err:", errors.Is(err, fmt.Errorf("task 2 failed")))
	}

	// WithFirstError — stop collecting after first error (like errgroup)
	p2 := pool.New().WithErrors().WithFirstError()
	p2.Go(func() error { return errors.New("first failure") })
	p2.Go(func() error { return errors.New("second failure") })
	err2 := p2.Wait()
	fmt.Println("first error only:", err2)
}

// -----------------------------------------------------------------------
// 5. pool.ResultErrorPool — collect results AND errors
// -----------------------------------------------------------------------

func resultErrorPoolDemo() {
	fmt.Println("\n=== pool.ResultErrorPool ===")

	type Result struct {
		ID    int
		Value string
	}

	p := pool.NewWithResults[Result]().WithErrors().WithMaxGoroutines(4)

	for i := range 6 {
		p.Go(func() (Result, error) {
			if i == 3 {
				return Result{}, fmt.Errorf("item %d: processing failed", i)
			}
			return Result{ID: i, Value: fmt.Sprintf("item-%d", i)}, nil
		})
	}

	results, err := p.Wait()
	fmt.Println("results:", results)
	fmt.Println("err:", err)
}

// -----------------------------------------------------------------------
// 6. iter — parallel map and forEach
// -----------------------------------------------------------------------

func iterDemo() {
	fmt.Println("\n=== iter ===")

	numbers := []int{1, 2, 3, 4, 5, 6, 7, 8}

	// iter.ForEach — parallel forEach, blocks until all done, propagates panics
	iter.ForEach(numbers, func(n *int) {
		*n = *n * 2 // double in place
	})
	fmt.Println("doubled:", numbers) // [2 4 6 8 10 12 14 16]

	// iter.Map — parallel transform, returns new slice in order
	words := []string{"hello", "world", "foo", "bar"}
	lengths := iter.Map(words, func(s *string) int {
		return len(*s)
	})
	fmt.Println("lengths:", lengths) // [5 5 3 3]

	// WithMaxGoroutines — limit concurrency on the iterator
	squares, err := iter.MapErr(numbers, func(n *int) (int, error) {
		if *n > 14 {
			return 0, fmt.Errorf("too large: %d", *n)
		}
		return (*n) * (*n), nil
	})
	fmt.Println("squares:", squares, "err:", err)
}

// -----------------------------------------------------------------------
// 7. panics.Catcher — low-level panic catching for custom primitives
// -----------------------------------------------------------------------

func panicCatcherDemo() {
	fmt.Println("\n=== panics.Catcher ===")

	var catcher panics.Catcher

	// Try — run a function, catching any panic
	catcher.Try(func() {
		panic("oops!")
	})

	// Repanic — re-panics if something was caught (use in Wait-like methods)
	// Or inspect directly:
	if val := catcher.Recovered(); val != nil {
		fmt.Println("caught:", val.Value)
		fmt.Println("stack trace available:", val.Stack != nil)
	}

	// Safe goroutine — catch and store panics from a goroutine
	var catcher2 panics.Catcher
	done := make(chan struct{})
	go func() {
		defer close(done)
		catcher2.Try(func() {
			// simulate work that might panic
			fmt.Println("goroutine working...")
		})
	}()
	<-done

	if val := catcher2.Recovered(); val != nil {
		fmt.Println("goroutine panicked:", val.Value)
	} else {
		fmt.Println("goroutine completed safely")
	}
}
