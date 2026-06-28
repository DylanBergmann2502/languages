package main

import (
	"context"
	"fmt"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"
)

// Graceful shutdown pattern for an HTTP server.
// The server stops accepting new requests and waits for in-flight requests
// to finish before exiting when SIGINT or SIGTERM is received.

func main() {
	mux := http.NewServeMux()
	mux.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		time.Sleep(2 * time.Second) // simulate work
		fmt.Fprintln(w, "ok")
	})

	srv := &http.Server{
		Addr:    ":8080",
		Handler: mux,
	}

	// Channel to receive OS signals
	quit := make(chan os.Signal, 1)
	signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM)
	// signal.Stop(quit) would undo the registration

	go func() {
		fmt.Println("Server starting on :8080")
		if err := srv.ListenAndServe(); err != nil && err != http.ErrServerClosed {
			fmt.Printf("ListenAndServe: %v\n", err)
		}
	}()

	// Block until signal received
	sig := <-quit
	fmt.Printf("\nReceived signal: %v — shutting down...\n", sig)

	// Give in-flight requests up to 10 seconds to complete
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	if err := srv.Shutdown(ctx); err != nil {
		fmt.Printf("Forced shutdown: %v\n", err)
		os.Exit(1)
	}

	fmt.Println("Server exited cleanly")
	// Run: go run signals.go
	// Then: curl localhost:8080 &  and immediately Ctrl+C
	// The server waits for the in-flight request to finish before exiting
}
