package main

import (
	"context"
	"fmt"
	"log"
	"net/http"
	"time"
)

// Middleware is a function that wraps an http.Handler
type Middleware func(http.Handler) http.Handler

// Chain applies middlewares left to right:
// Chain(a, b, c)(h) = a(b(c(h)))
func Chain(middlewares ...Middleware) Middleware {
	return func(next http.Handler) http.Handler {
		for i := len(middlewares) - 1; i >= 0; i-- {
			next = middlewares[i](next)
		}
		return next
	}
}

// --- Logging middleware ---

func Logger(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		start := time.Now()
		next.ServeHTTP(w, r)
		log.Printf("%s %s %v", r.Method, r.URL.Path, time.Since(start))
	})
}

// --- Recovery middleware: catch panics and return 500 ---

func Recovery(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		defer func() {
			if err := recover(); err != nil {
				log.Printf("panic: %v", err)
				http.Error(w, "Internal Server Error", http.StatusInternalServerError)
			}
		}()
		next.ServeHTTP(w, r)
	})
}

// --- Auth middleware: check Bearer token ---

func Auth(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		token := r.Header.Get("Authorization")
		if token != "Bearer secret-token" {
			http.Error(w, "Unauthorized", http.StatusUnauthorized)
			return
		}
		next.ServeHTTP(w, r)
	})
}

// --- Request ID middleware: inject a value into context ---

type contextKey string

const requestIDKey contextKey = "requestID"

func RequestID(next http.Handler) http.Handler {
	var id int64
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		id++
		ctx := context.WithValue(r.Context(), requestIDKey, fmt.Sprintf("req-%d", id))
		next.ServeHTTP(w, r.WithContext(ctx))
	})
}

func getRequestID(ctx context.Context) string {
	if id, ok := ctx.Value(requestIDKey).(string); ok {
		return id
	}
	return "unknown"
}

// --- Handlers ---

func helloHandler(w http.ResponseWriter, r *http.Request) {
	id := getRequestID(r.Context())
	fmt.Fprintf(w, "hello from handler [%s]\n", id)
}

func panicHandler(w http.ResponseWriter, r *http.Request) {
	panic("something went wrong!")
}

func protectedHandler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintln(w, "secret data")
}

func main() {
	mux := http.NewServeMux()

	// Apply middlewares to individual routes
	mux.Handle("/hello", Chain(Logger, RequestID)(http.HandlerFunc(helloHandler)))
	mux.Handle("/panic", Chain(Logger, Recovery)(http.HandlerFunc(panicHandler)))
	mux.Handle("/protected", Chain(Logger, Auth)(http.HandlerFunc(protectedHandler)))

	// Apply a base middleware stack to the entire mux
	base := Chain(Recovery, Logger, RequestID)
	mux.HandleFunc("/public", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintln(w, "public endpoint")
	})

	server := &http.Server{
		Addr:    ":8081",
		Handler: base(mux),
	}

	fmt.Println("Server on :8081")
	fmt.Println("  GET /hello       — logged + request ID")
	fmt.Println("  GET /panic       — recovered from panic")
	fmt.Println("  GET /protected   — requires Authorization: Bearer secret-token")
	fmt.Println("  GET /public      — base middleware applied")

	log.Fatal(server.ListenAndServe())
	// curl localhost:8081/hello
	// curl localhost:8081/panic
	// curl localhost:8081/protected
	// curl -H "Authorization: Bearer secret-token" localhost:8081/protected
}
