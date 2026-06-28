package main

import (
	"fmt"
	"sync"
	"sync/atomic"
	"time"
)

// --- sync.Once: run initialization exactly once ---

type Config struct {
	DSN string
}

var (
	config     *Config
	configOnce sync.Once
)

func getConfig() *Config {
	configOnce.Do(func() {
		fmt.Println("initializing config (runs once)")
		config = &Config{DSN: "postgres://localhost/mydb"}
	})
	return config
}

func demoOnce() {
	var wg sync.WaitGroup
	for i := 0; i < 5; i++ {
		wg.Add(1)
		go func() {
			defer wg.Done()
			cfg := getConfig()
			fmt.Println(cfg.DSN)
		}()
	}
	wg.Wait()
	// "initializing config" prints only once
	// postgres://localhost/mydb prints 5 times
}

// --- sync.Map: concurrent map with no external locking ---

func demoSyncMap() {
	var m sync.Map

	// Store
	m.Store("alice", 30)
	m.Store("bob", 25)
	m.Store("charlie", 35)

	// Load
	if val, ok := m.Load("alice"); ok {
		fmt.Println("alice:", val) // alice: 30
	}

	// LoadOrStore: returns existing value or stores and returns new
	actual, loaded := m.LoadOrStore("alice", 99)
	fmt.Println(actual, loaded) // 30 true (alice already exists)

	actual, loaded = m.LoadOrStore("diana", 28)
	fmt.Println(actual, loaded) // 28 false (diana was stored)

	// Delete
	m.Delete("bob")

	// Range over all entries
	m.Range(func(key, value any) bool {
		fmt.Printf("%v => %v\n", key, value)
		return true // return false to stop iteration
	})

	// Concurrent writes are safe without any additional locking
	var wg sync.WaitGroup
	for i := 0; i < 10; i++ {
		wg.Add(1)
		go func(n int) {
			defer wg.Done()
			m.Store(fmt.Sprintf("key%d", n), n)
		}(i)
	}
	wg.Wait()
	fmt.Println("concurrent stores complete")
}

// --- sync/atomic: lock-free atomic operations ---

func demoAtomic() {
	// atomic.Int64 (Go 1.19+)
	var counter atomic.Int64

	var wg sync.WaitGroup
	for i := 0; i < 1000; i++ {
		wg.Add(1)
		go func() {
			defer wg.Done()
			counter.Add(1)
		}()
	}
	wg.Wait()
	fmt.Println("counter:", counter.Load()) // counter: 1000

	// Compare and swap: only sets if current value matches expected
	var val atomic.Int64
	val.Store(10)
	swapped := val.CompareAndSwap(10, 20)
	fmt.Println(swapped, val.Load()) // true 20

	swapped = val.CompareAndSwap(10, 30) // 10 != 20, no swap
	fmt.Println(swapped, val.Load())     // false 20

	// atomic.Bool (Go 1.19+)
	var flag atomic.Bool
	flag.Store(true)
	fmt.Println(flag.Load()) // true
	flag.Store(false)
	fmt.Println(flag.Load()) // false

	// atomic.Value: store/load any value atomically (useful for config hot-reload)
	var av atomic.Value
	av.Store(map[string]int{"a": 1})
	loaded := av.Load().(map[string]int)
	fmt.Println(loaded) // map[a:1]
}

// --- sync.Pool: reuse expensive objects to reduce GC pressure ---

func demoPool() {
	pool := &sync.Pool{
		New: func() any {
			fmt.Println("creating new buffer")
			return make([]byte, 1024)
		},
	}

	buf := pool.Get().([]byte)
	fmt.Println("got buffer of len:", len(buf)) // 1024
	pool.Put(buf)                                // return to pool

	buf2 := pool.Get().([]byte)
	fmt.Println("got buffer of len:", len(buf2)) // 1024 (reused, no "creating" log)
	pool.Put(buf2)
}

// --- sync.Cond: coordinate goroutines waiting on a condition ---

func demoCond() {
	var mu sync.Mutex
	cond := sync.NewCond(&mu)
	ready := false

	// Worker waits until ready is true
	go func() {
		mu.Lock()
		for !ready {
			cond.Wait() // atomically releases mu and suspends
		}
		fmt.Println("worker: condition met, proceeding")
		mu.Unlock()
	}()

	time.Sleep(50 * time.Millisecond)

	mu.Lock()
	ready = true
	cond.Signal() // wake one waiting goroutine (Broadcast wakes all)
	mu.Unlock()

	time.Sleep(50 * time.Millisecond)
}

func main() {
	fmt.Println("=== sync.Once ===")
	demoOnce()

	fmt.Println("\n=== sync.Map ===")
	demoSyncMap()

	fmt.Println("\n=== sync/atomic ===")
	demoAtomic()

	fmt.Println("\n=== sync.Pool ===")
	demoPool()

	fmt.Println("\n=== sync.Cond ===")
	demoCond()
}
