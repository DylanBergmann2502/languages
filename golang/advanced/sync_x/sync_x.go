package main

// golang.org/x/sync — official Go extended sync package.
//
// Fills gaps in the stdlib sync package:
//   errgroup   — run goroutines, collect first error, cancel on failure
//   singleflight — deduplicate concurrent identical calls (cache stampede prevention)
//   semaphore  — weighted semaphore for resource limiting
//   errgroup.Group.SetLimit — cap the number of concurrent goroutines
//
// dep: golang.org/x/sync

import (
	"context"
	"errors"
	"fmt"
	"net/http"
	"time"

	"golang.org/x/sync/errgroup"
	"golang.org/x/sync/semaphore"
	"golang.org/x/sync/singleflight"
)

func main() {
	errgroupBasic()
	errgroupWithContext()
	errgroupWithLimit()
	singleflightDemo()
	semaphoreDemo()
}

// -----------------------------------------------------------------------
// 1. errgroup — the most important x/sync primitive
//    Run N goroutines; collect the first error; cancel all on first failure
// -----------------------------------------------------------------------

func errgroupBasic() {
	fmt.Println("=== errgroup basic ===")

	urls := []string{
		"https://httpbin.org/get",
		"https://httpbin.org/status/200",
		"https://httpbin.org/status/200",
	}

	var g errgroup.Group

	results := make([]int, len(urls))

	for i, url := range urls {
		// Capture loop variables — pass as arguments
		g.Go(func() error {
			resp, err := http.Get(url)
			if err != nil {
				return fmt.Errorf("fetch %s: %w", url, err)
			}
			defer resp.Body.Close()
			results[i] = resp.StatusCode
			return nil
		})
	}

	// Wait blocks until all goroutines finish; returns first non-nil error
	if err := g.Wait(); err != nil {
		fmt.Println("error:", err)
		return
	}

	fmt.Println("status codes:", results)
}

// -----------------------------------------------------------------------
// 2. errgroup with context — cancel all goroutines on first failure
// -----------------------------------------------------------------------

func errgroupWithContext() {
	fmt.Println("\n=== errgroup with context ===")

	ctx := context.Background()

	// WithContext returns a group + a derived context
	// When any goroutine returns an error, ctx is cancelled automatically
	g, ctx := errgroup.WithContext(ctx)

	results := make(chan string, 3)

	tasks := []struct {
		name  string
		delay time.Duration
		fail  bool
	}{
		{"task-1", 50 * time.Millisecond, false},
		{"task-2", 20 * time.Millisecond, true}, // this one fails
		{"task-3", 80 * time.Millisecond, false},
	}

	for _, task := range tasks {
		g.Go(func() error {
			select {
			case <-ctx.Done():
				// Another goroutine failed — bail out early
				fmt.Printf("  %s: cancelled\n", task.name)
				return ctx.Err()
			case <-time.After(task.delay):
			}

			if task.fail {
				return fmt.Errorf("%s: simulated failure", task.name)
			}

			results <- task.name + " done"
			return nil
		})
	}

	err := g.Wait()
	close(results)

	for r := range results {
		fmt.Println(" ", r)
	}
	fmt.Println("group error:", err)
}

// -----------------------------------------------------------------------
// 3. errgroup with goroutine limit — avoid spawning unbounded goroutines
// -----------------------------------------------------------------------

func errgroupWithLimit() {
	fmt.Println("\n=== errgroup with limit ===")

	g := new(errgroup.Group)
	g.SetLimit(3) // max 3 goroutines at a time

	for i := range 10 {
		g.Go(func() error {
			fmt.Printf("  worker %d running\n", i)
			time.Sleep(10 * time.Millisecond)
			return nil
		})
	}

	if err := g.Wait(); err != nil {
		fmt.Println("error:", err)
	}
	fmt.Println("all 10 tasks done (max 3 concurrent)")
}

// -----------------------------------------------------------------------
// 4. singleflight — deduplicate concurrent identical requests
//    Classic use case: cache stampede — 1000 requests miss cache simultaneously,
//    all hit the DB. singleflight makes only 1 DB call; all 1000 get the result.
// -----------------------------------------------------------------------

var sf singleflight.Group

func expensiveDBQuery(id string) (any, error) {
	fmt.Printf("  [DB] querying user %s...\n", id)
	time.Sleep(50 * time.Millisecond) // simulate slow DB
	return map[string]string{"id": id, "name": "Alice"}, nil
}

func getUser(id string) (any, error) {
	// Key must be the same for requests that should be deduplicated
	result, err, shared := sf.Do("user:"+id, func() (any, error) {
		return expensiveDBQuery(id)
	})
	if shared {
		fmt.Printf("  [cache] result shared with other callers for user %s\n", id)
	}
	return result, err
}

func singleflightDemo() {
	fmt.Println("\n=== singleflight ===")

	// Simulate 5 concurrent cache misses for the same user
	g := new(errgroup.Group)
	for range 5 {
		g.Go(func() error {
			user, err := getUser("42")
			if err != nil {
				return err
			}
			fmt.Println("  got:", user)
			return nil
		})
	}
	g.Wait()
	// DB query runs only ONCE despite 5 concurrent callers

	// DoChan — non-blocking variant, returns a channel
	ch := sf.DoChan("user:99", func() (any, error) {
		time.Sleep(20 * time.Millisecond)
		return "user-99-data", nil
	})
	res := <-ch
	fmt.Println("DoChan result:", res.Val, "shared:", res.Shared)

	// Forget — remove a key so the next call executes fresh
	sf.Forget("user:42")
}

// -----------------------------------------------------------------------
// 5. semaphore — limit concurrent access to a resource
//    More flexible than errgroup.SetLimit: supports weights (e.g., large
//    requests count as 2 slots, small ones count as 1)
// -----------------------------------------------------------------------

func semaphoreDemo() {
	fmt.Println("\n=== semaphore ===")

	// Allow at most 3 concurrent "heavy" operations
	sem := semaphore.NewWeighted(3)
	ctx := context.Background()

	var g errgroup.Group

	for i := range 8 {
		g.Go(func() error {
			// Acquire 1 slot — blocks if 3 are already held
			if err := sem.Acquire(ctx, 1); err != nil {
				return err
			}
			defer sem.Release(1)

			fmt.Printf("  worker %d running\n", i)
			time.Sleep(30 * time.Millisecond)
			fmt.Printf("  worker %d done\n", i)
			return nil
		})
	}
	g.Wait()

	// TryAcquire — non-blocking: returns false immediately if slots unavailable
	sem2 := semaphore.NewWeighted(2)
	fmt.Println("TryAcquire(1):", sem2.TryAcquire(1)) // true
	fmt.Println("TryAcquire(1):", sem2.TryAcquire(1)) // true
	fmt.Println("TryAcquire(1):", sem2.TryAcquire(1)) // false — full
	sem2.Release(2)

	// Weighted acquire — large jobs consume multiple slots
	sem3 := semaphore.NewWeighted(10)
	sem3.Acquire(ctx, 7) // heavy job takes 7 slots
	fmt.Println("TryAcquire(4) after weight-7 hold:", sem3.TryAcquire(4)) // false — only 3 left
	fmt.Println("TryAcquire(3) after weight-7 hold:", sem3.TryAcquire(3)) // true
	sem3.Release(10)

	// errgroup.SetLimit vs semaphore:
	// SetLimit      — simpler, only counts goroutines, use for most cases
	// semaphore     — use when tasks have different weights or you need TryAcquire
	_ = errors.New // keep import
}
