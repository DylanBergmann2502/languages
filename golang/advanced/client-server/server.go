package main

import (
	"encoding/json"
	"fmt"
	"net/http"
)

// --- Go 1.22 ServeMux: method routing + path parameters ---
//
// Before 1.22, HandleFunc("/path", h) matched any method and any sub-path.
// Now you can write "METHOD /path/{param}" and use r.PathValue("param").
// This covers the most common reason people reached for gorilla/mux.

func hello(w http.ResponseWriter, req *http.Request) {
	fmt.Fprintf(w, "hello\n")
}

func headers(w http.ResponseWriter, req *http.Request) {
	for name, vals := range req.Header {
		for _, h := range vals {
			fmt.Fprintf(w, "%v: %v\n", name, h)
		}
	}
}

// getUser handles GET /users/{id}
// r.PathValue extracts the named segment from the URL.
func getUser(w http.ResponseWriter, r *http.Request) {
	id := r.PathValue("id")
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(map[string]string{"id": id, "name": "Alice"})
}

// createUser handles POST /users — same path, different method, separate handler
func createUser(w http.ResponseWriter, r *http.Request) {
	var body map[string]any
	if err := json.NewDecoder(r.Body).Decode(&body); err != nil {
		http.Error(w, "bad request", http.StatusBadRequest)
		return
	}
	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(map[string]any{"created": body})
}

// getComment handles GET /posts/{postID}/comments/{commentID}
// Multiple named segments in one pattern.
func getComment(w http.ResponseWriter, r *http.Request) {
	postID    := r.PathValue("postID")
	commentID := r.PathValue("commentID")
	fmt.Fprintf(w, "post=%s comment=%s\n", postID, commentID)
}

// catchAll handles GET /files/{path...}
// The {path...} wildcard matches the rest of the URL including slashes.
func catchAll(w http.ResponseWriter, r *http.Request) {
	path := r.PathValue("path")
	fmt.Fprintf(w, "file path: %s\n", path)
}

func main() {
	mux := http.NewServeMux()

	// Legacy style — still works, matches any method
	mux.HandleFunc("/hello", hello)
	mux.HandleFunc("/headers", headers)

	// Go 1.22: method-prefixed patterns
	// GET /users/{id}  and  POST /users  are entirely separate handlers
	mux.HandleFunc("GET /users/{id}", getUser)
	mux.HandleFunc("POST /users", createUser)

	// Nested path parameters
	mux.HandleFunc("GET /posts/{postID}/comments/{commentID}", getComment)

	// Trailing wildcard — matches /files/a/b/c/d
	mux.HandleFunc("GET /files/{path...}", catchAll)

	// Exact match: trailing slash means "subtree"; no slash means exact
	// "GET /about"  — exact match only
	// "GET /docs/"  — matches /docs/ and everything under it
	mux.HandleFunc("GET /about", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintln(w, "about page")
	})

	fmt.Println("Listening on :8090")
	fmt.Println("  curl localhost:8090/hello")
	fmt.Println("  curl localhost:8090/users/42")
	fmt.Println("  curl -X POST localhost:8090/users -d '{\"name\":\"Bob\"}'")
	fmt.Println("  curl localhost:8090/posts/7/comments/3")
	fmt.Println("  curl localhost:8090/files/static/css/main.css")
	http.ListenAndServe(":8090", mux)
}
